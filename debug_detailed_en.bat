@echo off
chcp 65001 >nul
title Detailed Debug Script

echo ===== Detailed Debug VoucherLite Startup Issues =====
echo.

echo [STEP 1] Activating virtual environment...
call venv\Scripts\activate.bat
if errorlevel 1 (
    echo [ERROR] Virtual environment activation failed
    pause
    exit /b 1
)
echo [OK] Virtual environment activated successfully

echo.
echo [STEP 2] Testing config.py standalone execution...
python config.py
if errorlevel 1 (
    echo [ERROR] config.py execution failed
    pause
    exit /b 1
)
echo [OK] config.py executed successfully

echo.
echo [STEP 3] Testing app.py import...
python -c "import app; print('app.py import successful')" 2>&1
if errorlevel 1 (
    echo [ERROR] app.py import failed
    pause
    exit /b 1
)
echo [OK] app.py import successful

echo.
echo [STEP 4] Testing Flask routes...
python -c "import app; print('Route count:', len(app.app.url_map._rules))" 2>&1
if errorlevel 1 (
    echo [ERROR] Flask route test failed
    pause
    exit /b 1
)
echo [OK] Flask route test successful

echo.
echo [STEP 5] Attempting to start app.py...
echo Starting now, press Ctrl+C if it hangs...
timeout /t 3
python app.py

pause