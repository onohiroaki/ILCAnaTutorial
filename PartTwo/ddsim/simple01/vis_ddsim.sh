#!/bin/bash

. /cvmfs/ilc.desy.de/sw/x86_64_gcc82_centos7/v02-02-01/init_ilcsoft.sh

if [ ! -e lcgeo ] ; then 
  ln -s ${lcgeo_DIR} lcgeo
fi

ddsim  --compactFile simple01.xml \
       --gun.energy "10.0*GeV" \
       --enableGun \
       --gun.particle mu- \
       --gun.thetaMin 1.0 \
       --gun.thetaMax 2.0 \
       --gun.distribution uniform \
       --macroFile init_vis.mac \
       --runType vis

#       --numberOfEvents 5
#       --gun.distribution ffbar \


