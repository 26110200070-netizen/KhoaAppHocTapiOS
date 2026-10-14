@echo off
chcp 65001 >nul
title KhoaStudy - DeepSeek API Server
echo =====================================================================
echo                KHOASTUDY - DEEPSEEK AI SERVER
echo =====================================================================
echo.
echo [1/4] Chuyển đến thư mục Deepseek-API...
cd /d "%~dp0Deepseek-API"

echo [2/4] Kiểm tra môi trường Python Virtualenv...
if not exist "venv" (
    echo [*] Đang khởi tạo môi trường venv lần đầu...
    python -m venv venv
)
call venv\Scripts\activate.bat

echo [3/4] Cài đặt các thư viện cần thiết...
pip install -r requirements.txt
playwright install chromium

if not exist "session\session.json" (
    echo.
    echo =====================================================================
    echo [!] CHƯA CÓ PHIÊN ĐĂNG NHẬP DEEPSEEK!
    echo [*] Đang mở trình duyệt Chromium...
    echo [*] VUI LÒNG BẤM "LOG IN WITH GOOGLE" ĐỂ ĐĂNG NHẬP TÀI KHOẢN CỦA BẠN.
    echo [*] Sau khi đăng nhập và vượt qua kiểm tra, phiên sẽ được lưu tự động!
    echo =====================================================================
    echo.
    python -m deepseek.auth
)

echo.
echo [4/4] Khởi động DeepSeek API Server trên cổng 8000...
echo IP mạng nội bộ của máy tính bạn: 192.168.2.16
echo iPhone cùng mạng Wi-Fi có thể kết nối tại: http://192.168.2.16:8000/v1
echo.
set HOST=0.0.0.0
set PORT=8000
python app.py
pause
