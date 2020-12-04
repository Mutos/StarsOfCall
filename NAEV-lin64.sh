#!/bin/sh

# Clear Integration folder
rm -f -r Integration/*

# Create links to all files and folders in naev repository
cd Repositories/naev
for filename in *
do
	ln -s ../Repositories/naev/$filename ../../Integration/$filename
done
cd ../..

# Use datapath.lua to use local NAEV-data folder
rm Integration/datapath.lua
echo "datapath=\"../appdata-NAEV\"" > Integration/datapath.lua

# Links dat to the original dat in naev repository
rm Integration/dat
ln -s ../Repositories/naev/dat Integration/dat

# Issue #1087 Workaround 1/2
# cp -f ./appdata-NAEV/conf-REF.lua ./appdata-NAEV/conf.lua

# Actually launch NAEV in SoC-lin64 configuration
#   As of 2020-11-11, --devmode is mandatory to avoid return of issue #1087
cd Integration
DRI_PRIME=1 ./bin/lin64/naev --devmode --datapath ../appdata-NAEV
cd ..

# Clear Integration folder
rm -f -r Integration/*
