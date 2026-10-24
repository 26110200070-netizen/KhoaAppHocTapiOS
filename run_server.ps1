# =====================================================================
#             SHIMY - GEMINI AI SERVER & BACKEND GATEWAY
# =====================================================================
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
$Host.UI.RawUI.WindowTitle = "Shimy - Gemini AI Server & Backend Gateway"

Write-Host "=====================================================================" -ForegroundColor Green
Write-Host "             SHIMY - GEMINI AI SERVER & BACKEND GATEWAY              " -ForegroundColor Green
Write-Host "=====================================================================" -ForegroundColor Green
Write-Host ""

# Kill any stale python/node processes on port 8000 or 4981
@(8000, 4981) | ForEach-Object {
    $p = Get-NetTCPConnection -LocalPort $_ -ErrorAction SilentlyContinue
    if ($p) {
        Write-Host "[*] Dang don dep tien trinh cu tren cong $_..." -ForegroundColor Yellow
        $p | ForEach-Object { Stop-Process -Id $_.OwningProcess -Force -ErrorAction SilentlyContinue }
        Start-Sleep -Milliseconds 500
    }
}

$backendDir = Join-Path $PSScriptRoot "backend"
$legacyDir = Join-Path $PSScriptRoot "Deepseek-API"

# Select Python Virtual Environment
$venvPython = Join-Path $backendDir "venv\Scripts\python.exe"
if (-not (Test-Path $venvPython)) {
    $legacyPython = Join-Path $legacyDir "venv\Scripts\python.exe"
    if (Test-Path $legacyPython) {
        $venvPython = $legacyPython
    } else {
        Write-Host "[1/4] Dang khoi tao Python venv tai backend\venv..." -ForegroundColor Yellow
        python -m venv (Join-Path $backendDir "venv")
        $venvPython = Join-Path $backendDir "venv\Scripts\python.exe"
    }
}

Write-Host "[1/4] Python Environment: $venvPython" -ForegroundColor Cyan
Write-Host "[2/4] Kiem tra thu vien dependencies..." -ForegroundColor Cyan
& $venvPython -m pip install -q -r (Join-Path $backendDir "requirements.txt")
& $venvPython -m playwright install chromium

# Check Session status
$sessionFile = Join-Path $backendDir "session\session.json"
$needsLogin = $true

if (Test-Path $sessionFile) {
    try {
        $sessionContent = Get-Content $sessionFile -Raw | ConvertFrom-Json
        if ($sessionContent.cookies -and $sessionContent.cookies.Length -gt 20) {
            Write-Host "[OK] Tim thay phien Google Gemini da luu san!" -ForegroundColor Green
            $needsLogin = $false
        }
    } catch {
        $needsLogin = $true
    }
}

if ($needsLogin) {
    Write-Host ""
    Write-Host "=====================================================================" -ForegroundColor Yellow
    Write-Host "[*] DANG MO TRINH DUYET CHROMIUM DE DANG NHAP GOOGLE GEMINI..." -ForegroundColor Yellow
    Write-Host "[*] Vui long dang nhap tai khoan Google cua ban tai cua so mo len." -ForegroundColor Yellow
    Write-Host "[*] Sau khi dang nhap xong, trinh duyet se tu dong dong va luu cookie!" -ForegroundColor Green
    Write-Host "=====================================================================" -ForegroundColor Yellow
    Write-Host ""
    & $venvPython -m backend.google_auth
}

# Start Backend Server
Write-Host ""
Write-Host "[3/4] Dang khoi dong Shimy Backend Server tren cong 8000..." -ForegroundColor Green
Write-Host "IP mang noi bo may tinh: 192.168.2.16" -ForegroundColor Cyan
Write-Host "iPhone cung mang Wi-Fi ket noi tai: http://192.168.2.16:8000/v1" -ForegroundColor Cyan
Write-Host ""
Write-Host "Tai khoan mac dinh tren iPhone:" -ForegroundColor Green
Write-Host " - Tên đăng nhập: khoadev     | Mật khẩu: 123456 (Role: Admin - Quota vo han)" -ForegroundColor White
Write-Host " - Tên đăng nhập: student     | Mật khẩu: 123456 (Role: Student - 150 cau/ngay)" -ForegroundColor White
Write-Host "=====================================================================" -ForegroundColor Green
Write-Host ""

$env:HOST = "0.0.0.0"
$env:PORT = "8000"
$env:PYTHONPATH = $PSScriptRoot

& $venvPython -m uvicorn backend.app:app --host 0.0.0.0 --port 8000
pause
