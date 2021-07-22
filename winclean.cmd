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
if /i "%q%"=="y" start /wait /b powershell -Command "& {set-ExecutionPolicy Bypass -Scope Process -Force;&"""%cdir%\removeappx.ps1"""}"
set q=n
set /p q=Disable XboxPanel? (y/n): 
if /i "%q%"=="y" reg import "%cdir%\disxboxpanel.reg"
set q=n
set /p q=Remove OneDrive? (y/n): 
if /i "%q%"=="y" start /wait /b powershell -Command "& {set-ExecutionPolicy Bypass -Scope Process -Force;& """%cdir%\removeOneDrive.ps1"""}"
set q=n
set /p q=Remove 3D-objects? (y/n): 
if /i "%q%"=="y" reg import "%cdir%\remove-3dobjects.reg"
set q=n
set /p q=Enable Windows Picture viewer? (y/n): 
if /i "%q%"=="y" reg import "%cdir%\ON_Windows_10_Photo_Viewer.reg"
pause