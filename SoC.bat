@echo off
SET DIR_SCRIPT=%~dp0

SET binDir="%DIR_SCRIPT%\build\naev-0.10.4-win64"
SET NAEVdatDir="%DIR_SCRIPT%\SoC-dev-dat\work\NAEV-dat-core"
SET SoCdatDir="%DIR_SCRIPT%\SoC-dev-dat\work\SoC-dat-dev"

if NOT EXIST %binDir% (
  ECHO "ERROR : %binDir% does not exist."
  ECHO "Please compile NAEV for your system by running the following commands :"
  ECHO "  cd <Your NAEV repo copy>"
  ECHO "  meson setup %binDir% ."
  ECHO "  cd %binDir%"
  ECHO "  meson compile"
  EXIT
)

if NOT EXIST %NAEVdatDir% (
  ECHO "ERROR : %NAEVdatDir% does not exist."
  ECHO "Please check the NAEV vanilla data folder exists."
  EXIT
)

if NOT EXIST %SoCdatDir% (
  ECHO "ERROR : %SoCdatDir% does not exist."
  ECHO "Please check the NAEV vanilla data folder exists."
  EXIT
)

REM Run NAEV within a dedicated folder
REM Writing from editors is done on hard-coded "../dat" from this path
CD run\SoC
%binDir%\naev.exe -devmode -d "%SoCdatDir%" -d "%NAEVdatDir%"
