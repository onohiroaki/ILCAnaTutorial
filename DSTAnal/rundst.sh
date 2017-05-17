#!/bin/bash

export MARLIN_DLL=   # Clear MARLIN_DLL before source init_ilcsoft.sh 

. /cvmfs/ilc.desy.de/sw/x86_64_gcc44_sl6/v01-16-02/init_ilcsoft.sh   # DBD version
# . /cvmfs/ilc.desy.de/sw/x86_64_gcc44_sl6/v01-17-11/init_ilcsoft.sh   # Latest compatible with Mokka

export MARLIN_DLL=../lib/libmydstanal.so

gearfile=/cvmfs/ilc.desy.de/sw/ILDConfig/v01-16-p10_250/StandardConfig/current/GearOutput.xml

maxrecords=10000
dstdir=/hsm/ilc/grid/storm/prod/ilc/mc-dbd/ild/dst-merged/250-TDR_ws/higgs_ffh/ILD_o1_v05/v01-16-p10_250
dstpref=rv01-16-p10_250.sv01-14-01-p00.mILD_o1_v05.E250-TDR_ws.I106483.Pnnh.eL.pR
infile=${dstdir}/${dstpref}-00001-DST.slcio
for i in `seq 2 4` ; do 
  infile="$infile ${dstdir}/${dstpref}-0000${i}-DST.slcio"
done

# Marlin $mysteer > marlin.log 2>&1 
Marlin --global.LCIOInputFiles="${infile}" \
       --global.GearXMLFile=${gearfile} \
       --global.MaxRecordNumber=${maxrecords} \
       mydstanal.xml
