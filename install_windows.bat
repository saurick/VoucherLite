REM =============================================
REM VoucherLite 一键安装脚本 - Windows 10
REM 功能：自动下载Python、创建虚拟环境、安装依赖包
REM 作者：金潮男装供应链
REM 版本：2.0
REM 支持：Windows 10/11
REM =============================================

@echo off
REM 关闭命令回显，使安装过程输出更清洁

chcp 65001 >nul
REM 设置控制台编码为UTF-8，确保中文字符正确显示

echo =============================================
echo    VoucherLite 一键安装脚本 - Windows 10
echo    金潮男装供应链 电子凭证管理系统
echo =============================================
echo.
echo [运行] 开始安装VoucherLite系统...
echo 此过程将自动完成以下步骤：
echo 1. 检查或下载Python环境
echo 2. 创建Python虚拟环境
echo 3. 安装系统依赖包
echo 4. 配置网络设置
echo 5. 验证安装结果
echo.

REM =============================================
REM 步骤1: 检查或安装Python环境
REM 优先使用本地Python，如果不存在则检查系统Python
REM 如果都不存在，则自动下载Python便携版
REM =============================================
echo [步骤] [1/7] 检查Python环境...

REM 首先检查本地Python目录中是否有Python可执行文件
REM 本地Python是便携版，不依赖系统安装
if exist "python\python.exe" (
    echo [OK] 找到本地Python: python\python.exe
    python\python.exe --version
    REM 设置Python和pip命令的路径变量
    set PYTHON_CMD=python\python.exe
    set PIP_CMD=python\Scripts\pip.exe
    goto python_ready
)

REM 检查系统Python
python --version >nul 2>&1
if errorlevel 1 (
    echo [ERROR] 未检测到Python，开始自动下载安装...
    echo.
    echo [导入] 正在下载Python便携版...
    
    REM 创建python目录
    if not exist "python\" mkdir python
    
    REM 下载Python embedded版本 (3.11.9)
    echo 下载中... 请稍候（约25MB）
    powershell -Command "& {[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; Invoke-WebRequest -Uri 'https://www.python.org/ftp/python/3.11.9/python-3.11.9-embed-amd64.zip' -OutFile 'python-embed.zip' -UseBasicParsing}"
    
    if not exist "python-embed.zip" (
        echo [ERROR] Python下载失败，请检查网络连接
        pause
        exit /b 1
    )
    
    echo [OK] Python下载完成，正在解压...
    
    REM 解压Python
    powershell -Command "Expand-Archive -Path 'python-embed.zip' -DestinationPath 'python' -Force"
    
    REM 清理下载文件
    del python-embed.zip >nul 2>&1
    
    REM 配置pip
    echo [安装] 配置pip...
    
    REM 下载get-pip.py
    powershell -Command "& {[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; Invoke-WebRequest -Uri 'https://bootstrap.pypa.io/get-pip.py' -OutFile 'python\get-pip.py' -UseBasicParsing}"
    
    REM 解除路径限制
    if exist "python\python311._pth" (
        echo import site >> python\python311._pth
    )
    
    REM 安装pip
    python\python.exe python\get-pip.py --no-warn-script-location
    
    if errorlevel 1 (
        echo [ERROR] pip安装失败
        pause
        exit /b 1
    )
    
    REM 清理get-pip.py
    del python\get-pip.py >nul 2>&1
    
    REM 安装virtualenv（embedded版本需要）
    echo [安装] 安装virtualenv...
    python\python.exe -m pip install virtualenv --no-warn-script-location
    
    if errorlevel 1 (
        echo [ERROR] virtualenv安装失败
        pause
        exit /b 1
    )
    
    echo [OK] Python便携版安装完成
    set PYTHON_CMD=python\python.exe
    set PIP_CMD=python\Scripts\pip.exe
    set USE_VIRTUALENV=1
    goto python_ready
) else (
    echo [OK] 使用系统Python
    python --version
    set PYTHON_CMD=python
    set PIP_CMD=pip
    set USE_VIRTUALENV=0
)

:python_ready
echo Python配置完成: %PYTHON_CMD%
%PYTHON_CMD% --version

echo.

REM 步骤2: 创建虚拟环境
echo [安装] [2/7] 创建Python虚拟环境...
if exist "venv\" (
    echo [INFO] 虚拟环境已存在，跳过创建
) else (
    REM 检测是否需要使用virtualenv
    if defined USE_VIRTUALENV (
        echo 使用virtualenv创建虚拟环境...
        %PYTHON_CMD% -m virtualenv venv
    ) else (
        echo 使用venv创建虚拟环境...
        %PYTHON_CMD% -m venv venv
        if errorlevel 1 (
            echo [WARN]  venv失败，尝试virtualenv...
            %PYTHON_CMD% -m pip install virtualenv
            if errorlevel 1 (
                echo [ERROR] virtualenv安装失败
                pause
                exit /b 1
            )
            %PYTHON_CMD% -m virtualenv venv
        )
    )
    
    if errorlevel 1 (
        echo [ERROR] 虚拟环境创建失败
        pause
        exit /b 1
    )
    echo [OK] 虚拟环境创建成功
)

echo.

REM 步骤3: 激活虚拟环境
echo [配置] [3/7] 激活虚拟环境...
call venv\Scripts\activate.bat
if errorlevel 1 (
    echo [ERROR] 虚拟环境激活失败
    pause
    exit /b 1
)
echo [OK] 虚拟环境激活成功

echo.

REM 步骤4: 安装依赖
echo [安装] [4/7] 安装系统依赖包...
echo [INFO] 使用国内镜像源加速下载...
pip install -r requirements.txt -i https://pypi.tuna.tsinghua.edu.cn/simple/
if errorlevel 1 (
    echo [WARN]  国内镜像失败，尝试默认源...
    pip install -r requirements.txt
    if errorlevel 1 (
        echo [ERROR] 依赖包安装失败，请检查网络连接
        pause
        exit /b 1
    )
)
echo [OK] 依赖包安装完成

echo.

REM 步骤5: 测试系统配置
echo [检测] 检测系统配置 [5/6]...
set PYTHONIOENCODING=utf-8
python config.py > temp_config.txt 2>&1
if errorlevel 1 (
    echo [ERROR] 系统配置检测失败
    echo 查看错误信息:
    type temp_config.txt
    pause
    exit /b 1
)

echo [OK] 系统配置检测完成
type temp_config.txt
del temp_config.txt >nul 2>&1

echo.

REM 步骤6: 完成安装
echo [完成] [6/6] 安装完成！

echo.
echo =============================================
echo [完成] VoucherLite 安装完成！
echo =============================================
echo.
echo [步骤] 安装摘要:
echo    [OK] Python环境 - 正常
echo    [OK] 虚拟环境 - 已创建
echo    [OK] 依赖包 - 已安装
echo    [OK] 网络配置 - 已检测
echo    [OK] 系统配置 - 就绪
echo.
echo [运行] 快速启动:
echo    双击运行: start_windows.bat
echo.
echo [文档] 详细文档:
echo    参阅: Windows部署指南.md
echo.
echo [手机] 手机访问:
echo    确保手机和电脑在同一WiFi网络
echo    浏览器访问上面显示的内网IP地址
echo.
echo [灯泡] 重要提示:
echo    - 系统会自动获取内网IP，支持手机扫码
echo    - 无需配置防火墙，直接使用即可
echo    - 如遇访问问题，请检查网络连接
echo.
echo =============================================
echo     金潮男装供应链 - 电子凭证管理系统
echo =============================================

pause 