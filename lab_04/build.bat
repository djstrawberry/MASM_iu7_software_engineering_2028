@echo off

rem DOSBox/COMMAND.COM friendly build script
set MASM_DIR=..\..\masm
set ML_EXE=%MASM_DIR%\ML.EXE
set LINK_EXE=%MASM_DIR%\LINK.EXE

if not exist %ML_EXE% goto NO_ML
if not exist %LINK_EXE% goto NO_LINK

echo [1/3] Assembling MAIN.ASM...
%ML_EXE% /c MAIN.ASM
if errorlevel 1 goto FAIL

echo [2/3] Assembling IO.ASM...
%ML_EXE% /c IO.ASM
if errorlevel 1 goto FAIL

echo [3/5] Assembling MATRIX.ASM...
%ML_EXE% /c MATRIX.ASM
if errorlevel 1 goto FAIL

echo [4/5] Assembling UTILS.ASM...
%ML_EXE% /c UTILS.ASM
if errorlevel 1 goto FAIL

echo [5/5] Linking LAB04.EXE...
%LINK_EXE% MAIN.OBJ+IO.OBJ+MATRIX.OBJ+UTILS.OBJ,LAB04.EXE,NUL,,;
if errorlevel 1 goto FAIL

echo Build succeeded: LAB04.EXE
goto END

:NO_ML
echo ERROR: ML.EXE not found at %ML_EXE%
goto END

:NO_LINK
echo ERROR: LINK.EXE not found at %LINK_EXE%
goto END

:FAIL
echo Build failed.

:END
