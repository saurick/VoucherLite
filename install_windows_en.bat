REM =============================================
REM VoucherLite One-Click Installation Script - Windows 10
REM Function: Auto download Python, create virtual environment, install dependencies
REM Author: Jinchao Fashion Supply Chain
REM Version: 2.0
REM Support: Windows 10/11
REM =============================================

@echo off
REM Turn off command echo for cleaner installation output

chcp 65001 >nul
REM Set console encoding to UTF-8 for proper character display

echo =============================================
echo    VoucherLite One-Click Installation Script - Windows 10
echo    Jinchao Fashion Supply Chain Electronic Voucher Management System
echo =============================================
echo.
echo [RUN] Starting VoucherLite system installation...
echo This process will automatically complete the following steps:
echo 1. Check or download Python environment
echo 2. Create Python virtual environment
echo 3. Install system dependencies
echo 4. Configure network settings
echo 5. Verify installation results
echo.

REM =============================================
REM Step 1: Check or install Python environment
REM Priority: use local Python, if not exist then check system Python
REM If neither exists, automatically download Python portable version
REM =============================================
echo [STEP] [1/7] Checking Python environment...

REM First check if Python executable exists in local Python directory
REM Local Python is portable version, not dependent on system installation
if exist "python\python.exe" (
    echo [OK] Found local Python: python\python.exe
    python\python.exe --version
    REM Set Python and pip command path variables
    set PYTHON_CMD=python\python.exe
    set PIP_CMD=python\Scripts\pip.exe
    goto python_ready
)

REM Check system Python
python --version >nul 2>&1
if errorlevel 1 (
    echo [ERROR] Python not detected, starting automatic download and installation...
    echo.
    echo [DOWNLOAD] Downloading Python portable version...
    
    REM Create python directory
    if not exist "python\" mkdir python
    
    REM Download Python embedded version (3.11.9)
    echo Downloading... Please wait (about 25MB)
    powershell -Command "& {[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; Invoke-WebRequest -Uri 'https://www.python.org/ftp/python/3.11.9/python-3.11.9-embed-amd64.zip' -OutFile 'python-embed.zip' -UseBasicParsing}"
    
    if not exist "python-embed.zip" (
        echo [ERROR] Python download failed, please check network connection
        pause
        exit /b 1
    )
    
    echo [OK] Python download completed, extracting...
    
    REM Extract Python
    powershell -Command "Expand-Archive -Path 'python-embed.zip' -DestinationPath 'python' -Force"
    
    REM Clean up download file
    del python-embed.zip >nul 2>&1
    
    REM Configure pip
    echo [INSTALL] Configuring pip...
    
    REM Download get-pip.py
    powershell -Command "& {[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; Invoke-WebRequest -Uri 'https://bootstrap.pypa.io/get-pip.py' -OutFile 'python\get-pip.py' -UseBasicParsing}"
    
    REM Remove path restrictions
    if exist "python\python311._pth" (
        echo import site >> python\python311._pth
    )
    
    REM Install pip
    python\python.exe python\get-pip.py --no-warn-script-location
    
    if errorlevel 1 (
        echo [ERROR] pip installation failed
        pause
        exit /b 1
    )
    
    REM Clean up get-pip.py
    del python\get-pip.py >nul 2>&1
    
    REM Install virtualenv (required for embedded version)
    echo [INSTALL] Installing virtualenv...
    python\python.exe -m pip install virtualenv --no-warn-script-location
    
    if errorlevel 1 (
        echo [ERROR] virtualenv installation failed
        pause
        exit /b 1
    )
    
    echo [OK] Python portable version installation completed
    set PYTHON_CMD=python\python.exe
    set PIP_CMD=python\Scripts\pip.exe
    set USE_VIRTUALENV=1
    goto python_ready
) else (
    echo [OK] Using system Python
    python --version
    set PYTHON_CMD=python
    set PIP_CMD=pip
    set USE_VIRTUALENV=0
)

:python_ready
echo Python configuration completed: %PYTHON_CMD%
%PYTHON_CMD% --version

echo.

REM Step 2: Create virtual environment
echo [INSTALL] [2/7] Creating Python virtual environment...
if exist "venv\" (
    echo [INFO] Virtual environment already exists, skipping creation
) else (
    REM Check if virtualenv is needed
    if defined USE_VIRTUALENV (
        echo Using virtualenv to create virtual environment...
        %PYTHON_CMD% -m virtualenv venv
    ) else (
        echo Using venv to create virtual environment...
        %PYTHON_CMD% -m venv venv
        if errorlevel 1 (
            echo [WARN] venv failed, trying virtualenv...
            %PYTHON_CMD% -m pip install virtualenv
            if errorlevel 1 (
                echo [ERROR] virtualenv installation failed
                pause
                exit /b 1
            )
            %PYTHON_CMD% -m virtualenv venv
        )
    )
    
    if errorlevel 1 (
        echo [ERROR] Virtual environment creation failed
        pause
        exit /b 1
    )
    echo [OK] Virtual environment created successfully
)

echo.

REM Step 3: Activate virtual environment
echo [CONFIG] [3/7] Activating virtual environment...
call venv\Scripts\activate.bat
if errorlevel 1 (
    echo [ERROR] Virtual environment activation failed
    pause
    exit /b 1
)
echo [OK] Virtual environment activated successfully

echo.

REM Step 4: Install dependencies
echo [INSTALL] [4/7] Installing system dependencies...
echo [INFO] Using domestic mirror for faster download...
pip install -r requirements.txt -i https://pypi.tuna.tsinghua.edu.cn/simple/
if errorlevel 1 (
    echo [WARN] Domestic mirror failed, trying default source...
    pip install -r requirements.txt
    if errorlevel 1 (
        echo [ERROR] Dependency installation failed, please check network connection
        pause
        exit /b 1
    )
)
echo [OK] Dependencies installed successfully

echo.

REM Step 5: Test system configuration
echo [TEST] Testing system configuration [5/6]...
set PYTHONIOENCODING=utf-8
python config.py > temp_config.txt 2>&1
if errorlevel 1 (
    echo [ERROR] System configuration test failed
    echo View error information:
    type temp_config.txt
    pause
    exit /b 1
)

echo [OK] System configuration test completed
type temp_config.txt
del temp_config.txt >nul 2>&1

echo.

REM Step 6: Complete installation
echo [COMPLETE] [6/6] Installation completed!

echo.
echo =============================================
echo [COMPLETE] VoucherLite Installation Finished!
echo =============================================
echo.
echo [SUMMARY] Installation summary:
echo    [OK] Python environment - Normal
echo    [OK] Virtual environment - Created
echo    [OK] Dependencies - Installed
echo    [OK] Network configuration - Detected
echo    [OK] System configuration - Ready
echo.
echo [RUN] Quick start:
echo    Double-click: start_windows_en.bat
echo.
echo [DOCS] Detailed documentation:
echo    See: Windows deployment guide.md
echo.
echo [MOBILE] Mobile access:
echo    Ensure phone and computer are on the same WiFi network
echo    Access the internal IP address shown above in browser
echo.
echo [TIPS] Important notes:
echo    - System will automatically get internal IP, supports mobile QR code
echo    - No firewall configuration needed, ready to use
echo    - If access problems occur, please check network connection
echo.
echo =============================================
echo     Jinchao Fashion Supply Chain
echo     Electronic Voucher Management System
echo =============================================

pause