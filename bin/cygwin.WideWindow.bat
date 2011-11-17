@echo off
C:
chdir C:\cygwin\bin

bash --login -i -c "rxvt -g 142x69+150+50 -sr -sl 2000 -e screen -s \"${USER}@${HOST}\""

