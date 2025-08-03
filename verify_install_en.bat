REM =============================================
REM VoucherLite Installation Verification Script
REM Function: Verify VoucherLite is correctly installed
REM Author: Jinchao Fashion Supply Chain
REM Version: 2.0
REM =============================================

@echo off
REM Turn off command echo

chcp 65001 >nul
REM Set UTF-8 encoding

title VoucherLite Installation Verification Script
REM Set window title

echo =============================================
echo    VoucherLite Installation Verification Script
echo    Check if system is correctly installed and configured
echo =============================================
echo.

echo [TEST 1] Checking directory structure...
REM Check essential files and directories

if exist "app.py" (
    echo [OK] app.py found
) else (
    echo [ERROR] app.py not found
    set ERRORS=1
)

if exist "config.py" (
    echo [OK] config.py found
) else (
    echo [ERROR] config.py not found
    set ERRORS=1
)

if exist "index.html" (
    echo [OK] index.html found
) else (
    echo [ERROR] index.html not found
    set ERRORS=1
)

if exist "requirements.txt" (
    echo [OK] requirements.txt found
) else (
    echo [ERROR] requirements.txt not found
    set ERRORS=1
)

if exist "venv\" (
    echo [OK] venv directory found
) else (
    echo [ERROR] venv directory not found - run install_windows_en.bat first
    set ERRORS=1
)

if exist "static\" (
    echo [OK] static directory found
) else (
    echo [ERROR] static directory not found
    set ERRORS=1
)

echo.
echo [TEST 2] Checking Python environment...

if exist "venv\Scripts\activate.bat" (
    echo [OK] Virtual environment activation script found
    call venv\Scripts\activate.bat
    if errorlevel 1 (
        echo [ERROR] Virtual environment activation failed
        set ERRORS=1
        goto :skip_python_tests
    )
    echo [OK] Virtual environment activated
) else (
    echo [ERROR] Virtual environment activation script not found
    set ERRORS=1
    goto :skip_python_tests
)

REM Test Python
python --version >nul 2>&1
if errorlevel 1 (
    echo [ERROR] Python not available in virtual environment
    set ERRORS=1
) else (
    echo [OK] Python is available
    for /f "tokens=*" %%i in ('python --version') do echo      Version: %%i
)

REM Test pip
pip --version >nul 2>&1
if errorlevel 1 (
    echo [ERROR] pip not available
    set ERRORS=1
) else (
    echo [OK] pip is available
)

echo.
echo [TEST 3] Checking Python dependencies...

python -c "import flask" >nul 2>&1
if errorlevel 1 (
    echo [ERROR] Flask not installed
    set ERRORS=1
) else (
    echo [OK] Flask is installed
)

python -c "import qrcode" >nul 2>&1
if errorlevel 1 (
    echo [ERROR] qrcode not installed
    set ERRORS=1
) else (
    echo [OK] qrcode is installed
)

python -c "import socket" >nul 2>&1
if errorlevel 1 (
    echo [ERROR] socket module not available
    set ERRORS=1
) else (
    echo [OK] socket module is available
)

:skip_python_tests

echo.
echo [TEST 4] Checking configuration...

if exist "venv\Scripts\activate.bat" (
    call venv\Scripts\activate.bat >nul 2>&1
    python -c "from config import HOST, PORT; print(f'Host: {HOST}, Port: {PORT}')" >nul 2>&1
    if errorlevel 1 (
        echo [WARN] Configuration test failed - config.py may have issues
    ) else (
        echo [OK] Configuration file is readable
        for /f "tokens=*" %%i in ('python -c "from config import HOST, PORT; print(f'Host: {HOST}, Port: {PORT}')"') do echo      %%i
    )
)

echo.
echo =============================================
echo [RESULT] Verification Complete
echo =============================================

if defined ERRORS (
    echo.
    echo [FAILED] Installation verification failed!
    echo Some components are missing or not working correctly.
    echo.
    echo [SOLUTION] Try running:
    echo    1. clean_reinstall_en.bat (to clean and reinstall)
    echo    2. install_windows_en.bat (to install missing components)
    echo.
) else (
    echo.
    echo [SUCCESS] All verification tests passed!
    echo VoucherLite is correctly installed and ready to use.
    echo.
    echo [NEXT STEP] Run start_windows_en.bat to start the application
    echo.
)

pause