# =====================================================================
#             KHOASTUDY - DEEPSEEK AI SERVER LAUNCHER
# =====================================================================
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
$Host.UI.RawUI.WindowTitle = "KhoaStudy - DeepSeek AI Server"

Write-Host "=====================================================================" -ForegroundColor Green
Write-Host "                KHOASTUDY - DEEPSEEK AI SERVER" -ForegroundColor Green
Write-Host "=====================================================================" -ForegroundColor Green
Write-Host ""

$apiDir = Join-Path $PSScriptRoot "Deepseek-API"
if (-not (Test-Path $apiDir)) {
    Write-Host "[!] Khong tim thay thu muc Deepseek-API tai: $apiDir" -ForegroundColor Red
    pause
    exit 1
}

Set-Location $apiDir

# 1. Virtual Environment
$venvPython = Join-Path $apiDir "venv\Scripts\python.exe"
if (-not (Test-Path $venvPython)) {
    Write-Host "[1/4] Dang khoi tao Python venv..." -ForegroundColor Yellow
    python -m venv venv
}

Write-Host "[2/4] Kiem tra thu vien dependencies..." -ForegroundColor Cyan
& $venvPython -m pip install -q -r requirements.txt
& $venvPython -m playwright install chromium

# 2. Check Session Login & Validate Token
$sessionFile = Join-Path $apiDir "session\session.json"
$needsLogin = $true

if (Test-Path $sessionFile) {
    Write-Host "[*] Kiem tra phien dang nhap DeepSeek hien tai..." -ForegroundColor Yellow
    $testResult = & $venvPython -c "
from deepseek.client import DeepSeekClient
from deepseek.auth import get_session
try:
    c = DeepSeekClient(get_session(allow_interactive=False))
    c.create_chat_session()
    print('VALID')
except Exception as e:
    print('EXPIRED')
"
    if ($testResult -match "VALID") {
        Write-Host "[OK] Phien DeepSeek hop le, san sang phuc vu!" -ForegroundColor Green
        $needsLogin = $false
    } else {
        Write-Host "[!] Phien DeepSeek da het han token. Can dang nhap lai!" -ForegroundColor Yellow
        Remove-Item $sessionFile -Force -ErrorAction SilentlyContinue
    }
}

if ($needsLogin) {
    Write-Host ""
    Write-Host "=====================================================================" -ForegroundColor Yellow
    Write-Host "[*] DANG MO TRINH DUYET CHROMIUM..." -ForegroundColor Yellow
    Write-Host "[*] VUI LONG BAM 'LOG IN WITH GOOGLE' DE DANG NHAP TAI KHOAN DEEPSEEK." -ForegroundColor Yellow
    Write-Host "[*] Sau khi dang nhap xong va vuot xac minh, phien se tu dong luu!" -ForegroundColor Yellow
    Write-Host "=====================================================================" -ForegroundColor Yellow
    Write-Host ""
    & $venvPython -m deepseek.auth
}

# 3. Start Server
Write-Host ""
Write-Host "[3/4] Dang khoi dong DeepSeek Server tren cong 8000..." -ForegroundColor Green
Write-Host "IP mang noi bo may tinh: 192.168.2.16" -ForegroundColor Cyan
Write-Host "iPhone cung mang Wi-Fi ket noi tai: http://192.168.2.16:8000/v1" -ForegroundColor Cyan
Write-Host ""

$env:HOST = "0.0.0.0"
$env:PORT = "8000"

& $venvPython app.py
pause
