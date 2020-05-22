#!/bin/sh

# Clear starmap files in Repositories folder
rm -f -r Repositories/dat
ln -s SoC-dat Repositories/dat

rm -f -r Repositories/utils/starmap/dataloader.py
ln -s ../../naev/utils/starmap/dataloader.py Repositories/utils/starmap/dataloader.py

rm -f -r Repositories/utils/starmap/naevdata.py
ln -s ../../naev/utils/starmap/naevdata.py Repositories/utils/starmap/naevdata.py

rm -f -r Repositories/utils/starmap/starmap.py
ln -s ../../naev/utils/starmap/starmap.py Repositories/utils/starmap/starmap.py

# Actually launch python starmap
cd Repositories/utils/starmap/
python starmap.py 1>starmap.svg 2>starmap.log
cd ../../..
