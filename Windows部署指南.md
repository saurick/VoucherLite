# VoucherLite Windows 部署指南

> **金潮男装供应链** - 电子凭证管理系统 Windows 一键部署文档

## 📋 系统要求

### 最低要求
- **操作系统**: Windows 10/11 (64位)
- **内存**: 4GB RAM
- **存储**: 1GB 可用空间
- **网络**: 支持WiFi或有线网络连接

### 软件要求
- **无需预装Python** - 脚本会自动下载安装
- **网络访问** - 用于下载Python和依赖包

## 🚀 一键部署（推荐方式）

### 步骤1: 获取项目文件

1. **下载项目**
   ```
   将整个VoucherLite项目文件夹复制到Windows电脑
   确保包含以下关键文件：
   ├── app.py                    # Flask应用主程序
   ├── config.py                 # 系统配置文件
   ├── index.html                # 管理界面
   ├── requirements.txt          # Python依赖列表
   ├── install_windows.bat       # 一键安装脚本 ⭐
   ├── start_windows.bat         # 一键启动脚本 ⭐
   ├── verify_install.bat        # 安装验证脚本 ⭐
   └── static/                   # 静态资源目录
   ```

### 步骤2: 一键安装

1. **运行安装脚本**
   ```
   📁 打开VoucherLite项目文件夹
   🖱️ 双击 install_windows.bat
   ⏳ 等待安装完成（约3-5分钟）
   ```

2. **安装过程说明**
   ```
   [1/6] 检查Python环境...        # 检查或下载Python 3.11
   [2/6] 创建Python虚拟环境...    # 创建独立的Python环境
   [3/6] 激活虚拟环境...          # 激活虚拟环境
   [4/6] 安装系统依赖包...        # 安装Flask、pandas等依赖
   [5/6] 检测系统配置...          # 获取本地IP地址
   [6/6] 安装完成！               # 显示安装摘要
   ```

3. **安装成功标志**
   ```
   =============================================
   🎉 VoucherLite 安装完成！
   =============================================
   
   📋 安装摘要:
      ✅ Python环境 - 正常
      ✅ 虚拟环境 - 已创建
      ✅ 依赖包 - 已安装
      ✅ 网络配置 - 已检测
      ✅ 系统配置 - 就绪
   ```

### 步骤3: 一键启动

1. **运行启动脚本**
   ```
   🖱️ 双击 start_windows.bat
   🌐 系统会自动打开浏览器显示管理界面
   ```

2. **启动过程说明**
   ```
   [1] 激活虚拟环境...           # 激活Python环境
   [2] 设置环境变量...           # 配置UTF-8编码
   [3] 显示Python版本...         # 确认Python正常
   [4] 显示当前目录...           # 确认工作目录
   [5] 检查关键文件...           # 验证必要文件存在
   [6] 启动VoucherLite应用...    # 启动Flask服务器
   ```

3. **启动成功标志**
   ```
   [信息] 本地访问地址: http://192.168.x.x:5001
   [浏览器] 3秒后自动打开浏览器...
   
   * Running on all addresses (0.0.0.0)
   * Running on http://127.0.0.1:5001
   * Running on http://192.168.x.x:5001
   Press CTRL+C to quit
   ```

## 🔧 批处理脚本详解

### install_windows.bat - 一键安装脚本

**功能说明:**
- 自动检测Python环境，如无则下载Python 3.11便携版
- 创建独立的Python虚拟环境
- 安装所有必需的依赖包（Flask、pandas、openpyxl等）
- 配置系统网络设置
- 验证安装结果

**使用场景:**
- 首次部署系统
- 系统环境损坏需要重装
- 更新依赖包版本

**运行时间:** 约3-5分钟（取决于网络速度）

### start_windows.bat - 一键启动脚本

**功能说明:**
- 激活Python虚拟环境
- 检查必要文件完整性
- 获取本地IP地址
- 自动打开浏览器访问管理界面
- 启动Flask应用服务器

**使用场景:**
- 日常启动系统
- 重启服务
- 演示系统功能

**特色功能:**
- ✨ 自动打开浏览器，无需手动输入地址
- 🌐 使用本地IP地址，支持手机访问
- 🔍 启动前检查，确保环境完整

### verify_install.bat - 安装验证脚本

**功能说明:**
- 检查虚拟环境是否正确创建
- 验证Python和所有依赖包
- 测试配置文件和关键文件
- 提供详细的诊断信息

**使用场景:**
- 安装后验证系统状态
- 排查启动问题
- 系统健康检查

## 📱 手机访问配置

### 网络要求
1. **同一WiFi网络**
   - 确保电脑和手机连接同一个WiFi网络
   - 路由器需允许设备间通信

2. **IP地址获取**
   - 系统自动获取电脑的内网IP地址
   - 常见格式：192.168.x.x 或 10.0.x.x

### 访问方式
1. **直接访问**
   ```
   手机浏览器输入: http://192.168.x.x:5001
   (使用启动时显示的实际IP地址)
   ```

2. **二维码扫描**
   - 在管理界面生成凭证二维码
   - 手机扫描二维码直接访问验证页面

## 🚨 故障排除

### 安装问题

1. **install_windows.bat运行失败**
   ```
   可能原因：
   - 网络连接问题，无法下载Python
   - 防火墙阻止下载
   - 磁盘空间不足
   
   解决方案：
   1. 检查网络连接
   2. 暂时关闭防火墙
   3. 清理磁盘空间
   4. 以管理员身份运行脚本
   ```

2. **依赖包安装失败**
   ```
   错误信息: pip install failed
   解决方案:
   1. 脚本会自动尝试国内镜像源
   2. 检查网络连接稳定性
   3. 手动运行: pip install -r requirements.txt
   ```

### 启动问题

1. **start_windows.bat闪退**
   ```
   可能原因：
   - 虚拟环境未正确创建
   - 缺少必要文件
   
   解决方案：
   1. 运行 verify_install.bat 检查状态
   2. 重新运行 install_windows.bat
   ```

2. **端口5001被占用**
   ```
   错误信息: Address already in use
   解决方案：
   1. 重启电脑释放端口
   2. 修改config.py中的PORT值
   3. 查找并关闭占用进程: netstat -ano | findstr :5001
   ```

3. **浏览器无法自动打开**
   ```
   可能原因：
   - 默认浏览器设置问题
   - IP地址获取失败
   
   解决方案：
   1. 手动复制启动时显示的地址到浏览器
   2. 检查config.py中的IP配置
   ```

### 网络问题

1. **手机无法访问**
   ```
   检查清单:
   ✅ 电脑和手机在同一WiFi网络
   ✅ 使用正确的IP地址（不是127.0.0.1）
   ✅ 端口5001未被防火墙阻止
   ✅ 路由器允许设备间通信
   ```

2. **IP地址获取错误**
   ```
   如果显示127.0.0.1或localhost:
   1. 检查网络连接
   2. 手动设置环境变量: set VOUCHER_HOST=192.168.1.100
   3. 修改config.py文件指定IP
   ```

## 🔍 系统验证

### 验证安装完整性
```batch
# 运行验证脚本
双击 verify_install.bat

# 预期输出
[CHECK 1] Virtual environment... [OK]
[CHECK 2] Python executable... [OK]
[CHECK 3] Activate virtual environment... [OK]
[CHECK 4] Python version... [OK]
[CHECK 5] Flask import... [OK]
[CHECK 6] All dependencies... [OK]
[CHECK 7] Config file... [OK]
[CHECK 8] App file... [OK]
[CHECK 9] Index file... [OK]

[SUCCESS] All checks passed!
```

### 验证网络访问
1. **电脑访问测试**
   - 浏览器访问: http://localhost:5001
   - 应该看到VoucherLite管理界面

2. **手机访问测试**
   - 浏览器访问: http://[显示的IP地址]:5001
   - 应该看到相同的管理界面

## 🎯 日常使用流程

### 每日启动
```
1. 🖱️ 双击 start_windows.bat
2. ⏳ 等待浏览器自动打开
3. 🎉 开始使用系统
```

### 停止服务
```
1. 在启动窗口按 Ctrl+C
2. 或直接关闭命令行窗口
```

### 重新安装
```
1. 删除 venv 和 python 文件夹
2. 🖱️ 双击 install_windows.bat
3. 🖱️ 双击 start_windows.bat
```

## 📞 技术支持

### 日志收集
```batch
# 如果遇到问题，收集以下信息：

# 1. 系统信息
winver

# 2. 网络配置  
ipconfig /all

# 3. 运行验证脚本
verify_install.bat

# 4. 查看端口状态
netstat -an | findstr :5001
```

### 联系信息
- **项目名称**: VoucherLite 电子凭证管理系统
- **客户**: 金潮男装供应链
- **技术栈**: Python Flask + Vue 3 + Element Plus

---

## 🎉 部署成功

当看到以下界面时，表示部署成功：

**命令行输出:**
```
[信息] 本地访问地址: http://192.168.x.x:5001
[浏览器] 3秒后自动打开浏览器...

* Running on all addresses (0.0.0.0)
* Running on http://127.0.0.1:5001
* Running on http://192.168.x.x:5001
Press CTRL+C to quit
```

**浏览器界面:**
- 🎯 自动打开VoucherLite管理界面
- 📊 显示凭证统计信息
- 🛠️ 提供完整的凭证管理功能

**恭喜！** 现在可以：
- 💻 在电脑管理电子凭证
- 📱 手机扫描二维码验证
- 🏢 为金潮男装供应链提供数字化服务

> **提示**: 建议将start_windows.bat创建桌面快捷方式，方便日常使用！