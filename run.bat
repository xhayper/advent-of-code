@ECHO OFF
TITLE Advent Of Code
IF "%~1"=="" GOTO usage
IF "%~2"=="" GOTO usage
IF "%~3"=="" GOTO usage
GOTO main
:usage
ECHO Start the solution for spefic language, year and day.
ECHO:
ECHO ./run.bat [Year] [Day] [Language]
PAUSE
EXIT /B
:main
IF NOT EXIST "%cd%\%~1\" ECHO You have entered an invalid year. && PAUSE && EXIT /B
IF NOT EXIST "%cd%\%~1\Day %~2" ECHO You have entered an invalid day. && PAUSE && EXIT /B
SET valid=false
IF "%~3"=="Javascript" (
    SET exec=node 
    SET ext=.js
    SET valid=true
)
IF "%~3"=="lua" (
    SET exec=lua 
    SET ext=.lua
    SET valid=true
)
IF "%valid%"=="false" ECHO You have entered an invalid language. && PAUSE && EXIT /B
CD "%~1\Day %~2\%~3\"
%exec%"index%ext%"
PAUSE
CD ../../../
EXIT /B
