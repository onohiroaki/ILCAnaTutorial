#!/bin/bash

# Example is available in /sw/ilc/ilcsoft/cvmfs/examples-gcc49/v02-00-01/

## 1. Initialize the current ilcsoft release

softdir=/cvmfs/ilc.desy.de/sw

. ${softdir}/x86_64_gcc49_sl6/v02-00-02/init_ilcsoft.sh 
ildconfig=${softdir}/ILDConfig/v02-00-01/StandardConfig/production


## 2. run the lcgeo/ddsim simulation example

echo "ILCSOFT is ${ILCSOFT}"
which ddsim
detector="ILD_l5_v02"


ddsim --inputFiles ../LC2c/E250GeV.Pee_mumu.slcio \
      --outputFile sim.E250GeV.Pee_mumu.m${detector}.slcio \
      --compactFile ${lcgeo_DIR}/ILD/compact/${detector}/${detector}.xml \
      --steeringFile ${ildconfig}/ddsim_steer.py \
      --numberOfEvents 100

