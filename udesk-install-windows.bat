@echo off
REM uDESK Windows Desktop Installer
REM Download and run to install uDESK v1.0.7.2

title uDESK Windows Installer v1.0.7.2
cls
echo.
echo 🚀 uDESK Windows Installer v1.0.7.2
echo ===================================
echo.
echo This installer will:
echo • Download uDESK complete system to ~/uDESK
echo • Set up embedded uMEMORY workspace
echo • Download TinyCore Linux ISO (direct curl)
echo • Configure the unified environment
echo • Test and launch uDOS (WSL required)
echo.

REM If no uDESK directory exists, show continue prompt
if not exist "%USERPROFILE%\uDESK" (
    echo Ready to install uDESK v1.0.7.2
    set /p choice="Continue with installation? [Y]es/[N]o: "
    if /i not "%choice%"=="y" if /i not "%choice%"=="yes" (
        echo ❌ Installation cancelled
        exit /b 1
    )
)

REM Check if WSL is available for Linux compatibility
echo 🔧 Checking Windows Subsystem for Linux (WSL)...
wsl --version >nul 2>&1
if %errorlevel% equ 0 (
    echo ✅ WSL available - enhanced Linux compatibility
    echo.
    
    REM Check if we have install.sh locally
    if exist "%USERPROFILE%\uDESK\install.sh" (
        echo 🚀 Running local installer...
        cd /d "%USERPROFILE%\uDESK"
        wsl bash install.sh
    ) else (
        echo 📦 Downloading installer...
        wsl curl -L "https://raw.githubusercontent.com/fredporter/uDESK/main/install.sh" -o "/tmp/udesk-install.sh"
        wsl bash "/tmp/udesk-install.sh"
    )
) else (
    echo ❌ WSL not available - this installer requires WSL
    echo    Please install WSL first: https://docs.microsoft.com/en-us/windows/wsl/install
    echo    Then re-run this installer for full functionality
    pause
    exit /b 1
)

echo.
echo 🎉 Installation Complete!
echo.
echo 📂 Your unified uDESK installation:
echo    Complete system: %USERPROFILE%\uDESK\
echo    User workspace:  %USERPROFILE%\uDESK\uMEMORY\sandbox\
echo    ISOs:           %USERPROFILE%\uDESK\iso\
echo.
echo 📚 Documentation: https://github.com/fredporter/uDESK
echo 🔧 To run uDOS again: cd %USERPROFILE%\uDESK && wsl ./build/user/udos
echo.
echo 💡 To create a desktop shortcut:
echo    Copy this .bat file to your Desktop
echo.
pause
