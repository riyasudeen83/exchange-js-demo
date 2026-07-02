# Exchange_js Windows starter
# Run from Exchange_js project root:
# powershell -ExecutionPolicy Bypass -File .\start_all_windows.ps1

$ErrorActionPreference = "Stop"
$root = Split-Path -Parent $MyInvocation.MyCommand.Path
Set-Location $root

if (!(Test-Path ".\package.json")) {
  throw "package.json not found. Put this script inside the Exchange_js root folder."
}

Write-Host "Starting Exchange_js in three PowerShell windows..." -ForegroundColor Cyan

Start-Process powershell -ArgumentList @(
  "-NoExit",
  "-ExecutionPolicy", "Bypass",
  "-Command", "cd `"$root`"; npm run start:dev"
)

Start-Sleep -Seconds 8

Start-Process powershell -ArgumentList @(
  "-NoExit",
  "-ExecutionPolicy", "Bypass",
  "-Command", "cd `"$root\admin-web`"; npm run dev"
)

Start-Sleep -Seconds 3

Start-Process powershell -ArgumentList @(
  "-NoExit",
  "-ExecutionPolicy", "Bypass",
  "-Command", "cd `"$root\client-web`"; npm run dev"
)

Start-Sleep -Seconds 5
Start-Process "http://localhost:3500/api"
Start-Process "http://localhost:3501/admin/login"
Start-Process "http://localhost:3502"

Write-Host ""
Write-Host "Keep all three windows open." -ForegroundColor Yellow
Write-Host "Admin login: admin@fiatx.com / 123456"
