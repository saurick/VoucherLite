REM =============================================
REM VoucherLite 启动脚本 - Windows版本
REM 功能：快速启动VoucherLite电子凭证管理系统
REM 作者：金潮男装供应链
REM 版本：2.0
REM =============================================

@echo off
REM 关闭命令回显，使输出更清洁

chcp 65001 >nul
REM 设置控制台编码为UTF-8，支持中文显示

title VoucherLite 启动脚本
REM 设置控制台窗口标题

echo ===== VoucherLite 启动脚本 =====
echo 金潮男装供应链 - 电子凭证管理系统
echo.

REM =============================================
REM 步骤1：激活Python虚拟环境
REM =============================================
echo [1] 激活虚拟环境...
call venv\Scripts\activate.bat
REM 激活虚拟环境，确保使用正确的Python和依赖包

if errorlevel 1 (
    echo ❌ 虚拟环境激活失败！
    echo 请先运行 install_windows.bat 安装环境
    pause
    exit /b 1
)
echo ✅ 虚拟环境激活成功

REM =============================================
REM 步骤2：设置环境变量
REM =============================================
echo [2] 设置环境变量...
set PYTHONIOENCODING=utf-8
REM 设置Python输入输出编码为UTF-8，避免中文乱码

REM =============================================
REM 步骤3：显示系统信息
REM =============================================
echo [3] 显示Python版本...
python --version
REM 显示当前使用的Python版本信息

echo [4] 显示当前目录...
echo 当前目录: %CD%
REM 显示脚本运行的当前目录

REM =============================================
REM 步骤4：检查必要文件
REM =============================================
echo [5] 检查关键文件...
if exist "app.py" (echo ✅ app.py存在) else (echo ❌ app.py不存在 & goto :error)
if exist "config.py" (echo ✅ config.py存在) else (echo ❌ config.py不存在 & goto :error)
if exist "index.html" (echo ✅ index.html存在) else (echo ❌ index.html不存在 & goto :error)
REM 检查Flask应用、配置文件、前端页面是否存在

echo.

REM =============================================
REM 步骤5：启动VoucherLite应用服务器
REM =============================================
echo [6] 启动VoucherLite应用...
echo 如果出现错误，会显示详细信息
echo 按Ctrl+C停止服务器
echo.

REM 获取本地IP地址并自动打开浏览器
echo [启动] 获取本地IP地址...
REM 从config.py文件中读取HOST配置，获取本地IP地址
for /f "tokens=2 delims=:" %%a in ('python -c "from config import HOST; print('IP:' + HOST)"') do set LOCAL_IP=%%a
set LOCAL_IP=%LOCAL_IP: =%
REM 去除IP地址中的空格

echo [信息] 本地访问地址: http://%LOCAL_IP%:5001
echo [浏览器] 3秒后自动打开浏览器...

REM 延迟3秒后自动打开浏览器，显示管理界面
REM 使用start命令在后台启动浏览器，不阻塞Flask服务器启动
start "" cmd /c "timeout /t 3 >nul & start http://%LOCAL_IP%:5001"

REM 启动Flask应用服务器
REM 这是主要的服务器进程，会一直运行直到用户按Ctrl+C停止
python app.py

REM =============================================
REM 清理和退出
REM =============================================
echo.
echo 服务器已停止
pause
REM 暂停等待用户按键，防止窗口立即关闭
goto :end

REM =============================================
REM 错误处理
REM =============================================
:error
echo.
echo ❌ 启动失败：缺少必要文件
echo 请确保在正确的项目目录中运行此脚本
echo 或者运行 install_windows.bat 重新安装
pause
exit /b 1

:end
REM 脚本正常结束