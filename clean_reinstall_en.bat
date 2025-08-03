@echo off
chcp 65001 >nul 2>&1
setlocal enabledelayedexpansion
title VoucherLite Complete Reinstall

echo =============================================
echo    VoucherLite Complete Reinstall Script
echo    Clean All Environment and Reinstall
echo =============================================
echo.

echo [WARNING] This will delete:
echo  - venv virtual environment directory
echo  - python local Python directory
echo.

set /p confirm=Continue with reinstall? (Y/N): 
if /i not "%confirm%"=="Y" (
    echo Reinstall cancelled
    pause
    exit /b 0
)

echo.
echo [STEP 1] Cleaning existing environment...

REM Delete virtual environment
if exist "venv\" (
    echo Deleting venv directory...
    rmdir /s /q venv >nul 2>&1
    echo [OK] venv directory deleted
) else (
    echo [INFO] venv directory does not exist
)

REM Delete local Python
if exist "python\" (
    echo Deleting python directory...
    rmdir /s /q python >nul 2>&1
    echo [OK] python directory deleted
) else (
    echo [INFO] python directory does not exist
)

REM Clean temporary files
if exist "*.tmp" del *.tmp >nul 2>&1
if exist "temp_*" del temp_* >nul 2>&1

echo.
echo [STEP 2] Starting reinstallation...
echo Calling install script...
echo.

call install_windows_en.bat

REM Check if virtual environment was created (better indicator)
if exist "venv\Scripts\activate.bat" (
    echo [OK] Virtual environment created successfully
) else (
    echo [ERROR] Virtual environment not found
    pause
    exit /b 1
)

echo.
echo [STEP 3] Verifying installation...
echo Testing startup...

call venv\Scripts\activate.bat
if errorlevel 1 (
    echo [ERROR] Virtual environment activation failed
    pause
    exit /b 1
)

python -c "print('Python environment OK')" >nul 2>&1
if errorlevel 1 (
    echo [ERROR] Python test failed
    pause
    exit /b 1
)

python -c "import flask; print('Flask OK')" >nul 2>&1
if errorlevel 1 (
    echo [ERROR] Flask test failed
    pause
    exit /b 1
)

python -c "from config import HOST, PORT; print('Config OK')" >nul 2>&1
if errorlevel 1 (
    echo [ERROR] Config test failed
    pause
    exit /b 1
)

echo [OK] All tests passed

echo.
echo =============================================
echo [SUCCESS] VoucherLite Reinstall Complete!
echo =============================================
echo.
echo [TEST] Now starting application for final test...
echo Press any key to start test...
pause

python app.py

echo.
echo Reinstall and test complete!
pause