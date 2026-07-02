@echo off
cd /d "%~dp0"
echo Starting backend on http://localhost:3500
npm run start:dev
pause
