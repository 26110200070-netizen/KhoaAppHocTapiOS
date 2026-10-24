@echo off
title "Shimy - Gemini AI Server & Backend Gateway"
powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%~dp0run_server.ps1"
if %errorlevel% neq 0 (
    echo.
    echo [!] Co loi xay ra khi chay server.
    pause
)
