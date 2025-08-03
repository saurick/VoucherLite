@echo off
chcp 65001 >nul
title 详细调试脚本

echo ===== 详细调试 VoucherLite 启动问题 =====
echo.

echo [步骤1] 激活虚拟环境...
call venv\Scripts\activate.bat
if errorlevel 1 (
    echo ❌ 虚拟环境激活失败
    pause
    exit /b 1
)
echo ✅ 虚拟环境激活成功

echo.
echo [步骤2] 测试config.py单独运行...
python config.py
if errorlevel 1 (
    echo ❌ config.py运行失败
    pause
    exit /b 1
)
echo ✅ config.py运行成功

echo.
echo [步骤3] 测试app.py导入...
python -c "import app; print('app.py导入成功')" 2>&1
if errorlevel 1 (
    echo ❌ app.py导入失败
    pause
    exit /b 1
)
echo ✅ app.py导入成功

echo.
echo [步骤4] 测试Flask路由...
python -c "import app; print('路由数量:', len(app.app.url_map._rules))" 2>&1
if errorlevel 1 (
    echo ❌ Flask路由测试失败
    pause
    exit /b 1
)
echo ✅ Flask路由测试成功

echo.
echo [步骤5] 尝试启动app.py...
echo 正在启动，如果卡住请按Ctrl+C...
timeout /t 3
python app.py

pause