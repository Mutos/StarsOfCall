#!/bin/sh

# Change to the integration folder
cd SoC-Integration-Linux

# Create links to naev repository's files and folders
rm ./appveyor.yml
ln -s ../../Repositories/naev/appveyor.yml       ./appveyor.yml
rm ./AUTHORS
ln -s ../../Repositories/naev/AUTHORS            ./AUTHORS
rm ./autogen.sh
ln -s ../../Repositories/naev/autogen.sh         ./autogen.sh
rm ./bin
ln -s ../../Repositories/naev/bin                ./bin
rm ./build
ln -s ../../Repositories/naev/build              ./build
rm ./CHANGELOG
ln -s ../../Repositories/naev/CHANGELOG          ./CHANGELOG
rm ./configure.ac
ln -s ../../Repositories/naev/configure.ac       ./configure.ac
rm ./datapath.lua
ln -s ../../Repositories/naev/datapath.lua       ./datapath.lua
rm ./docs
ln -s ../../Repositories/naev/docs               ./docs
rm ./extras
ln -s ../../Repositories/naev/extras             ./extras
rm ./lib
ln -s ../../Repositories/naev/lib                ./lib
rm ./LICENSE
ln -s ../../Repositories/naev/LICENSE            ./LICENSE
rm ./m4
ln -s ../../Repositories/naev/m4                 ./m4
rm ./Makefile.am
ln -s ../../Repositories/naev/Makefile.am        ./Makefile.am
rm ./naev.6
ln -s ../../Repositories/naev/naev.6             ./naev.6
rm ./naev.appdata.xml
ln -s ../../Repositories/naev/naev.appdata.xml   ./naev.appdata.xml
rm ./naev-confupdate.sh
ln -s ../../Repositories/naev/naev-confupdate.sh ./naev-confupdate.sh
rm ./naev.desktop
ln -s ../../Repositories/naev/naev.desktop       ./naev.desktop
rm ./po
ln -s ../../Repositories/naev/po                 ./po
rm ./README
ln -s ../../Repositories/naev/README             ./README
rm ./Readme.md
ln -s ../../Repositories/naev/Readme.md          ./Readme.md
rm ./src
ln -s ../../Repositories/naev/src                ./src
rm ./TODO
ln -s ../../Repositories/naev/TODO               ./TODO
rm ./.travis
ln -s ../../Repositories/naev/.travis            ./.travis
rm ./.travis.yml
ln -s ../../Repositories/naev/.travis.yml        ./.travis.yml
rm ./utils
ln -s ../../Repositories/naev/utils              ./utils
rm ./SoC-NAEV-lin64.sh
ln -s ../../Repositories/naev/SoC-NAEV-lin64.sh  ./SoC-NAEV-lin64.sh

# Links SoC-data to local SoC-data repository
rm ./SoC-data
ln -s ../SoC-data/                               ./SoC-data

# Links dat to SoC-dat repository
rm ./dat
ln -s ../../Repositories/SoC-dat/                ./dat
