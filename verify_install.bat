REM =============================================
REM VoucherLite 安装验证脚本
REM 功能：验证VoucherLite是否正确安装
REM 作者：金潮男装供应链
REM 版本：2.0
REM =============================================

@echo off
REM 关闭命令回显

chcp 65001 >nul
REM 设置UTF-8编码

title VoucherLite 安装验证脚本
REM 设置窗口标题

echo =============================================
echo    VoucherLite 安装验证脚本
echo    检查系统是否正确安装和配置
echo =============================================
echo.

echo [CHECK 1] Virtual environment...
if exist "venv\Scripts\activate.bat" (
    echo [OK] Virtual environment exists
) else (
    echo [ERROR] Virtual environment missing
    goto :failed
)

echo [CHECK 2] Python executable...
if exist "venv\Scripts\python.exe" (
    echo [OK] Python executable exists
) else (
    echo [ERROR] Python executable missing
    goto :failed
)

echo [CHECK 3] Activate virtual environment...
call venv\Scripts\activate.bat
if errorlevel 1 (
    echo [ERROR] Cannot activate virtual environment
    goto :failed
)
echo [OK] Virtual environment activated

echo [CHECK 4] Python version...
python --version
if errorlevel 1 (
    echo [ERROR] Python not working
    goto :failed
)
echo [OK] Python working

echo [CHECK 5] Flask import...
python -c "import flask; print('Flask version:', flask.__version__)" 2>nul
if errorlevel 1 (
    echo [ERROR] Flask not installed
    goto :failed
)
echo [OK] Flask installed

echo [CHECK 6] All dependencies...
python -c "import pandas, openpyxl, qrcode, requests; print('All dependencies OK')" 2>nul
if errorlevel 1 (
    echo [ERROR] Some dependencies missing
    goto :failed
)
echo [OK] All dependencies installed

echo [CHECK 7] Config file...
python -c "from config import HOST, PORT; print('Config OK - Host:', HOST, 'Port:', PORT)" 2>nul
if errorlevel 1 (
    echo [ERROR] Config file has issues
    goto :failed
)
echo [OK] Config file working

echo [CHECK 8] App file...
if exist "app.py" (
    echo [OK] app.py exists
) else (
    echo [ERROR] app.py missing
    goto :failed
)

echo [CHECK 9] Index file...
if exist "index.html" (
    echo [OK] index.html exists
) else (
    echo [ERROR] index.html missing
    goto :failed
)

echo.
echo =============================================
echo [SUCCESS] All checks passed!
echo Installation is working correctly.
echo =============================================
echo.
echo You can now run: start_windows.bat
echo.
goto :end

:failed
echo.
echo =============================================
echo [FAILED] Installation verification failed!
echo Please run install_windows.bat again.
echo =============================================
echo.

:end
pause