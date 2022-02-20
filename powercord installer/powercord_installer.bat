@echo off
TITLE Powercord Installer
:: BatchGotAdmin
:-------------------------------------
REM  --> Check for permissions
    IF "%PROCESSOR_ARCHITECTURE%" EQU "amd64" (
>nul 2>&1 "%SYSTEMROOT%\SysWOW64\cacls.exe" "%SYSTEMROOT%\SysWOW64\config\system"
) ELSE (
>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"
)

REM --> If error flag set, we do not have admin.
if '%errorlevel%' NEQ '0' (
    echo Requesting administrative privileges...
    goto UACPrompt
) else ( goto gotAdmin )

:UACPrompt
    echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin.vbs"
    set params= %*
    echo UAC.ShellExecute "cmd.exe", "/c ""%~s0"" %params:"=""%", "", "runas", 1 >> "%temp%\getadmin.vbs"

    "%temp%\getadmin.vbs"
    del "%temp%\getadmin.vbs"
    exit /B

:gotAdmin
    pushd "%CD%"
    CD /D "%~dp0"

echo Cheking if node is installed...

timeout /t 2

cls

REM  --> Install node js or if we have it already skip this

set NULL_VAL=null
set NODE_VER=%NULL_VAL%
set NODE_EXEC=node-v16.14.0-x64.msi

node -v >.tmp_nodever
set /p NODE_VER=<.tmp_nodever
del .tmp_nodever

IF "%NODE_VER%"=="%NULL_VAL%" (
	echo.
	echo Node.js is not installed! Please press a key to download and install it from the website that will open.
	PAUSE
	start "" http://nodejs.org/dist/v16.14.0/%NODE_EXEC%
	echo.
	echo.
	echo After you have installed Node.js, press a key to shut down this process. Please restart it again afterwards.
	PAUSE
	EXIT
) ELSE (
	echo A version of Node.js ^(%NODE_VER%^) is installed. Proceeding...
)
 

timeout /t 2

cls

echo Cheking if Git is installed...

timeout /t 2

cls

REM  --> Install git or if we have it skip this

if exist "C:\Program Files\Git" (goto installed) else (goto not)

:not

cls

echo You don't have installed Git! Install it clicking enter!

echo.

echo When you have it installed open another time this installer!

echo.

pause

start https://git-scm.com/downloads

cls

exit

:installed

echo A version of Git is installed. Proceeding...

timeout /t 2

cls

echo Are you sure do you want to install powercord (You have all the requirements to install it)

echo.

pause

REM  --> Install and activate powercord

cd C:\Program Files

git clone https://github.com/powercord-org/powercord

cd powercord

npm i

npm run plug
