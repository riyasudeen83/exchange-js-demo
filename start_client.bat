@echo off
cd /d "%~dp0client-web"
echo Starting client on http://localhost:3502
npm run dev
pause
