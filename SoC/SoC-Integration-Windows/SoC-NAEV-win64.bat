set CurrentDir=%~dp0
set NAEVexe="%CurrentDir%\bin\win64\naev.exe"
set SoCdata="%CurrentDir%\SoC-data"
%NAEVexe% 1> %SoCdata%\logs\stdout.txt 2> %SoCdata%\logs\stderr.txt