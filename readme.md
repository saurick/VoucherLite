# 优惠凭证管理系统

## 📋 项目简介

基于Flask + Vue3 + Element Plus开发的电子优惠凭证管理系统，支持凭证的创建、核销验证、图片生成等功能。

## 🛠️ 环境要求

- Python 3.8+
- 现代浏览器（支持ES6+）

## 🚀 快速开始

### 1. 创建虚拟环境

#### macOS/Linux (包括 ARM64 和 x86_64)

```bash
# 创建虚拟环境
python3 -m venv venv

# 激活虚拟环境
source venv/bin/activate
```

#### Windows

```bash
# 创建虚拟环境
python -m venv venv

# 激活虚拟环境
venv\Scripts\activate
```

#### 多架构支持

**对于 ARM64 (Apple Silicon) Mac：**
```bash
# 强制使用 ARM64 架构
arch -arm64 python3 -m venv venv_arm64
source venv_arm64/bin/activate
```

**对于 x86_64 架构（兼容模式）：**
```bash
# 强制使用 x86_64 架构（需要安装Rosetta 2）
arch -x86_64 python3 -m venv venv_x86
source venv_x86/bin/activate
```

**验证架构：**
```bash
# 查看当前Python架构
python -c "import platform; print(f'架构: {platform.machine()}')"
python -c "import platform; print(f'系统: {platform.system()} {platform.release()}')"
```

### 2. 安装依赖

```bash
# 确保虚拟环境已激活
pip install --upgrade pip
pip install flask pandas openpyxl qrcode[pil] pillow requests
```

### 3. 启动系统

```bash
# 启动Web服务器
python app.py

# 访问管理界面
# 浏览器打开: http://localhost:5001
```

### 4. 生成测试凭证

```bash
# 使用命令行生成凭证
python generate.py
```

## 🎯 主要功能

### 凭证管理
- ✅ Web界面创建凭证
- ✅ 编辑凭证信息
- ✅ 删除凭证
- ✅ 搜索和过滤
- ✅ 批量操作

### 验证核销
- ✅ 二维码扫描验证
- ✅ 链接验证
- ✅ 自动状态更新
- ✅ 使用时间记录

### 图像生成
- ✅ 二维码生成
- ✅ 凭证图片生成
- ✅ 中文字体支持
- ✅ 跨平台兼容

### 数据统计
- ✅ 实时统计面板
- ✅ 金额统计
- ✅ 使用率分析

## 🗂️ 项目结构

```
voucherLite/
├── app.py              # Flask后端服务器
├── generate.py         # 凭证生成脚本
├── index.html          # Web管理界面
├── vouchers.xlsx       # 数据存储文件
├── vouchers/           # 生成的图片目录
│   ├── V*.png         # 凭证图片
│   └── V*_qr.png      # 二维码图片
├── venv/              # Python虚拟环境
├── readme.md          # 项目说明
└── 项目状态报告.md     # 状态报告
```

## 🔧 配置说明

### 端口配置
- 默认端口：5001
- 如需修改，编辑 `app.py` 中的端口设置

### 数据存储
- 数据文件：`vouchers.xlsx`
- 图片目录：`vouchers/`
- 自动创建，无需手动配置

### 字体配置
系统自动检测并使用适合的中文字体：
- macOS：PingFang.ttc / STHeiti Light.ttc
- Windows：msyh.ttc
- Linux：wqy-microhei.ttc

## 🐳 Docker 部署

### 使用 Docker Compose（推荐）

```bash
# 构建并启动
docker-compose up -d

# 查看日志
docker-compose logs -f

# 停止服务
docker-compose down
```

### 单独使用 Docker

```bash
# 构建镜像
docker build -t voucherlite .

# 运行容器
docker run -d \
  --name voucherlite \
  -p 5001:5001 \
  -v $(pwd)/data:/app/data \
  voucherlite
```

## 🧪 测试验证

```bash
# 运行系统健康检查
curl http://localhost:5001/health

# 查看凭证列表
curl http://localhost:5001/api/list

# 验证凭证（替换YOUR_VOUCHER_ID）
curl http://localhost:5001/verify/YOUR_VOUCHER_ID
```

## 📱 使用流程

### 管理员操作流程
1. 访问 http://localhost:5001
2. 点击"新增凭证"创建凭证
3. 生成二维码或票据图片
4. 发送给客户

### 客户验证流程
1. 扫描二维码或点击验证链接
2. 查看凭证信息
3. 系统自动核销（首次验证）

## 🔒 安全特性

- ✅ 输入数据验证
- ✅ SQL注入防护
- ✅ XSS防护
- ✅ 重复核销检测
- ✅ 错误处理机制

## 📊 性能特点

- ✅ 轻量级设计
- ✅ 无数据库依赖
- ✅ 响应式界面
- ✅ 本地文件存储
- ✅ 快速部署

## 🛠️ 故障排除

### 常见问题

**1. 端口占用错误**
```bash
# 查看端口占用
lsof -i :5001
# 或更换端口
```

**2. 虚拟环境问题**
```bash
# 重新创建虚拟环境
rm -rf venv
python3 -m venv venv
source venv/bin/activate
pip install -r requirements.txt
```

**3. 权限问题**
```bash
# macOS/Linux
chmod +x app.py generate.py
```

**4. 中文字体问题**
- 确保系统安装了中文字体
- macOS：已内置中文字体
- Windows：确保有微软雅黑
- Linux：安装 `fonts-wqy-microhei`

### 日志查看

```bash
# 启动时查看详细输出
python app.py

# Docker环境查看日志
docker-compose logs -f voucherlite
```

## 📞 技术支持

### 系统要求确认
```bash
# 检查Python版本
python --version

# 检查pip版本
pip --version

# 检查虚拟环境
which python
```

### 依赖版本
- Flask >= 2.0.0
- pandas >= 1.3.0
- openpyxl >= 3.0.0
- qrcode >= 7.0.0
- Pillow >= 8.0.0

如遇问题，请检查：
1. 虚拟环境是否正确激活
2. 所有依赖是否正确安装
3. 端口是否被占用
4. 文件权限是否正确

---

*最后更新: 2025年8月3日*  
*版本: v1.0 (生产版)*
