@echo off

REM -- This is the place
C:
chdir C:\Program Files\Microsoft SQL Server\90\Tools\binn

REM -- FileName and OutputFileName
FOR /F "TOKENS=*" %%A IN ('C:\cygwin\bin\cygpath.exe -w "%1"') DO SET FN=%%A

SET OFN=
IF NOT "%2x" == "x" (
	FOR /F "TOKENS=*" %%A IN ('C:\cygwin\bin\cygpath.exe -w "%2"') DO SET OFN=%%A
)

REM -- Query String
SET QS=%3
SET QS=%QS:~1,-1%
IF "%QS%x" == "~1,-1x" (
	SET QS=
)

REM -- 1st arg present
IF NOT "%FN%x"=="x" (

	REM -- 2nd ARG not present
	IF "%OFN%x"=="x" (
		SQLCMD.EXE -S krkenv03db3 -U TemplateAdmin -P TemplateAdmin -h -1 -y 0 -i "%FN%"

	REM -- 2nd ARG present
	) ELSE (

		REM -- 3rd ARG not present 
		IF "%QS%x"=="x" (
			SQLCMD.EXE -S krkenv03db3 -U TemplateAdmin -P TemplateAdmin -h -1 -y 0 -i "%FN%" -o "%OFN%"
		
		REM -- 3rd ARG present
		) ELSE (
			SQLCMD.EXE -S krkenv03db3 -U TemplateAdmin -P TemplateAdmin -h -1 -y 0 -Q "%QS%" -o "%OFN%"

		)
	)
)

goto end
ECHO "1. %FN%x"
ECHO "2. %OFN%x"
ECHO "3. %QS%x"
:end

