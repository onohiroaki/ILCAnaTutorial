#!/bin/bash

export MARLIN_DLL=   # Clear MARLIN_DLL before source init_ilcsoft.sh 

# . /cvmfs/ilc.desy.de/sw/x86_64_gcc82_sl6/v02-02/init_ilcsoft.sh   # Latest ILCSoft
. /cvmfs/ilc.desy.de/sw/x86_64_gcc82_sl6/v02-01-02/init_ilcsoft.sh   # Latest ILCSoft
# . /sw/ilc/ilcsoft/gcc820/v02-01-02/init_ilcsoft.sh   # Latest ILCSoft

export MARLIN_DLL=../lib/libmydstanal.so:${MARLIN_DLL}

gearfile=/cvmfs/ilc.desy.de/sw/ILDConfig/v02-01-02/StandardConfig/production/Gear/gear_ILD_l5_v02.xml

maxrecords=2000
dstdir=/hsm/ilc/grid/storm/prod/ilc/mc-opt-3/ild/dst-merged/500-TDR_ws/higgs_ffh/ILD_l5_o1_v02/v02-00-01
dstdir=~/
dstfile=rv02-00-01.sv02-00-01.mILD_l5_o1_v02.E500-TDR_ws.I106524.Pnnh.eR.pL.n001.d_dstm_10297_0.slcio

infile=${dstdir}/${dstfile}
#checktape=`ghils ${infile} | cut -d" " -f1`
#if [ "x${checktape}" != "xB" ] ; then 
#  echo "Stage-in input file "
#  echo ${infile}
#fi
echo "infile is ${infile}" 



Marlin --global.LCIOInputFiles="${infile}" \
       --global.GearXMLFile=${gearfile} \
       --global.MaxRecordNumber=${maxrecords} \
       mydstanal.xml
