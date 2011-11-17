@echo off
FOR /F "TOKENS=*" %%A IN ('C:\cygwin\bin\cygpath.exe -m "%~f1"') DO SET FN=%%A

C:
chdir C:\cygwin\bin

REM bash --login -i -c "rxvt -g 142x54+150+20 -sr -sl 2000 -title \" caseman@Area51 [%~f1]\" -e vim \"+set nowrap\" \"+set lbr\" \"%FN%\" %2"

REM mintty -p 150,20 -s 142,54 -t" caseman@Area51 [%~f1]" -e C:\cygwin\bin\bash.exe --login -i -c "vim \"+set nowrap\" \"+set lbr\" \"%FN%\" %2" -
mintty -p 150,20 -s 142,54 -t" caseman@Area51 [%~f1]" -e bash --login -i -c "vim \"+set nowrap\" \"+set lbr\" \"%FN%\" %2" -

