@echo off
rem One-click check: builds test packs with ResourcePackConstructor.exe --merge and compares the result.
chcp 65001 >nul
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0check.ps1"
echo.
pause
