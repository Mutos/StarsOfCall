@ECHO OFF 
REM Change to the integration folder
SET CurrentDir=%~dp0
CD Integration

REM Create links to naev repository's folders
FOR /D %%F in (*) do (
	IF NOT "%%~nF"=="" (
		RMDIR .\%%~nF
	)
)
FOR /D %%F in (..\Repositories\naev\?*) do (
	IF NOT "%%~nF"=="" (
		MKLINK /J  .\%%~nF ..\Repositories\naev\%%~nF
	)
)

REM Copy naev repository's files
FOR %%F in (..\Repositories\naev\*) do (
	COPY /Y  %%F .
)

REM Use datapath.lua to use local NAEV-data folder
DEL datapath.lua
echo datapath="../appdata-SoC" > datapath.lua

REM Links dat to the SoC-dat repository itelf
RMDIR dat
MKLINK /J .\dat ..\Repositories\SoC-dat

REM Actually launch NAEV in SoC-lin64 configuration
.\bin\win32\naev.exe

REM restore current folder
CD %CurrentDir%
