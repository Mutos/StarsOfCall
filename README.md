# StarsOfCall (aka SoC)
Stars of Call is a game of space adventure in the Hoshikaze 2250 universe. It is made as a TC of the game NAEV, which we encourage you to check !

==== Setting Up a SoC dev environment fromt this repo ====

1/ Clone this repo

Create a suitable folder and cd to it
Clone the repo :
	git clone https://github.com/Mutos/StarsOfCall.git .

2/ Complete the repo with files from the NAEV release 0.10.4

	a/ Get the 0.10.4 Windows release :
		https://github.com/naev/naev/releases/download/v0.10.4/naev-0.10.4-win64.exe
		Uncompress it in any folder

	b/ Get data folder
		Move the "dat" folder to
			SoC-dev-dat/refs/NAEV-vanilla-dat-0.10.4

	c/ Get Windows executable
		Move the remaining files to a folder named
			build/naev-0.10.4-win64

	d/ Build Linux executable for your Linux version yy.mm (ex 20.04)
		Get the pre-requisites for compiling :
			https://github.com/naev/naev/wiki/Compiling-on-*nix
			You may get a warning for libzip2 : ignore that package
		Get the source compressed folder
			Download
				https://github.com/naev/naev/archive/refs/tags/v0.10.4.zip
			or download
				https://github.com/naev/naev/archive/refs/tags/v0.10.4.tar.gz
			or get Github NAEV/NAEV 0.10.4 commit from
				https://github.com/naev/naev/tree/6e8bc84df4a16cd5c163a3b3713ecc65c8503819
		Uncompress it in a suitable folder and cd to it
		Setup the compiling environment and compile NAEV :
			meson setup <path to the StarsOfCall repo>/build/naev-0.10.4-lin64-<yy.mm> .
			cd <path to the StarsOfCall repo>/build/naev-0.10.4-lin64-<yy.mm>
			meson compile

3/ Run NAEV and SoC from the repo root
	Windows
		NAEV.bat
		SoC.bat
	Linux
		NAEV.sh
		SoC.sh
	NAEV run-time data folders
		Under the "naev-data" folder
		Contains separate subfolders NAEV and SoC
		Under each subfolder
			conf.lua			NAEV configuration
			collisions/		Temp files created by NAEV at runtime
			logs/				All NAEV runtime logs
			plugins/			Where to store plugins you might write, currently not used
			saves/			Saved games, a "Mutos" saved game is provided

4/ StarsOfCall development

(to be written)
