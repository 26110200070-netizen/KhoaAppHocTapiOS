# =====================================================================
#             KHOASTUDY - DEEPSEEK AI SERVER LAUNCHER
# =====================================================================
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
$Host.UI.RawUI.WindowTitle = "KhoaStudy - DeepSeek AI Server"

Write-Host "=====================================================================" -ForegroundColor Green
Write-Host "                KHOASTUDY - DEEPSEEK AI SERVER" -ForegroundColor Green
Write-Host "=====================================================================" -ForegroundColor Green
Write-Host ""

# Kill any stale python process holding port 8000
$existingPort = Get-NetTCPConnection -LocalPort 8000 -ErrorAction SilentlyContinue
if ($existingPort) {
    Write-Host "[*] Dang don dep tien trinh cu tren cong 8000..." -ForegroundColor Yellow
    $existingPort | ForEach-Object {
        Stop-Process -Id $_.OwningProcess -Force -ErrorAction SilentlyContinue
    }
    Start-Sleep -Seconds 1
}

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

# 2. Check Session Login & Validate Token + Muted Account Status
$sessionFile = Join-Path $apiDir "session\session.json"
$profileDir = Join-Path $apiDir "session\profile"
$needsLogin = $true

if (Test-Path $sessionFile) {
    Write-Host "[*] Kiem tra trang thai tai khoan DeepSeek..." -ForegroundColor Yellow
    $testResult = & $venvPython -c "
from deepseek.client import DeepSeekClient
from deepseek.auth import get_session
try:
    c = DeepSeekClient(get_session(allow_interactive=False))
    status = c.check_user_status()
    if status.get('is_muted'):
        print('MUTED:' + str(status.get('email', '')))
    else:
        print('VALID:' + str(status.get('email', '')))
except Exception as e:
    err = str(e)
    if 'muted' in err.lower():
        print('MUTED:unknown')
    else:
        print('EXPIRED:' + err)
"
    if ($testResult -match "VALID:(.*)") {
        $email = $Matches[1].Trim()
        Write-Host "[OK] Phien DeepSeek hop le ($email). Tai khoan hoat dong tot!" -ForegroundColor Green
        $needsLogin = $false
    } elseif ($testResult -match "MUTED:(.*)") {
        $email = $Matches[1].Trim()
        Write-Host ""
        Write-Host "=====================================================================" -ForegroundColor Red
        Write-Host "[!] TAI KHOAN DEEPSEEK ($email) DANG BI TAM KHOA CHAT (MUTED)!" -ForegroundColor Red
        Write-Host "[*] DeepSeek tam khoa tai khoan nay do gioi han bao mat web." -ForegroundColor Yellow
        Write-Host "[*] Dang xoa phien cu va profile de ban dang nhap tai khoan Google khac..." -ForegroundColor Yellow
        Write-Host "=====================================================================" -ForegroundColor Red
        Remove-Item $sessionFile -Force -ErrorAction SilentlyContinue
        Remove-Item $profileDir -Recurse -Force -ErrorAction SilentlyContinue
        Start-Sleep -Seconds 2
    } else {
        Write-Host "[!] Phien DeepSeek da het han token. Can dang nhap lai!" -ForegroundColor Yellow
        Remove-Item $sessionFile -Force -ErrorAction SilentlyContinue
        Remove-Item $profileDir -Recurse -Force -ErrorAction SilentlyContinue
    }
}

if ($needsLogin) {
    Write-Host ""
    Write-Host "=====================================================================" -ForegroundColor Yellow
    Write-Host "[*] DANG MO TRINH DUYET CHROMIUM..." -ForegroundColor Yellow
    Write-Host "[*] VUI LONG BAM 'LOG IN WITH GOOGLE' VA DANG NHAP TAI KHOAN GOOGLE KHAC." -ForegroundColor Yellow
    Write-Host "[*] Sau khi dang nhap thanh cong, phien se tu dong luu va may chu se chay!" -ForegroundColor Green
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
