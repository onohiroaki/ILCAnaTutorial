#!/bin/bash

export MARLIN_DLL=   # Clear MARLIN_DLL before source init_ilcsoft.sh 

. /cvmfs/ilc.desy.de/sw/x86_64_gcc82_centos7/v02-02-01/init_ilcsoft.sh   # Latest ILCSoft

export MARLIN_DLL=../lib/libmcmarlin.so:${MARLIN_DLL}

gearfile=/cvmfs/ilc.desy.de/sw/ILDConfig/v02-02-01/StandardConfig/production/Gear/gear_ILD_l5_v02.xml

maxrecords=-1
datadir=~/Tutorial/data
datafile=E250-TDR_ws.Pe2e2h.Gwhizard-1_95.eL.pR.I106479.001.slcio

infile=${datadir}/${datafile}
echo "infile is ${infile}" 

Marlin --global.LCIOInputFiles="${infile}" \
       --global.MaxRecordNumber=${maxrecords} \
       --global.GearXMLFile=${gearfile} \
       mcmarlin.xml

