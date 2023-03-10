#!/bin/sh

# ClearIntegration folder
rm -f -r Integration/*

# Create links to all files and folders in naev repository
cd Repositories/naev
for filename in *
do
	ln -s ../Repositories/naev/$filename ../../Integration/$filename
done
cd ../..

# Use datapath.lua to use local SoC-data folder
rm Integration/datapath.lua
echo "datapath=\"../appdata-SoC\"" > Integration/datapath.lua

# Links dat to the SoC-dat repository
rm Integration/dat
ln -s ../Repositories/SoC-dat Integration/dat

# Issue #1087 Workaround 1/2
# cp -f ./appdata-SoC/conf-REF.lua ./appdata-SoC/conf.lua

# Actually launch NAEV in SoC-lin64 configuration
#   As of 2020-11-11, --devmode is mandatory to avoid return of issue #1087
cd Integration
DRI_PRIME=1 ./bin/lin64/naev --devmode
cd ..

# Clear Integration folder
#rm -f -r Integration/*

# Issue #1087 Workaround 2/2
# cp -f ./appdata-SoC/conf-REF.lua ./appdata-SoC/conf.lua

