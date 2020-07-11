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
echo datapath="../appdata-NAEV" > datapath.lua

REM Links dat to the original dat in naev repository
RMDIR dat
MKLINK /J .\dat ..\Repositories\naev\dat

REM Issue #1087 Workaround 1/2
REM COPY /Y ..\appdata-NAEV\conf-REF.lua ..\appdata-NAEV\conf.lua

REM Actually launch NAEV in SoC-lin64 configuration
.\bin\win32\naev.exe

REM Issue #1087 Workaround 2/2
REM COPY /Y ..\appdata-NAEV\conf-REF.lua ..\appdata-NAEV\conf.lua

REM restore current folder
CD %CurrentDir%
