#!/bin/bash

. /cvmfs/ilc.desy.de/sw/x86_64_gcc49_sl6/v02-00-02/init_ilcsoft.sh

echo ${lcgeo_DIR}
compact_file=${lcgeo_DIR}/ILD/compact/ILD_l5_v02/ILD_l5_v02.xml
steering_file=/cvmfs/ilc.desy.de/sw/ILDConfig/v02-00-02/StandardConfig/production/ddsim_steer.py

echo ${compact_file}
echo ${steering_file}

ddsim  --compactFile ${compact_file} \
       --steeringFile ${steering_file} \
       --macroFile dawn3.mac \
       --runType vis

