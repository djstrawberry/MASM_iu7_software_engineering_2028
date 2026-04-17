@echo off
echo Building resident.com with ML /AT...
ml /AT resident.asm
if errorlevel 1 goto error

echo ==========================================
echo SUCCESS! resident.com created.
dir resident.com
echo ==========================================
goto end

:error
echo Build failed.

:end