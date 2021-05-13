#!/bin/bash

. /cvmfs/ilc.desy.de/sw/x86_64_gcc82_centos7/v02-02-01/init_ilcsoft.sh

echo ${lcgeo_DIR}

ddsim  --compactFile myILD.xml \
       --gun.energy 10.0 \
       --enableGun \
       --numberOfEvents 5


