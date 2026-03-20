@echo off
setlocal
title IT Asset Management - Admin Account Provisioning

echo ======================================================
echo           LOCAL ADMIN ACCOUNT PROVISIONING
echo ======================================================
echo.

:: 1. INPUT CREDENTIALS
set /p username="Enter New Username: "
set /p password="Enter New Password: "

echo.
echo Processing... Please wait.

:: 2. POWERSHELL EXECUTION
powershell -NoProfile -ExecutionPolicy Bypass -Command ^
    "$User = '%username%';" ^
    "$Pass = ConvertTo-SecureString '%password%' -AsPlainText -Force;" ^
    "try {" ^
    "    $NewUser = New-LocalUser -Name $User -Password $Pass -Description 'IT Support Admin' -ErrorAction Stop;" ^
    "    Add-LocalGroupMember -Group 'Administrators' -Member $User -ErrorAction Stop;" ^
    "    Set-LocalUser -Name $User -PasswordNeverExpires $true;" ^
    "    Write-Host '--------------------------------------------------' -ForegroundColor White;" ^
    "    Write-Host 'SUCCESS:' -NoNewline; Write-Host ' Account' $User 'is ready.' -ForegroundColor Green;" ^
    "    Write-Host 'STATUS:  ' -NoNewline; Write-Host 'Added to Administrators Group' -ForegroundColor Cyan;" ^
    "    Write-Host 'POLICY:  ' -NoNewline; Write-Host 'Password set to NEVER EXPIRE' -ForegroundColor Cyan;" ^
    "    Write-Host '--------------------------------------------------' -ForegroundColor White" ^
    "} catch {" ^
    "    Write-Host 'ERROR: Creation failed.' -ForegroundColor Red;" ^
    "    Write-Host 'Reason: ' $_.Exception.Message -ForegroundColor Yellow" ^
    "}"

echo.
echo ======================================================
echo Account provisioning complete.
echo ======================================================
pause