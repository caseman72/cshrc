# umask
umask 002

### Hate the beeps + others
#
set nobeep
set autolist
set color
set colorcat
set autoexpand

# set autocorrect
set complete=enhance
set correct=cmd
set rmstar

### History
#
set histdup=prev
set history=(1000 "%h\t%T\t%R\n")
set savehist=(1000 merge)
history -M


# use ansi codes to set colors via terminal attributes
# the 0 code means regular color
# the 1 code means lighten it
# the 4 code underlines
# the 5 code makes it blink or bolds it (depending on the terminal?)
# the 7 code reverses the colors
# the 8 code conceals the text
set        BLACK="%{\033[0;30m%}"
set    DARK_GRAY="%{\033[1;30m%}"
set          RED="%{\033[0;31m%}"
set    LIGHT_RED="%{\033[1;31m%}"
set        GREEN="%{\033[0;32m%}"
set  LIGHT_GREEN="%{\033[1;32m%}"
set        BROWN="%{\033[0;33m%}"
set       YELLOW="%{\033[1;33m%}"
set         BLUE="%{\033[0;34m%}"
set   LIGHT_BLUE="%{\033[1;34m%}"
set       PURPLE="%{\033[0;35m%}"
set LIGHT_PURPLE="%{\033[1;35m%}"
set         CYAN="%{\033[0;36m%}"
set   LIGHT_CYAN="%{\033[1;36m%}"
set   LIGHT_GRAY="%{\033[0;37m%}"
set        WHITE="%{\033[1;37m%}"
set      NEUTRAL="%{\033[0m%}"

# you can also add background colors with following codes
#
# Black  40
# Red    41
# Green  42
# Brown  43
# Blue   44
# Purple 45
# Cyan   46
# Gray   47
#
# So red on gray would be
set RED_ON_GRAY="%{\033[0;31;47m%}"
set YELLOW_ON_GRAY="%{\033[1;33;47m%}"
set BLACK_ON_BLACK="%{\033[1;30;40m%}"
set WHITE_ON_BLACK="%{\033[1;37;40m%}"


### Enviromental Variables
#
setenv EDITOR "vim -u ${HOME}/.vimrc" # default editor
setenv MANPAGER less                  # default manual pages pager
setenv MORE -c                        # default actions of more
setenv PAGER less                     # default system pager
setenv VISUAL "vim -u ${HOME}/.vimrc" # default visual editor
setenv LD_LIBRARY_PATH ${HOME}
setenv LANGUAGE "en_US.utf-8"
setenv LANG "en_US.utf-8"
setenv SUPPORTED "en_US:en.utf-8"     # "en_US.utf-8:en_US:en"
setenv LC_ALL "C"
setenv LC_COLLATE "C"
setenv PATH ".:/usr/sbin:/sbin:${HOME}/bin:${PATH}"
setenv TMPATH "${HOME}/tmp/"
setenv HOMEDIR "/home"

if ($?tcsh) then
  bindkey -v
  bindkey -k right complete-word-back
  bindkey -k left complete-word-fwd
  bindkey ^? backward-delete-word

  # git specifics
  set gitpath=`which git`
  set gitcmds=`ls -al $gitpath-* |wc -l`
  if ($gitcmds < 15) then
    set gitcmds=(add bisect branch checkout clone co commit diff fetch grep init log merge mv pull push rebase reset rm show save status tag undo)
  else
    set gitcmds=(`ls $gitpath-* |sed "s#/usr/bin/git-##g"`)
  endif

  complete git "p/1/($gitcmds co save undo)/" 'n/checkout/`ls-branches`/' 'n/co/`ls-branches`/' 'n/merge/`ls-branches`/'

  complete {cd,pushd,popd} 'p/1/d/'
  complete {a2v,p2v,edv,paths,unsetenv,setenv,printenv,unse,se,pe} 'p/1/e/'
  complete find 'c/-/(user group type name print exec mtime fstype perm size)/'
  complete man 'p/*/c/'
  complete vi 'p/*/t:^{core,*.[o],*.class,*.zip,*.jar,*.gz,*.dll}/'
  complete vim 'p/*/f:^{core,*.[o],*.class,*.dll}/'
  complete javac 'p/*/f:{*.java}/'
  complete unzip 'p/*/f:{*.zip,*.jar,*.xpi}/'
  complete gunzip 'p/*/f:{*.Z,*.gz}/'
  complete zcat 'p/*/f:{*.Z,*.gz,*.zip}/'
  complete mv 'p/*/f/' 'p/*/d'
  complete cp 'p/*/f/' 'p/*/d'
  complete cd. 'p/*/`ls-alias`/'
  complete sd. 'p/*/`ls-alias`/'
  complete cpfd 'p/1/`ls-saved`/'
  complete mvfd 'p/1/`ls-saved`/'
  complete ssh 'p/1/`ls-ssh`/'

  if (-f ${HOME}/.mycolors) setenv LS_COLORS `cat ${HOME}/.mycolors`
  if (-f ${HOME}/.csh.aliases) source ${HOME}/.csh.aliases

  ### Conitional hosts to specify your stuff
  #
  if ($HOST == 'rm1.rainiermedia.com') then
    setenv HOST 'softlayer'
    set PCOLOR="${RED}"

  else if ($HOST == 'Area51') then
    set PCOLOR="${GREEN}"

  else if ($HOST == 'tengen') then
    set PCOLOR="${YELLOW_ON_GRAY}"

  else if ($HOST == 'machone' || $HOST == 'machone.local') then
    setenv HOST 'machone'
    setenv PATH "/usr/local/bin:/usr/local/sbin:${HOME}/.rvm/bin:${HOME}/.gem/ruby/1.8/bin:/Developer/usr/bin/:${PATH}"
    set PCOLOR="${RED}"
    setenv EDITOR vim
    setenv VISUAL vim

    if ($?TMUX != 1) then
      tmux -2
    endif

  else if ($HOST == 'pvpdev') then
    setenv PATH "${HOME}/.rvm/bin:${HOME}/.gem/ruby/1.8/bin:${PATH}"
    set PCOLOR="${GREEN}"

  else if ($HOST == 'caseys-remote-machine') then
    setenv HOST 'rackdev'
    setenv PATH "${HOME}/.rvm/bin:${HOME}/.gem/ruby/1.8/bin:${PATH}"
    set PCOLOR="${BLUE}"

  else if ($HOST =~ 'reight') then
    set PCOLOR="${PURPLE}"

  else if ($HOST =~ ^swamp) then
    echo $HOST
    setenv HOST 'swamp'
    set PCOLOR="${RED_ON_GRAY}"

  else
    set PCOLOR="${RED}"

  endif
  set prompt="%{\033]2; ${USER}@${HOST}  [%~]\007%}${LIGHT_GRAY}~${BLACK}${USER}@${HOST} (%c) ${PCOLOR}%h%%${LIGHT_GRAY}\044${NEUTRAL} "

  if ($HOST != 'Area51') then
    ### Copy over if different cannot soft link [move to post-pull trigger]
    #
    if (-f ${HOME}/.vimperatorrc) then
      diff -wq ${HOME}/.gitclones/cshrc/vimperatorrc ${HOME}/.vimperatorrc
      if ($status != 0) then
        echo "Copying ${HOME}/.gitclones/cshrc/vimperatorrc -> ${HOME}/.vimperatorrc"
        cp -f ${HOME}/.gitclones/cshrc/vimperatorrc ${HOME}/.vimperatorrc
      endif
    endif
  endif


endif

set printexitvalue


