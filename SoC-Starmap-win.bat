@ECHO OFF

REM Remember current dir
SET CurrentDir=%~dp0

REM set paths
SET OutputPath=..\..\..\appdata-SoC\starmap
SET StarmapPath=..\..\naev\utils\starmap
SET PythonEXE=..\..\..\..\..\minGW\msys2_x64\mingw32\bin\python3

REM Regenerate dat link in Repositories folder
CD Repositories
RMDIR dat
MKLINK /J dat SoC-dat

REM Copy starmap files in starmap folder
CD utils\starmap
COPY /Y  %StarmapPath%\dataloader.py .\dataloader.py
COPY /Y  %StarmapPath%\naevdata.py .\naevdata.py
COPY /Y  %StarmapPath%\starmap.py .\starmap.py

REM Actually launch python starmap
%PythonEXE% starmap.py 1>%OutputPath%\starmap.svg 2>%OutputPath%starmap.log

REM restore current folder
CD %CurrentDir%
