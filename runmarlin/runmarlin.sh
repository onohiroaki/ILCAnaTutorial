#!/bin/bash

# 
# 
recdetector=ILD_l5_o1_v02
simdetector=`echo ${recdetector} | cut -d"_" -f1,2,4`

## 1. Initialize the current ilcsoft release

unset MARLIN_DLL
softdir=/cvmfs/ilc.desy.de/sw
. ${softdir}/x86_64_gcc82_centos7/v02-02-01/init_ilcsoft.sh

ildconfig=/cvmfs/ilc.desy.de/sw/ILDConfig/v02-02-01/StandardConfig/production

## 2. Setup links to files
echo "ILCSOFT is ${ILCSOFT}"
which Marlin

ln -sf ${ildconfig}/PandoraSettings .
ln -sf ${ildconfig}/HighLevelReco .

## 4. Run marlin
echo ${lcgeo_DIR}

Marlin ${ildconfig}/MarlinStdReco.xml \
  --global.LCIOInputFiles=../runddsim/bbudsc_3evt.m${simdetector}.slcio \
  --constant.OutputBaseName=bbudsc_3evt.m${recdetector} \
  --constant.DetectorModel=${recdetector} \
  --constant.lcgeo_DIR=${lcgeo_DIR} 
