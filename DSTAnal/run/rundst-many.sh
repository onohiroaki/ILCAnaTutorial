#!/bin/bash

export MARLIN_DLL=   # Clear MARLIN_DLL before source init_ilcsoft.sh 

. /cvmfs/ilc.desy.de/sw/x86_64_gcc49_sl6/v02-00-01/init_ilcsoft.sh   # Latest ILCSoft

export MARLIN_DLL=../lib/libmydstanal.so:${MARLIN_DLL}

gearfile=/cvmfs/ilc.desy.de/sw/ILDConfig/v02-00-01/StandardConfig/production/Gear/gear_ILD_l5_v02.xml

maxrecords=0   # Analize all events
dstdir=/hsm/ilc/grid/storm/prod/ilc/mc-opt-3/ild/dst-merged/500-TDR_ws/higgs_ffh/ILD_l5_o1_v02/v02-00-01

infile=`find ${dstdir} -name "*.I106524.*.slcio" -print | xargs -I{} echo -n "{} "` 

echo "Following files will be analized."
echo ${infile}


Marlin --global.LCIOInputFiles="${infile}" \
       --global.GearXMLFile=${gearfile} \
       --global.MaxRecordNumber=${maxrecords} \
       mydstanal.xml
