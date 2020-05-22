@ECHO OFF

REM Remember current dir
SET CurrentDir=%~dp0

REM Regenerate dat link in Repositories folder
CD Repositories
RMDIR dat
MKLINK /J dat SoC-dat

REM Copy starmap files in starmap folder
CD utils\starmap
COPY /Y  ..\..\naev\utils\starmap\dataloader.py .\dataloader.py
COPY /Y  ..\..\naev\utils\starmap\naevdata.py .\naevdata.py
COPY /Y  ..\..\naev\utils\starmap\starmap.py .\starmap.py

REM Actually launch python starmap
..\..\..\..\..\minGW\msys2_x64\mingw32\bin\python3 starmap.py 1>starmap.svg 2>starmap.log

REM restore current folder
CD %CurrentDir%
