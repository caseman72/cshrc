@echo off
C:
chdir C:\cygwin\bin

bash --login -i -c "rxvt -g 176x78+1290+10 -sr -sl 2000 -e screen -s \"${USER}@${HOST}\""

