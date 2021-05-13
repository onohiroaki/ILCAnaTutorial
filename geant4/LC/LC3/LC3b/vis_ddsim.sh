#!/bin/bash

. /cvmfs/ilc.desy.de/sw/x86_64_gcc82_centos7/v02-02-01/init_ilcsoft.sh

# . ../init_ilcsoft.sh

# input_file=../../LC2/LC2c/E250GeV.Pee_mumu.slcio

# ddsim --compactFile myILD.xml \
#       --inputFiles ${input_file} \
#       --runType vis


ddsim  --compactFile myILD.xml \
       --gun.energy "10.0*GeV" \
       --enableGun \
       --gun.particle mu- \
       --gun.thetaMin 0.5 \
       --gun.thetaMax 1.0 \
       --gun.distribution uniform \
       --macroFile init_vis.mac \
       --runType vis

#       --numberOfEvents 5
#       --gun.distribution ffbar \


