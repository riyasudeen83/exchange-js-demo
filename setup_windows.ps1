# Exchange_js Windows 10 clean setup
# Place this file inside the Exchange_js project root (same folder as package.json), then run:
# powershell -ExecutionPolicy Bypass -File .\setup_windows.ps1

$ErrorActionPreference = "Stop"

function Write-Step($msg) {
  Write-Host ""
  Write-Host "==== $msg ====" -ForegroundColor Cyan
}

$root = Split-Path -Parent $MyInvocation.MyCommand.Path
Set-Location $root

if (!(Test-Path ".\package.json")) {
  throw "package.json not found. Put this script inside the Exchange_js root folder."
}
if (!(Test-Path ".\admin-web\package.json")) {
  throw "admin-web\package.json not found. Check the project folder."
}
if (!(Test-Path ".\client-web\package.json")) {
  throw "client-web\package.json not found. Check the project folder."
}

Write-Step "Checking Node.js and npm"
node -v
npm -v

Write-Step "Stopping old Node processes"
Get-Process node -ErrorAction SilentlyContinue | Stop-Process -Force -ErrorAction SilentlyContinue
Start-Sleep -Seconds 2

Write-Step "Writing backend .env"
@"
API_PORT=3500
ADMIN_PORT=3501
CLIENT_PORT=3502

API_URL=http://localhost:3500
ADMIN_URL=http://localhost:3501
CLIENT_URL=http://localhost:3502

DATABASE_URL="file:./dev.db"

GOVERNANCE_DEMO_ENABLED=true
SUMSUB_MOCK_MODE=true

MFA_ENCRYPTION_KEY=0000000000000000000000000000000000000000000000000000000000000000
MFA_ISSUER=Exchange Admin

TB_ADDRESS=127.0.0.1:3003
"@ | Set-Content -Encoding UTF8 ".\.env"

Write-Step "Writing admin-web .env"
@"
VITE_API_URL=http://localhost:3500
DEV_SERVER_PORT=3501
"@ | Set-Content -Encoding UTF8 ".\admin-web\.env"

Write-Step "Writing client-web .env"
@"
VITE_API_URL=http://localhost:3500
DEV_SERVER_PORT=3502
"@ | Set-Content -Encoding UTF8 ".\client-web\.env"

Write-Step "Removing old node_modules and Vite cache"
Remove-Item -Recurse -Force ".\node_modules" -ErrorAction SilentlyContinue
Remove-Item -Recurse -Force ".\admin-web\node_modules" -ErrorAction SilentlyContinue
Remove-Item -Recurse -Force ".\client-web\node_modules" -ErrorAction SilentlyContinue
Remove-Item -Recurse -Force ".\admin-web\node_modules\.vite" -ErrorAction SilentlyContinue
Remove-Item -Recurse -Force ".\client-web\node_modules\.vite" -ErrorAction SilentlyContinue

Write-Step "Installing backend dependencies"
npm ci

Write-Step "Preparing database"
npx prisma generate
npx prisma migrate deploy
npm run db:base:sync

Write-Step "Installing admin-web dependencies"
Set-Location "$root\admin-web"
npm ci

Write-Step "Installing client-web dependencies"
Set-Location "$root\client-web"
npm ci

Set-Location $root

Write-Host ""
Write-Host "Setup completed." -ForegroundColor Green
Write-Host "Next run:"
Write-Host "  powershell -ExecutionPolicy Bypass -File .\start_all_windows.ps1"
Write-Host ""
Write-Host "URLs:"
Write-Host "  Backend API: http://localhost:3500/api"
Write-Host "  Admin:       http://localhost:3501/admin/login"
Write-Host "  Client:      http://localhost:3502"
Write-Host ""
Write-Host "Admin login:"
Write-Host "  admin@fiatx.com"
Write-Host "  123456"

