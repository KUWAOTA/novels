@echo off
setlocal

set "SCRIPT_DIR=%~dp0"
set "PS_SCRIPT=%SCRIPT_DIR%keep_claude_alive.ps1"

if not exist "%PS_SCRIPT%" (
  echo Missing script: "%PS_SCRIPT%"
  exit /b 1
)

title Claude Remote Control Guard
echo ==================================================
echo Claude Remote Control Guard
echo ==================================================
echo Launching PowerShell watchdog...
echo.

powershell.exe -NoLogo -ExecutionPolicy Bypass -File "%PS_SCRIPT%" %*
set "EXIT_CODE=%ERRORLEVEL%"

if not "%EXIT_CODE%"=="0" (
  echo.
  echo PowerShell watchdog exited with code %EXIT_CODE%.
)

exit /b %EXIT_CODE%
