#!/bin/sh

# Actually launch NAEV in SoC-lin64 configuration
#   As of 2020-11-11, --devmode is mandatory to avoid return of issue #1087
DRI_PRIME=1 ./Repositories/naev/bin/lin64/naev.sh --devmode --datapath ../../appdata-NAEV
