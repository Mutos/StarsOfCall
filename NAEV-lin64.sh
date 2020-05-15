#!/bin/sh

# ClearIntegration folder
rm -f Integration/*

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

# Actually launch NAEV in SoC-lin64 configuration
cd Integration
./bin/lin64/naev
cd ..
