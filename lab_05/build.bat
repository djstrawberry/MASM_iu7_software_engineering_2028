@echo off

rem DOSBox/COMMAND.COM friendly build script
set MASM_DIR=..\..\masm
set ML_EXE=%MASM_DIR%\ML.EXE
set LINK_EXE=%MASM_DIR%\LINK.EXE
set OUT_EXE=LAB05.EXE
set OBJLIST=MAIN.OBJ+INPUT.OBJ+OUTPUT.OBJ+PRNBIN.OBJ+PRNHEX8.OBJ+MINP2.OBJ+EXITPRG.OBJ+STACK.OBJ

if not exist %ML_EXE% goto NO_ML
if not exist %LINK_EXE% goto NO_LINK

rem Optional output name: build.bat MYAPP.EXE
if not "%1"=="" set OUT_EXE=%1

if not exist *.ASM goto NO_ASM

rem Avoid linking stale object files from old builds
if exist *.OBJ del *.OBJ >NUL

echo Assembling all ASM files in current directory...
%ML_EXE% /c *.ASM
if errorlevel 1 goto FAIL

if not exist *.OBJ goto NO_OBJ

echo Linking %OUT_EXE%...
%LINK_EXE% %OBJLIST%,%OUT_EXE%,NUL,,;
if errorlevel 1 goto FAIL

echo Build succeeded: %OUT_EXE%
goto END

:NO_ML
echo ERROR: ML.EXE not found at %ML_EXE%
goto END

:NO_LINK
echo ERROR: LINK.EXE not found at %LINK_EXE%
goto END

:NO_ASM
echo ERROR: No ASM files found in current directory.
goto END

:NO_OBJ
echo ERROR: No OBJ files produced. Build aborted.
goto END

:FAIL
echo Build failed.

:END
