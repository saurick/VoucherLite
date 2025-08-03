REM =============================================
REM VoucherLite Startup Script - Windows Version
REM Function: Quick start VoucherLite Electronic Voucher Management System
REM Author: Jinchao Fashion Supply Chain
REM Version: 2.0
REM =============================================

@echo off
REM Turn off command echo for cleaner output

chcp 65001 >nul
REM Set console encoding to UTF-8 for proper character display

title VoucherLite Startup Script
REM Set console window title

echo ===== VoucherLite Startup Script =====
echo Jinchao Fashion Supply Chain - Electronic Voucher Management System
echo.

REM =============================================
REM Step 1: Activate Python virtual environment
REM =============================================
echo [1] Activating virtual environment...
call venv\Scripts\activate.bat
REM Activate virtual environment to ensure correct Python and dependencies

if errorlevel 1 (
    echo [ERROR] Virtual environment activation failed!
    echo Please run install_windows.bat first to set up environment
    pause
    exit /b 1
)
echo [OK] Virtual environment activated successfully

REM =============================================
REM Step 2: Set environment variables
REM =============================================
echo [2] Setting environment variables...
set PYTHONIOENCODING=utf-8
REM Set Python input/output encoding to UTF-8 to avoid character garbling

REM =============================================
REM Step 3: Set Python command and display system information
REM =============================================
echo [3] Setting Python command...

REM Priority: Use virtual environment Python first, then local Python, then system Python
if exist "venv\Scripts\python.exe" (
    set PYTHON_CMD=venv\Scripts\python.exe
    echo [INFO] Using virtual environment Python: venv\Scripts\python.exe
) else (
    if exist "python\python.exe" (
        set PYTHON_CMD=python\python.exe
        echo [INFO] Using local Python: python\python.exe
    ) else (
        set PYTHON_CMD=python
        echo [INFO] Using system Python: python
    )
)

echo [3] Displaying Python version...
%PYTHON_CMD% --version
REM Display current Python version information

echo [4] Displaying current directory...
echo Current directory: %CD%
REM Display the current directory where script is running

REM =============================================
REM Step 4: Check required files
REM =============================================
echo [5] Checking critical files...
if exist "app.py" (echo [OK] app.py exists) else (echo [ERROR] app.py not found & goto :error)
if exist "config.py" (echo [OK] config.py exists) else (echo [ERROR] config.py not found & goto :error)
if exist "index.html" (echo [OK] index.html exists) else (echo [ERROR] index.html not found & goto :error)
REM Check if Flask application, configuration file, and frontend page exist

echo.

REM =============================================
REM Step 5: Start VoucherLite application server
REM =============================================
echo [6] Starting VoucherLite application...
echo If errors occur, detailed information will be displayed
echo Press Ctrl+C to stop the server
echo.

REM Get local IP address and automatically open browser
echo [STARTUP] Getting local IP address...
REM Read HOST configuration from config.py file to get local IP address
for /f "tokens=2 delims=:" %%a in ('%PYTHON_CMD% -c "from config import HOST; print('IP:' + HOST)"') do set LOCAL_IP=%%a
set LOCAL_IP=%LOCAL_IP: =%
REM Remove spaces from IP address

echo [INFO] Local access address: http://%LOCAL_IP%:5001
echo [BROWSER] Browser will open automatically in 3 seconds...

REM Open browser automatically after 3 seconds delay to display management interface
REM Use start command to launch browser in background without blocking Flask server startup
start "" cmd /c "timeout /t 3 >nul & start http://%LOCAL_IP%:5001"

REM Start Flask application server
REM This is the main server process that will run until user presses Ctrl+C to stop
%PYTHON_CMD% app.py

REM =============================================
REM Cleanup and exit
REM =============================================
echo.
echo Server has stopped
pause
REM Pause to wait for user keypress to prevent window from closing immediately
goto :end

REM =============================================
REM Error handling
REM =============================================
:error
echo.
echo [ERROR] Startup failed: Missing required files
echo Please ensure you are running this script in the correct project directory
echo Or run install_windows.bat to reinstall
pause
exit /b 1

:end
REM Script ends normally