@echo off
rem Builds ResourcePackConstructor.exe with the C# compiler that ships with Windows (.NET Framework 4.x).
cd /d "%~dp0"
set CSC=%WINDIR%\Microsoft.NET\Framework64\v4.0.30319\csc.exe
if not exist "%CSC%" set CSC=%WINDIR%\Microsoft.NET\Framework\v4.0.30319\csc.exe
if not exist "%CSC%" (echo .NET Framework 4.x compiler not found & exit /b 1)
"%CSC%" /nologo /target:winexe /codepage:65001 /optimize+ ^
  /out:ResourcePackConstructor.exe ^
  /r:System.dll /r:System.Core.dll /r:System.Drawing.dll /r:System.Windows.Forms.dll ^
  /r:System.IO.Compression.dll /r:System.IO.Compression.FileSystem.dll ^
  BRPC.cs
if errorlevel 1 (echo BUILD FAILED & exit /b 1)
echo OK: ResourcePackConstructor.exe
