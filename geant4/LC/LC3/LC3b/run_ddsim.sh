#!/bin/bash

. /cvmfs/ilc.desy.de/sw/x86_64_gcc49_sl6/v02-00-02/init_ilcsoft.sh

echo ${lcgeo_DIR}

ddsim  --compactFile myILD.xml \
       --gun.energy 10.0 \
       --enableGun \
       --numberOfEvents 5


