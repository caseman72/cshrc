#! /usr/bin/perl -w
#
# Helper Pages:
#  http://cpansearch.perl.org/src/PIA/Win32-FindWindow-0.03/lib/Win32/FindWindow.pm
#  http://www.hirax.net/misc/ruby/win32guitest/win32GuiTest.rb
#  http://perldoc.perl.org/functions/pack.html
#  http://www.piotrkaluski.com/files/winguitest/docs/ch02s04.html
#  http://www.c-sharpcorner.com/Forums/ShowMessages.aspx?ThreadID=46881
#  http://forum.winapizone.net/viewtopic.php?t=130
#  http://delphi.about.com/od/windowsshellapi/l/aa060303b.htm
#  http://www.linux.com/community/blogs/Perl-Creating-a-compiled-daemon.html
#  http://web.mit.edu/cygwin/cygwin_v1.3.2/usr/doc/Cygwin/cygrunsrv.README
#  http://www.breakingpar.com/bkp/home.nsf/0/87256B280015193F87256CFA00581AB2
#
# Requires:
#  cronolog - http://cronolog.org/download/cronolog-1.6.2.tar.gz
#
use strict;
use Readonly;
use POSIX qw(setsid);
use Win32::API;
use Win32::API::Callback;
use vars
qw/
	$bRunning
	$lLength
	$sAddr
	$sDate
	$sFullPath
	$sWindow
	$sWindow_prev
	$hDesktop
	$hWindow
	$hWindow_prev
	$hWindowUA
	$sUrlFromUA
	$hProcess
	$lParam
	$lProcessId
	$lSeconds
	$second
	$minute
	$hour
	$day
	$month
	$year
	$dayOfWeek
	$dayOfYear
	$daylightSavings
	@aVersionsIE
	@aVersionsCR
	%hashApps
	$hKey
	@aLines
/;

# Constants
Readonly::Scalar my $LOG_DIR         => '/var/log/captains/';
Readonly::Scalar my $LOG_FILE        => "|/usr/bin/cronolog ${LOG_DIR}captains.%Y-%m-%d.log";
Readonly::Scalar my $PID_FILE        => '/var/run/captains.pid';
Readonly::Scalar my $ERROR_LOG       => '>>/var/log/captains_error.log';
Readonly::Scalar my $IP_FILE         => '/tmp/captainsip.txt';
Readonly::Scalar my $PS_FILE         => '/tmp/captainsps.txt';

Readonly::Scalar my $FF_CURRENT_PAGE => $ENV{'HOME'} . "/.vimperator/info/default/current-page";

Readonly::Scalar my $MAX_STRING      => 0x00FF;
Readonly::Scalar my $WM_GETTEXT      => 0x000D;
Readonly::Scalar my $PROC_QUERYINFO  => 0x0400;
Readonly::Scalar my $PROC_READONLY   => 0x0010;
Readonly::Scalar my $SCREEN_SAVER_ON => 0x0072;
Readonly::Scalar my $PERL_LONG       => 0x0000;
Readonly::Scalar my $HANDLE_EXPIREY  => 0x012C; # 300
Readonly::Scalar my $APP_SLEEP_SEC   => 0x0001; #   1
Readonly::Scalar my $NUM_ROWS_OUTPUT => 0x000F; #  15

Readonly::Array my @IE6_WINDOWS      => ['WorkerW', 'ReBarWindow32', 'ComboBoxEx32'];
Readonly::Array my @IE7_WINDOWS      => ['WorkerW', 'ReBarWindow32', 'Address Band Root', 'ComboBoxEx32'];
Readonly::Array my @IE8_WINDOWS      => ['WorkerW', 'ReBarWindow32', 'Address Band Root', 'Edit'];
Readonly::Array my @CR_XP_WINDOWS    => ['Chrome_AutocompleteEditView'];
Readonly::Array my @CR_VISTA_WINDOWS => ['Chrome_WidgetWin_0', 'Chrome_AutocompleteEditView'];
Readonly::Array my @MONTHS => ('Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec');

# API calls
Win32::API->Import('user32',   'GetWindowTextLength',       'N',     'I');
Win32::API->Import('user32',   'GetWindowText',             'NPI',   'I');
Win32::API->Import('user32',   'GetDesktopWindow',          '',      'N');
Win32::API->Import('user32',   'OpenInputDesktop',          'LLL',   'N');
Win32::API->Import('user32',   'CloseDesktop',              'N',     'I');
Win32::API->Import('user32',   'GetForegroundWindow',       '',      'I');
Win32::API->Import('user32',   'FindWindowEx',              'NNPN',  'N');
Win32::API->Import('user32',   'SendMessage',               'LLLP',  'I');
Win32::API->Import('user32',   'GetWindowThreadProcessId',  'NP',    'N');
Win32::API->Import('user32',   'SystemParametersInfoA',     'LLPL',  'I');
Win32::API->Import('kernel32', 'OpenProcess',               'NIN',   'N');
Win32::API->Import('psapi',    'GetModuleFileNameEx',       'NNPN',  'N');
Win32::API->Import('psapi',    'GetModuleBaseName',         'NNPN',  'N');
Win32::API->Import('kernel32', 'CloseHandle',               'N',     'I');

# When you want your pipes to be piping hot, set $| to nonzero
$| = 1;

# Do this before we redirect standard out {
system("/usr/bin/wget -q http://www.manion.org/ip.htm -O $IP_FILE");
$sAddr = readFile(0, $IP_FILE);
$sAddr = '127.0.0.1' if(0 == length($sAddr));
# }

# Already running
if(-e $PID_FILE) {
	my $pid = readFile(1, $PID_FILE);
	unless(0 == length($pid) || $pid == $$) {
		system("ps -p $pid | /usr/bin/grep $pid | /usr/bin/grep perl > $PS_FILE");

		my $pidcheck = readFile(1, $PS_FILE);
		unless(0 == length($pidcheck)) {
			# Log to error log (happens frequently)
			if(open(ELOG, $ERROR_LOG)) {
				# Time variable {
				($second,$minute,$hour,$day,$month,$year,$dayOfWeek,$dayOfYear,$daylightSavings) = localtime();
				$year += 1900;
				$sDate = sprintf("[%02u/%s/%04u:%02u:%02u:%02u -0800]", $day, $MONTHS[$month], $year, $hour, $minute, $second);
				# }
				print ELOG "$sDate - Already running \{$pid\} ($PS_FILE) [$pidcheck]\n";
				close(ELOG);
			}
			exit(0);
		}
	}
}

# Write PID to file {
die("Can't write to pid file") unless(open(PID, ">$PID_FILE"));
print PID "$$\n";
close(PID);
# }

# Print last thing before quitting...
$SIG{INT} = sub {
	outputLogLine(1);
	close(LOG);
	exit;
};

###
##  Clean strings
# X
sub clean {
	my $sString = shift;

	# cleaning {
	$sString =~ s/[^ -~]+/ /g;
	$sString =~ s/^\s\s*//g;
	$sString =~ s/\s*\s$//g;
	$sString =~ s/\s+/ /g;
	# }

	return $sString;
}
sub cleanURL {
	my $sString = shift;

	# cleaning {
	$sString =~ s/^https?:\/\///;
	$sString =~ s/\?.*$//;
	$sString = join('', ' - [', $sString, ']');
	# }

	return $sString;
}
sub cleanPath {
	my $sString = shift;

	# cleaning {
	$sString =~ s/ /%20/g;
	$sString =~ s/\\/\//g;
	$sString =~ s/^([A-Z]):/\/cygdrive\/\l$1/;
	$sString =~ s/\.exe$/\//i;
	$sString =~ s/\.scr$/\/screen\/saver\//i;
	# }

	return $sString;
}


###
##  Common Input
# X
sub readFile {
	my $die = shift;
	my $file = shift;

	my $sString = '';

	if(open(FILE, $file)) {
		while(<FILE>) {
			$sString .= $_;
		}
		close(FILE);
		$sString = clean($sString);
	}
	elsif($die) {
		die("Can't read file: $file");
	}

	return $sString;
}


###
##  Common Output
# X
sub outputLogLine {

	my $force = shift;

	# Boundry conditions
	return if($lSeconds < 2 || $lSeconds > (4*$HANDLE_EXPIREY));

	# Time variable {
	($second,$minute,$hour,$day,$month,$year,$dayOfWeek,$dayOfYear,$daylightSavings) = localtime();
	$year += 1900;
	$sDate = sprintf("[%02u/%s/%04u:%02u:%02u:%02u -0800]", $day, $MONTHS[$month], $year, $hour, $minute, $second);
	# }

	if(0 == length($sUrlFromUA)) {
		# Pass this as HTTP_REFERER
		$sUrlFromUA = '-';

		# VI fix
		if($sFullPath =~ /rxvt\/$/i && $sWindow_prev =~ / vi[:]/i ) {
			$sFullPath =~ s/rxvt\/$/vi\//i;
			$sWindow_prev =~ s/ vi[:]/ /i;
		}
	}
	else {
		if($sFullPath  =~ /firefox\/$/i) {
			# Remove FF Title
			$sWindow_prev =~ s/[ ][-][ ][^-]*Mozilla Firefox$//;
		}
		elsif($sFullPath =~ /iexplore\/$/i) {
			# Remove IE Title
			$sWindow_prev =~ s/[ ][-][ ][^-]*Internet Explorer$//;
		}
		elsif($sFullPath =~ /chrome\/$/i) {
			# Remove Chrom Title
			$sWindow_prev =~ s/[ ][-][ ][^-]*Chromium$//;
		}
		$sWindow_prev .= cleanURL($sUrlFromUA);
	}

	# exceptions 
	if($sFullPath =~ /Explorer\/$/i && $sWindow_prev eq 'Program Manager') {
		# do not add to array
	}
	else {
		# add to array
		push( @aLines, 	join(' ', $sAddr, '-', '-', $sDate, '"GET', $sFullPath, 'HTTP/1.0"', 200, $lSeconds, "\"$sUrlFromUA\"", "\"$sWindow_prev\"\n"));
	}

	# Output
	if(1 == $force || $NUM_ROWS_OUTPUT <= scalar(@aLines)) {
		if(scalar(@aLines) > 0) {
			if(open(LOG, $LOG_FILE)) {
				while(scalar(@aLines) > 0) {
					print LOG shift(@aLines);
				}
				close(LOG);
			}
			elsif(1 == $force) {
				warn(join('', "FAILED TO OUTPUT: ", scalar(@aLines), " lines!"));
			}
		}
	}

	# back
	return;
}


# Init versions of IE -> reduce to 1 when a url is found {
@aVersionsIE = (@IE8_WINDOWS, @IE7_WINDOWS, @IE6_WINDOWS);
@aVersionsCR = (@CR_VISTA_WINDOWS, @CR_XP_WINDOWS);
# }

# Inits {
$lSeconds = 1;
$hWindow_prev = 0;
$sWindow_prev = 'Starting Captains Log';
$sFullPath = '/site/bin/captainslog/start/';
$sUrlFromUA = '';
@aLines = ();
# }

# Loop infinitely
while(sleep($APP_SLEEP_SEC))
{
	# Locked desktop
	$hDesktop = OpenInputDesktop($PERL_LONG, $PERL_LONG, $PERL_LONG);
	if(0 == $hDesktop) { 
		outputLogLine(1); 
		($lProcessId, $hProcess, $sFullPath, $hWindowUA, $sUrlFromUA, $lSeconds) = (0, 0, '', 0, '', 0);
		next;
	}
	else {
		CloseDesktop($hDesktop);
	}

	# Screen saver
	$bRunning = pack('P', $PERL_LONG);
  SystemParametersInfoA($SCREEN_SAVER_ON, $PERL_LONG, $bRunning, $PERL_LONG);
	$bRunning = unpack('L!', $bRunning);
	if(1 == $bRunning) { 
		outputLogLine(1);
		($lProcessId, $hProcess, $sFullPath, $hWindowUA, $sUrlFromUA, $lSeconds) = (0, 0, '', 0, '', 0);
		next;
	}

	# Counts
	$lSeconds += $APP_SLEEP_SEC;

	# Expire apps
	foreach $hKey (keys %hashApps) {
		delete($hashApps{$hKey}) if(0 > ($hashApps{$hKey}{'lExprires'} -= $APP_SLEEP_SEC));
	}

	# Top window {
	$hWindow = 0;
	$hWindow = GetForegroundWindow();
	next if(0 == $hWindow);
	# }

	# Window title {
	$sWindow = '';
	$lLength = 0;
	$sWindow = "\x0" x $MAX_STRING;
	$lLength = SendMessage($hWindow, $WM_GETTEXT, $MAX_STRING, $sWindow);
	$sWindow = clean($sWindow);
	next if(0 == length($sWindow));
	# }

	# Same window (every 5 minutes ..)
	next if($hWindow == $hWindow_prev && $sWindow eq $sWindow_prev && $lSeconds < (3*$HANDLE_EXPIREY));

	# Print!
	outputLogLine(0);

	# Set/Rest variables {
	($hWindow_prev, $sWindow_prev) = ($hWindow, $sWindow);
	($lProcessId, $hProcess, $sFullPath, $hWindowUA, $sUrlFromUA, $lSeconds) = (0, 0, '', 0, '', 0);
	# }

	# App is already present
	if(defined($hashApps{"$hWindow"})) {
		$sFullPath = $hashApps{"$hWindow"}{'sFullPath'};
		$hashApps{"$hWindow"}{'lExprires'} = $HANDLE_EXPIREY;
	}
	else {
		# Process Id {
		$lParam = pack('P', $PERL_LONG);
		GetWindowThreadProcessId($hWindow, $lParam);
		$lProcessId = unpack('L!', $lParam);
		next if(0 == $lProcessId);
		# }

		# Open process for query & read  {
		$hProcess = OpenProcess($PROC_QUERYINFO | $PROC_READONLY, $PERL_LONG, $lProcessId);
		next if(0 == $hProcess);
		# }

		# Get exe full path {
		$lLength = 0;
		$sFullPath = "\x0" x $MAX_STRING;
		$lLength = GetModuleFileNameEx($hProcess, $PERL_LONG, $sFullPath, $MAX_STRING);
		$sFullPath = cleanPath(clean($sFullPath));
		# }

		# Create app object
		$hashApps{"$hWindow"} = {
			'sFullPath' => $sFullPath,
			'lExprires' => $HANDLE_EXPIREY
		};

		# Close handle {
		CloseHandle($hProcess);
		# }
	}

	# User Agent URL help
	if($sFullPath  =~ /firefox\/$/i) {
		# Fix some json stuff {
		$sUrlFromUA = readFile(0, $FF_CURRENT_PAGE);
		$sUrlFromUA =~ s/"\].*$//;
		$sUrlFromUA =~ s/^\["//;
		# }
	}
	elsif($sFullPath =~ /iexplore\/$/i) {
		foreach(@aVersionsIE) {
			my @aVersionIE = @{$_};

			$hWindowUA = $hWindow;
			foreach(@aVersionIE) {
				last if(0 == $hWindowUA);
				$hWindowUA = FindWindowEx($hWindowUA, 0, "$_", 0);
			}
			next if(0 == $hWindowUA);

			# Found a UA Window (with URL)
			unless(1 == scalar(@aVersionsIE)) {
				@aVersionsIE = [@aVersionIE];
			}
			last;
		}
		unless(0 == $hWindowUA) {
			# Ask for the URL {
			$lLength = 0;
			$sUrlFromUA = "\x0" x $MAX_STRING;
			$lLength = SendMessage($hWindowUA, $WM_GETTEXT, $MAX_STRING, $sUrlFromUA);
			$sUrlFromUA = clean($sUrlFromUA);
			# }
		}
	}
	elsif($sFullPath =~ /chrome\/$/i) {
		foreach(@aVersionsCR) {
			my @aVersionCR = @{$_};

			$hWindowUA = $hWindow;
			foreach(@aVersionCR) {
				last if(0 == $hWindowUA);
				$hWindowUA = FindWindowEx($hWindowUA, 0, "$_", 0);
			}
			next if(0 == $hWindowUA);

			# Found a UA Window (with URL)
			unless(1 == scalar(@aVersionsCR)) {
				@aVersionsCR = [@aVersionCR];
			}
			last;
		}
		unless(0 == $hWindowUA) {
			# Ask for the URL {
			$lLength = 0;
			$sUrlFromUA = "\x0" x $MAX_STRING;
			$lLength = SendMessage($hWindowUA, $WM_GETTEXT, $MAX_STRING, $sUrlFromUA);
			$sUrlFromUA = clean($sUrlFromUA);
			# }
		}
	}
}

