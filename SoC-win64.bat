@ECHO OFF 
REM Store current folder
SET CurrentDir=%~dp0

REM Change to Integration folder
CD .\Integration

REM Clean Integration folder
FOR /D %%F in (*) do (
	IF NOT "%%~nF"=="" (
		IF DEFINED WINEUSERNAME (
			RMDIR /S /Q %%~nF
		) ELSE (
			RMDIR %%~nF
		)
	)
)
FOR %%F in (*.*) do (
	DEL %%F
)

REM Create links to naev repository's folders
FOR %%F IN (bin) DO (
	IF DEFINED WINEUSERNAME (
		XCOPY /S /Y /I ..\Repositories\naev\%%~nF .\%%~nF
	) ELSE (
		MKLINK /J .\%%~nF ..\Repositories\naev\%%~nF
	)
)


REM Copy naev repository's files
FOR %%F in (..\Repositories\naev\*) do (
	COPY /Y  %%F .
)

REM Use datapath.lua to use local NAEV-data folder
if EXIST datapath.lua DEL datapath.lua
echo datapath="../appdata-SoC" > datapath.lua

REM Links dat to the SoC-dat repository itelf
IF DEFINED WINEUSERNAME (
	RMDIR /S /Q .\dat
	XCOPY /S /Y /I ..\Repositories\SoC-dat .\dat
) ELSE (
	RMDIR .\dat
	MKLINK /J .\dat ..\Repositories\SoC-dat
)

REM Issue #1087 Workaround 1/2
REM COPY /Y ..\appdata-SoC\conf-REF.lua ..\appdata-SoC\conf.lua

REM Actually launch NAEV in SoC-win64 configuration
.\bin\win64\naev.exe

REM Issue #1087 Workaround 2/2
REM COPY /Y ..\appdata-SoC\conf-REF.lua ..\appdata-SoC\conf.lua

ECHO Win64 Executable finished

pause

REM Clean Integration folder
FOR /D %%F in (*) do (
	IF NOT "%%~nF"=="" (
		IF DEFINED WINEUSERNAME (
			RMDIR /S /Q %%~nF
		) ELSE (
			RMDIR %%~nF
		)
	)
)
FOR %%F in (*.*) do (
	DEL /F /Q %%F
)

REM restore current folder
CD %CurrentDir%
