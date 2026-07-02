Exchange_js Windows 10 Run Scripts

Where to place these files:
Copy all files from this ZIP into the Exchange_js project root folder, the same folder where package.json is located.

Recommended project location:
C:\ExchangeApp\Exchange_js

First-time setup:
1. Open PowerShell as normal user.
2. cd "C:\ExchangeApp\Exchange_js"
3. powershell -ExecutionPolicy Bypass -File .\setup_windows.ps1

Start application after setup:
powershell -ExecutionPolicy Bypass -File .\start_all_windows.ps1

URLs:
Backend API: http://localhost:3500/api
Admin Web:   http://localhost:3501/admin/login
Client Web:  http://localhost:3502

Admin login:
admin@fiatx.com
123456

Important:
Keep all three PowerShell windows open. If the backend window is closed, admin login will show Network error.
