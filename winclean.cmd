@echo off

echo +=============================================+
echo "  __    __ _         ___ _                   "
echo " / / /\ \ (_)_ __   / __| | ___  __ _ _ __   "
echo " \ \/  \/ | | '_ \ / /  | |/ _ \/ _` | '_ \  "
echo "  \  /\  /| | | | / /___| |  __| (_| | | | | "
echo "   \/  \/ |_|_| |_\____/|_|\___|\__,_|_| |_| "
echo "                                             "
echo +=============================================+
                                           
set cdir=%~dp0common
set q=n
set /p q=Remove garbage UWP-apps? (y/n): 
if /i "%q%"=="y" call :posh "%cdir%\removeappx.ps1"
set q=n
set /p q=Disable XboxPanel? (y/n): 
if /i "%q%"=="y" call :reg "%cdir%\disxboxpanel.reg"
set q=n
set /p q=Remove OneDrive? (y/n): 
if /i "%q%"=="y" call :posh "%cdir%\removeOneDrive.ps1"
set q=n
set /p q=Remove 3D-objects? (y/n): 
if /i "%q%"=="y" call :reg "%cdir%\remove-3dobjects.reg"
set q=n
set /p q=Enable Windows Picture viewer? (y/n): 
if /i "%q%"=="y" call :reg "%cdir%\ON_Windows_10_Photo_Viewer.reg"
pause
exit /b 0

:reg
reg import %1
exit /b 0

:posh
start /wait /b powershell -Command "& {set-ExecutionPolicy Bypass -Scope Process -Force;& """%~1"""}"
exit /b 0