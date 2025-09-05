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
echo.

REM Check if uDESK directory already exists
if exist "%USERPROFILE%\uDESK" (
    echo ⚠️  uDESK directory already exists at ~/uDESK
    echo.
    echo Options:
    echo 1) Update existing installation (git pull)
    echo 2) Destroy and start fresh (removes everything)
    echo 3) Cancel installation
    echo.
    set /p choice="Enter choice (1-3): "
    
    if "%choice%"=="1" (
        echo 📦 Will update existing installation...
    ) else if "%choice%"=="2" (
        echo 💥 Will destroy and start fresh...
        set /p confirm="Are you sure? This will delete ~/uDESK completely (y/N): "
        if /i "%confirm%"=="y" (
            echo 🗑️  Removing existing uDESK directory...
            cd /d "%USERPROFILE%"
            rmdir /s /q "%USERPROFILE%\uDESK"
            echo ✅ Directory removed
        ) else (
            echo ❌ Installation cancelled
            pause
            exit /b 1
        )
    ) else if "%choice%"=="3" (
        echo ❌ Installation cancelled
        pause
        exit /b 1
    ) else (
        echo ❌ Invalid choice. Installation cancelled
        pause
        exit /b 1
    )
) else (
    pause
)

REM Check prerequisites
echo.
echo 🔍 Checking prerequisites...

REM Check for git
git --version >nul 2>&1
if %errorlevel% neq 0 (
    echo ❌ Git not found. Please install Git for Windows:
    echo    https://git-scm.com/download/win
    echo.
    pause
    exit /b 1
)
echo ✅ Git found

REM Check for curl (should be available in Windows 10+)
curl --version >nul 2>&1
if %errorlevel% neq 0 (
    echo ❌ curl not found. Please install curl or use Windows 10+
    echo.
    pause
    exit /b 1
)
echo ✅ curl found

REM Clone or update uDESK to unified directory
echo.
if exist "%USERPROFILE%\uDESK\.git" (
    echo 🔄 Updating existing uDESK installation...
    cd /d "%USERPROFILE%\uDESK"
    git pull
) else (
    echo 📦 Downloading uDESK complete system...
    git clone https://github.com/fredporter/uDESK.git "%USERPROFILE%\uDESK"
)

REM Check if WSL is available for Linux compatibility
echo.
echo 🔧 Checking Windows Subsystem for Linux (WSL)...
wsl --version >nul 2>&1
if %errorlevel% equ 0 (
    echo ✅ WSL available - enhanced Linux compatibility
    echo.
    echo 🚀 Running installer in WSL environment...
    cd /d "%USERPROFILE%\uDESK"
    wsl bash install.sh
    
    REM Download TinyCore ISO using curl in WSL
    echo.
    echo 📀 Downloading TinyCore ISO (direct method)...
    wsl mkdir -p ~/uDESK/iso/current
    wsl curl -L --connect-timeout 15 --max-time 300 --fail --progress-bar "http://tinycorelinux.net/15.x/x86/release/TinyCore-current.iso" -o ~/uDESK/iso/current/TinyCore-current.iso.tmp
    if %errorlevel% equ 0 (
        echo ✅ TinyCore ISO downloaded successfully!
        wsl mv ~/uDESK/iso/current/TinyCore-current.iso.tmp ~/uDESK/iso/current/TinyCore-current.iso
        echo 📂 Location: ~/uDESK/iso/current/TinyCore-current.iso
    ) else (
        echo ⚠️  TinyCore ISO download failed, but uDESK will work without it
        echo    You can download it manually later from: http://tinycorelinux.net/downloads.html
        wsl rm -f ~/uDESK/iso/current/TinyCore-current.iso.tmp
    )
) else (
    echo ⚠️  WSL not available - limited functionality
    echo    For full uDESK experience, consider installing WSL:
    echo    https://docs.microsoft.com/en-us/windows/wsl/install
    echo.
    echo 📦 Setting up Windows-compatible environment...
    REM Create basic structure for Windows
    echo # uDESK Windows Installation > "%USERPROFILE%\uDESK\WINDOWS_INSTALL.txt"
    echo Installation completed in Windows mode >> "%USERPROFILE%\uDESK\WINDOWS_INSTALL.txt"
    echo For full functionality, install WSL and re-run this installer >> "%USERPROFILE%\uDESK\WINDOWS_INSTALL.txt"
)

echo.
echo 🎉 Installation Complete!
echo.
echo 📂 Your unified uDESK installation:
echo    Complete system: %USERPROFILE%\uDESK\
echo    User workspace:  %USERPROFILE%\uDESK\uMEMORY\sandbox\
echo    ISOs:           %USERPROFILE%\uDESK\iso\
echo.
echo 🔧 Testing installation...

REM Test and launch uDOS if WSL is available
wsl --version >nul 2>&1
if %errorlevel% equ 0 (
    cd /d "%USERPROFILE%\uDESK"
    if exist "%USERPROFILE%\uDESK\build\user\udos" (
        echo ✅ uDOS found - launching...
        echo.
        echo === Starting uDOS ===
        wsl ./build/user/udos || echo ⚠️  uDOS exited
    ) else (
        echo ⚠️  uDOS binary not found, trying build...
        wsl bash build.sh user
        if exist "%USERPROFILE%\uDESK\build\user\udos" (
            echo ✅ Build successful - launching uDOS...
            echo.
            echo === Starting uDOS ===
            wsl ./build/user/udos || echo ⚠️  uDOS exited
        )
    )
    echo.
    echo 🔧 To run uDOS again: cd %USERPROFILE%\uDESK && wsl ./build/user/udos
) else (
    echo 🔧 To use uDESK:
    echo    Install WSL for full functionality
    echo    Or use Windows-compatible tools
)
echo.
echo 📚 Documentation: https://github.com/fredporter/uDESK
echo.
echo 💡 To create a desktop shortcut:
echo    Copy this .bat file to your Desktop
echo.
pause
