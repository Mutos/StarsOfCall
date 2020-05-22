#!/bin/sh

# set paths
OutputPath=../../../appdata-SoC/starmap
StarmapPath=../../naev/utils/starmap
StarmapOriginalPath=Repositories/utils/starmap

# Clear starmap files in Repositories folder
rm -f -r Repositories/dat
ln -s SoC-dat Repositories/dat

rm -f -r $StarmapOriginalPath/dataloader.py
ln -s $StarmapPath/dataloader.py $StarmapOriginalPath/dataloader.py

rm -f -r $StarmapOriginalPath/naevdata.py
ln -s $StarmapPath/naevdata.py $StarmapOriginalPath/naevdata.py

rm -f -r $StarmapOriginalPath/starmap.py
ln -s $StarmapPath/starmap.py $StarmapOriginalPath/starmap.py

# Actually launch python starmap
cd $StarmapOriginalPath/
python starmap.py 1>$OutputPath/starmap.svg 2>$OutputPath/starmap.log
cd ../../..
