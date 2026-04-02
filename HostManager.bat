@echo off
setlocal enabledelayedexpansion

set HOSTS_FILE=C:\Windows\System32\drivers\etc\hosts

:: Ask for domain
set /p DOMAIN=Enter domain (e.g. laravel.test): 

:: Check admin
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo Please run this script as Administrator!
    pause
    exit
)

:: Check duplicate
findstr /i "%DOMAIN%" "%HOSTS_FILE%" >nul
if %errorlevel%==0 (
    echo Domain already exists!
    pause
    exit
)

:: Temp file
set TEMP_FILE=%TEMP%\hosts_temp.txt

:: Insert after localhost with 4 spaces
(
for /f "usebackq delims=" %%A in ("%HOSTS_FILE%") do (
    echo %%A
    echo %%A | findstr /r /c:"127\.0\.0\.1[ ]*localhost" >nul
    if !errorlevel! == 0 (
        echo 127.0.0.1    %DOMAIN%
    )
)
) > "%TEMP_FILE%"

:: Replace original
copy /y "%TEMP_FILE%" "%HOSTS_FILE%" >nul
del "%TEMP_FILE%"

echo Added %DOMAIN% with proper spacing!
pause
