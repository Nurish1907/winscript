@echo off
setlocal
title IT Infrastructure - GPO Bypass ^& Optimization

echo ======================================================
echo          SYSTEM OPTIMIZATION ^& GPO BYPASS
echo ======================================================
echo.

:: 1. CREATE SYSTEM RESTORE POINT
echo --- 1. ATTEMPTING SAFETY RESTORE POINT ---
powershell -NoProfile -ExecutionPolicy Bypass -Command ^
    "try { Checkpoint-Computer -Description 'Before_IT_Cleanup' -RestorePointType 'MODIFY_SETTINGS' -ErrorAction SilentlyContinue } catch { }"
echo Snapshot phase complete.

:: 2. RUN DIAGNOSTICS ^& REBOOT CHECK
echo.
powershell -NoProfile -ExecutionPolicy Bypass -Command ^
    "$CPU = Get-Counter '\Processor(_Total)\%% Processor Time' -SampleInterval 1 -MaxSamples 2;" ^
    "$CPUAvg = [Math]::Round(($CPU.CounterSamples.CookedValue | Measure-Object -Average).Average, 2);" ^
    "$Disk = Get-CimInstance Win32_LogicalDisk -Filter \"DeviceID='C:'\";" ^
    "$FreeGB = [Math]::Round($Disk.FreeSpace / 1GB, 2);" ^
    "$PendingReboot = (Test-Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Component Based Servicing\RebootPending') -or (Test-Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsUpdate\Auto Update\RebootRequired');" ^
    "$CPUColor = if ($CPUAvg -gt 80) { 'Red' } else { 'Green' };" ^
    "$DiskColor = if ($FreeGB -lt 10) { 'Red' } else { 'Green' };" ^
    "Write-Host '--- 2. ANALYSIS ---' -ForegroundColor Yellow;" ^
    "Write-Host 'Current CPU Load: ' -NoNewline; Write-Host \"$CPUAvg %%\" -ForegroundColor $CPUColor;" ^
    "Write-Host 'C: Drive Space:  ' -NoNewline; Write-Host \"$FreeGB GB Free\" -ForegroundColor $DiskColor;" ^
    "if ($PendingReboot) { Write-Host 'ALERT: SYSTEM REBOOT IS PENDING' -ForegroundColor Yellow } else { Write-Host 'No reboot pending.' -ForegroundColor Green }"

:: 3. DEEP CLEANUP
echo.
echo --- 3. RUNNING DEEP CLEANUP ---
del /s /f /q %temp%\*.* >nul 2>&1
del /s /f /q C:\Windows\Temp\*.* >nul 2>&1
del /s /f /q C:\Windows\Prefetch\*.* >nul 2>&1
net stop wuauserv >nul 2>&1
del /s /f /q C:\Windows\SoftwareDistribution\Download\*.* >nul 2>&1
net start wuauserv >nul 2>&1
echo Cleanup Complete.

:: 4. APPLY POWER OVERRIDES
echo.
echo --- 4. APPLYING POWER OVERRIDES ---
powercfg /x -sleep-timeout-ac 0 >nul 2>&1
powercfg /x -display-timeout-ac 0 >nul 2>&1
powercfg /setacvalueindex SCHEME_CURRENT SUB_PROCESSOR PROCTHROTTLEMAX 100 >nul 2>&1
powercfg /setactive SCHEME_CURRENT >nul 2>&1
echo CPU state set to 100%%. Sleep disabled.

:: 5. TRIGGER WINDOWS UPDATE (GPO BYPASS METHOD)
echo.
echo --- 5. WINDOWS UPDATE (USOCLIENT BYPASS) ---
echo Triggering Scan and Install...
usoclient StartScan
usoclient StartDownload
usoclient StartInstall
echo [!] Commands sent to Windows Update Orchestrator.
echo [!] Check 'Settings > Windows Update' to see progress.

:: 6. START THE HEARTBEAT
echo.
echo --- 6. ACTIVATING 'STAY-AWAKE' HEARTBEAT ---
echo Set objShell = CreateObject("WScript.Shell") > %temp%\stayawake.vbs
echo Do >> %temp%\stayawake.vbs
echo     WScript.Sleep 60000 >> %temp%\stayawake.vbs
echo     objShell.SendKeys "{SCROLLLOCK}" >> %temp%\stayawake.vbs
echo     objShell.SendKeys "{SCROLLLOCK}" >> %temp%\stayawake.vbs
echo Loop >> %temp%\stayawake.vbs

start /min wscript.exe %temp%\stayawake.vbs
echo [ACTIVE] Simulated heartbeat running.
echo ======================================================
echo Tasks finished. If a reboot was pending, please restart.
pause

:: Cleanup on exit
taskkill /f /im wscript.exe >nul 2>&1
del %temp%\stayawake.vbs >nul 2>&1
echo Done.