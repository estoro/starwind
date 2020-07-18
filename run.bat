@echo off

if "%~1"=="-FIXED_CTRL_C" (
   SHIFT
) ELSE (
   CALL <NUL %0 -FIXED_CTRL_C %*
   GOTO :EOF
)

:start
start /w tes3mp-server.exe
goto start
