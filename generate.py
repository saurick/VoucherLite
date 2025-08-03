import pandas as pd
import qrcode
import os
import time
from PIL import Image, ImageDraw, ImageFont
from datetime import datetime
from config import VERIFY_BASE_URL

EXCEL_FILE = "vouchers.xlsx"
QRCODE_DIR = "vouchers"
BASE_URL = VERIFY_BASE_URL

# 创建目录
os.makedirs(QRCODE_DIR, exist_ok=True)

# 初始化Excel文件
if not os.path.exists(EXCEL_FILE):
    df = pd.DataFrame(columns=["voucher_id", "date", "customer", "sku", "qty", "price", "status", "used_date"])
    df.to_excel(EXCEL_FILE, index=False)
    print(f"已创建Excel文件: {EXCEL_FILE}")

def create_voucher_image(voucher_info, qrcode_path):
    """创建电子票据图片"""
    try:
        # 加载二维码图片
        qr_img = Image.open(qrcode_path).resize((200, 200))
        
        # 创建票据背景
        img = Image.new('RGB', (500, 300), 'white')
        draw = ImageDraw.Draw(img)
        
        # 使用系统默认字体或指定字体
        try:
            # macOS中文字体
            font = ImageFont.truetype("/System/Library/Fonts/PingFang.ttc", 22)
        except:
            try:
                # 其他中文字体
                font = ImageFont.truetype("/System/Library/Fonts/STHeiti Light.ttc", 22)
            except:
                try:
                    # Windows中文字体
                    font = ImageFont.truetype("C:/Windows/Fonts/msyh.ttc", 22)
                except:
                    try:
                        # Linux中文字体
                        font = ImageFont.truetype("/usr/share/fonts/truetype/wqy/wqy-microhei.ttc", 22)
                    except:
                        # 默认字体
                        font = ImageFont.load_default()
        
        # 绘制文字信息
        draw.text((20, 20), "商家：金潮男装供应链", fill='black', font=font)
        draw.text((20, 50), f"客户：{voucher_info['customer']}", fill='black', font=font)
        draw.text((20, 80), f"款号：{voucher_info['sku']}", fill='black', font=font)
        draw.text((20, 110), f"件数：{voucher_info['qty']}", fill='black', font=font)
        draw.text((20, 140), f"金额：{voucher_info['price']} 元", fill='black', font=font)
        draw.text((20, 170), f"日期：{voucher_info['date']}", fill='black', font=font)
        draw.text((20, 200), f"凭证号：{voucher_info['voucher_id']}", fill='black', font=font)
        
        # 添加边框
        draw.rectangle([(10, 10), (490, 290)], outline='black', width=2)
        
        # 粘贴二维码
        img.paste(qr_img, (280, 50))
        
        # 保存票据图片
        voucher_path = f"{QRCODE_DIR}/{voucher_info['voucher_id']}.png"
        img.save(voucher_path)
        print(f"票据图片已保存: {voucher_path}")
        
    except Exception as e:
        print(f"创建票据图片时出错: {e}")

def generate_voucher(customer, sku, qty, price, date=None):
    """生成电子凭证"""
    try:
        # 读取现有数据
        df = pd.read_excel(EXCEL_FILE)
        
        # 生成唯一凭证号
        voucher_id = f"V{int(time.time())}"
        
        # 使用当前日期如果未指定
        if date is None:
            date = datetime.now().strftime("%Y-%m-%d")
        
        status = "未使用"
        
        # 添加新记录到Excel
        new_row = pd.DataFrame([[voucher_id, date, customer, sku, qty, price, status, ""]],
                               columns=df.columns)
        df = pd.concat([df, new_row], ignore_index=True)
        df.to_excel(EXCEL_FILE, index=False)
        print(f"凭证数据已保存到Excel: {voucher_id}")
        
        # 生成二维码
        url = BASE_URL + voucher_id
        qrcode_path = f"{QRCODE_DIR}/{voucher_id}_qr.png"
        qr = qrcode.QRCode(
            version=1,
            error_correction=qrcode.constants.ERROR_CORRECT_L,
            box_size=10,
            border=4,
        )
        qr.add_data(url)
        qr.make(fit=True)
        qr_img = qr.make_image(fill_color="black", back_color="white")
        qr_img.save(qrcode_path)
        print(f"二维码已保存: {qrcode_path}")
        
        # 创建电子票据图片
        voucher_info = {
            "voucher_id": voucher_id,
            "date": date,
            "customer": customer,
            "sku": sku,
            "qty": qty,
            "price": price
        }
        create_voucher_image(voucher_info, qrcode_path)
        
        print(f"✅ 电子凭证生成完成！")
        print(f"凭证号: {voucher_id}")
        print(f"验证链接: {url}")
        print(f"票据图片: {QRCODE_DIR}/{voucher_id}.png")
        
        return voucher_id
        
    except Exception as e:
        print(f"生成凭证时出错: {e}")
        return None

def list_vouchers():
    """列出所有凭证"""
    try:
        if os.path.exists(EXCEL_FILE):
            df = pd.read_excel(EXCEL_FILE)
            print("\n=== 凭证列表 ===")
            print(df.to_string(index=False))
        else:
            print("暂无凭证数据")
    except Exception as e:
        print(f"读取凭证数据时出错: {e}")

if __name__ == "__main__":
    print("=== VoucherLite 电子凭证生成器 ===")
    
    # 示例：生成一个测试凭证
    print("\n正在生成测试凭证...")
    generate_voucher("张三", "A001", 2, 100, "2024-08-03")
    
    # 列出所有凭证
    list_vouchers()
    
    print("\n提示：")
    print("- 可以修改main函数中的参数来生成不同的凭证")
    print("- 生成的图片在 vouchers/ 目录下")
    print("- 数据保存在 vouchers.xlsx 文件中")