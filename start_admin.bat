@echo off
cd /d "%~dp0admin-web"
echo Starting admin on http://localhost:3501/admin/login
npm run dev
pause
