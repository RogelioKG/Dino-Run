@echo off

setlocal enableextensions
setlocal disabledelayedexpansion

set "consoleName=Dino Run"

(   reg add "HKCU\Console\%consoleName%" /f
    reg add "HKCU\Console\%consoleName%" /f /v "FaceName"         /t "REG_SZ"     /d "Consolas"
    reg add "HKCU\Console\%consoleName%" /f /v "FontFamily"       /t "REG_DWORD"  /d 0x00000036
    reg add "HKCU\Console\%consoleName%" /f /v "FontSize"         /t "REG_DWORD"  /d 0x00020001
    reg add "HKCU\Console\%consoleName%" /f /v "FontWeight"       /t "REG_DWORD"  /d 0x00000000
    reg add "HKCU\Console\%consoleName%" /f /v "QuickEdit"        /t "REG_DWORD"  /d 0x00000000
    reg add "HKCU\Console\%consoleName%" /f /v "ScreenBufferSize" /t "REG_DWORD"  /d 0x00800240
    reg add "HKCU\Console\%consoleName%" /f /v "WindowSize"       /t "REG_DWORD"  /d 0x00800240
) > nul

start "%consoleName%" %~dp0\dino-run.exe
endlocal