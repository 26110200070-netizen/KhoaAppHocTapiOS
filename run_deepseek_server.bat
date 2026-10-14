@echo off
title KhoaStudy - DeepSeek AI Server
powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%~dp0run_server.ps1"
if %errorlevel% neq 0 (
    echo.
    echo [!] Co loi xay ra khi chay script.
    pause
)
