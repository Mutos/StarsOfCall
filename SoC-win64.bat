@ECHO OFF 
REM Change to the integration folder
SET CurrentDir=%~dp0

REM Change to Integration folder
CD Integration

REM Clean Integration folder
FOR /D %%F in (*) do (
	IF NOT "%%~nF"=="" (
		RMDIR %%~nF
	)
)
FOR %%F in (*.*) do (
	DEL %%F
)

REM Create links to naev repository's folders
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

REM Issue #1087 Workaround 1/2
REM COPY /Y ..\appdata-SoC\conf-REF.lua ..\appdata-SoC\conf.lua

REM Actually launch NAEV in SoC-lin64 configuration
.\bin\win64\naev.exe

REM Issue #1087 Workaround 2/2
REM COPY /Y ..\appdata-SoC\conf-REF.lua ..\appdata-SoC\conf.lua

REM Clean Integration folder
FOR /D %%F in (*) do (
	IF NOT "%%~nF"=="" (
		RMDIR .\%%~nF
	)
)
FOR %%F in (*.*) do (
	DEL %%F
)

REM restore current folder
CD %CurrentDir%
