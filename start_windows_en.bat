REM VoucherLite Startup Script - Windows Version
REM Function: Quick start VoucherLite Electronic Voucher Management System
REM Author: Jinchao Fashion Supply Chain
REM Version: 2.0

@echo off
REM Turn off command echo for cleaner output

chcp 65001 >nul
REM Set console encoding to UTF-8 for proper display

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
    echo Please run install_windows_en.bat first to set up environment
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
REM Step 3: Display system information
REM =============================================
echo [3] Checking system files...
REM Check if essential files exist
if exist "app.py" (echo [OK] app.py exists) else (echo [ERROR] app.py not found & goto :error)
if exist "config.py" (echo [OK] config.py exists) else (echo [ERROR] config.py not found & goto :error)
if exist "index.html" (echo [OK] index.html exists) else (echo [ERROR] index.html not found & goto :error)

REM =============================================
REM Step 4: Display network configuration
REM =============================================
echo [4] Getting network configuration...
echo Running config.py to detect network settings...
python config.py
if errorlevel 1 (
    echo [WARN] Network configuration detection failed
    echo This may affect mobile access functionality
)

REM =============================================
REM Step 5: Start Flask application
REM =============================================
echo.
echo ===== Starting VoucherLite Server =====
echo.
echo Usage instructions:
echo - Press Ctrl+C to stop the service
echo - Ensure phone and computer are on the same WiFi network
echo - System will automatically detect internal IP for mobile access
echo.
echo Starting Flask application server...
echo.

REM Start Flask application
python app.py

REM Check startup result
if errorlevel 1 (
    echo.
    echo [ERROR] Service startup failed!
    echo Possible causes:
    echo   1. Python environment issue
    echo   2. Missing dependencies
    echo   3. Port conflict
    echo   4. Application code error
    echo.
    echo Please try running install_windows_en.bat to reinstall
    pause
    exit /b 1
)

echo.
echo ===== Service Stopped =====
echo VoucherLite server has been stopped
echo To restart, double-click this script again
pause
exit /b 0

:error
echo [ERROR] Startup failed: Missing required files
echo.
echo Please ensure all files are in the correct location:
echo - app.py (main application)
echo - config.py (configuration script)  
echo - index.html (web interface)
echo.
echo If files are missing, please re-download the complete project
pause
exit /b 1