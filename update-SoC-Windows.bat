@ECHO OFF 
REM Change to the integration folder
SET CurrentDir=%~dp0
CD SoC-Integration-Windows

REM Create links to naev repository's folders
RMDIR .\bin
MKLINK /J  .\bin                ..\..\Repositories\naev\bin
RMDIR .\build
MKLINK /J  .\build              ..\..\Repositories\naev\build
RMDIR .\docs
MKLINK /J  .\docs               ..\..\Repositories\naev\docs
RMDIR .\extras
MKLINK /J  .\extras             ..\..\Repositories\naev\extras
RMDIR .\lib
MKLINK /J  .\lib                ..\..\Repositories\naev\lib
RMDIR .\m4
MKLINK /J  .\m4                 ..\..\Repositories\naev\m4
RMDIR .\po
MKLINK /J  .\po                 ..\..\Repositories\naev\po
RMDIR .\src
MKLINK /J  .\src                ..\..\Repositories\naev\src
RMDIR .\.travis
MKLINK /J  .\.travis            ..\..\Repositories\naev\.travis
RMDIR .\utils
MKLINK /J  .\utils              ..\..\Repositories\naev\utils

REM COPY naev repository's files
COPY /Y  ..\..\Repositories\naev\appveyor.yml       .\appveyor.yml
COPY /Y  ..\..\Repositories\naev\AUTHORS            .\AUTHORS
COPY /Y  ..\..\Repositories\naev\autogen.sh         .\autogen.sh
COPY /Y  ..\..\Repositories\naev\CHANGELOG          .\CHANGELOG
COPY /Y  ..\..\Repositories\naev\configure.ac       .\configure.ac
COPY /Y  ..\..\Repositories\naev\datapath.lua       .\datapath.lua
COPY /Y  ..\..\Repositories\naev\LICENSE            .\LICENSE
COPY /Y  ..\..\Repositories\naev\Makefile.am        .\Makefile.am
COPY /Y  ..\..\Repositories\naev\naev.6             .\naev.6
COPY /Y  ..\..\Repositories\naev\naev.appdata.xml   .\naev.appdata.xml
COPY /Y  ..\..\Repositories\naev\naev-confupdate.sh .\naev-confupdate.sh
COPY /Y  ..\..\Repositories\naev\naev.desktop       .\naev.desktop
COPY /Y  ..\..\Repositories\naev\README             .\README
COPY /Y  ..\..\Repositories\naev\Readme.md          .\Readme.md
COPY /Y  ..\..\Repositories\naev\TODO               .\TODO
COPY /Y  ..\..\Repositories\naev\.travis.yml        .\.travis.yml
COPY /Y  ..\..\Repositories\naev\SoC-NAEV-win32.bat .\SoC-NAEV-win32.bat
COPY /Y  ..\..\Repositories\naev\SoC-NAEV-win64.bat .\SoC-NAEV-win64.bat

REM Links SoC-data to local SoC-data repository
RMDIR .\SoC-data
MKLINK /J .\SoC-data                                ..\SoC-data

REM Links dat to SoC-dat repository
RMDIR .\dat
MKLINK /J .\dat                                     ..\..\Repositories\SoC-dat

REM restore current folder
CD %CurrentDir%
