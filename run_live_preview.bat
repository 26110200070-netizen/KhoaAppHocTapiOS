@echo off
chcp 65001 >nul
title KhoaStudy - Realtime Live Preview Simulator
cls
echo =====================================================================
echo           KHOASTUDY - REALTIME LIVE PREVIEW SIMULATOR
echo =====================================================================
echo.
echo [*] Dang khoi dong Web Simulator tai cong 3000...
echo.
echo   [PC]     Mo trinh duyet may tinh:  http://localhost:3000
echo   [iPhone] Mo Safari tren iPhone:    http://192.168.2.16:3000
echo.
echo [*] Dang tu dong mo trinh duyet tren may tinh...
start http://localhost:3000
echo =====================================================================
echo [MEO] Nhan F5 tren trinh duyet la moi thay doi giao dien hien ngay lap tuc!
echo =====================================================================
echo.

if exist "Deepseek-API\venv\Scripts\python.exe" (
    Deepseek-API\venv\Scripts\python.exe -m http.server 3000 --directory preview --bind 0.0.0.0
) else (
    python -m http.server 3000 --directory preview --bind 0.0.0.0
)
pause
