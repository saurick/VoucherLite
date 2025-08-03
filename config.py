#!/usr/bin/env python3
"""
VoucherLite 配置文件
支持自动获取内网IP地址，解决手机扫码访问问题
"""

import socket
import os
import sys

def setup_encoding():
    """设置控制台编码，确保Windows兼容性"""
    try:
        # 尝试设置UTF-8编码
        if sys.platform.startswith('win'):
            import codecs
            sys.stdout = codecs.getwriter('utf-8')(sys.stdout.buffer, 'strict')
            sys.stderr = codecs.getwriter('utf-8')(sys.stderr.buffer, 'strict')
    except Exception:
        # 如果设置失败，使用ASCII安全模式
        pass

# 设置编码
setup_encoding()

def get_local_ip():
    """获取本机内网IP地址"""
    try:
        # 创建一个UDP套接字
        sock = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
        # 连接到一个远程地址，不实际发送数据
        sock.connect(("8.8.8.8", 80))
        # 获取本地IP地址
        local_ip = sock.getsockname()[0]
        sock.close()
        return local_ip
    except Exception as e:
        print(f"获取IP地址失败，使用默认localhost: {e}")
        return "localhost"

# 基础配置
PORT = 5001

# 自动获取IP地址，也可以手动设置
HOST = os.environ.get('VOUCHER_HOST') or get_local_ip()

# 基础URL配置
BASE_URL = f"http://{HOST}:{PORT}"
VERIFY_BASE_URL = f"{BASE_URL}/verify/"

print("=== 当前服务配置 ===")
print(f"   主机地址: {HOST}")
print(f"   端口: {PORT}")
print(f"   访问地址: {BASE_URL}")
print(f"   验证URL: {VERIFY_BASE_URL}")

if HOST != "localhost":
    print(f">> 内网IP配置成功！手机可扫码访问: {BASE_URL}")
else:
    print("!! 使用localhost，仅限本机访问")
    print("提示：如需手机访问，请确保网络连接正常") 