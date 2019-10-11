#!/bin/bash

## 
recdetector=$1
if [ "x$recdetector" == "x" ] ; then 
  recdetector=ILD_l5_o1_v02
fi

simdetector=`echo ${recdetector} | cut -d"_" -f1,2,4`

## 1. Initialize the current ilcsoft release

unset MARLIN_DLL
softdir=/cvmfs/ilc.desy.de/sw
. ${softdir}/x86_64_gcc49_sl6/v02-00-02/init_ilcsoft.sh

ildconfig=/cvmfs/ilc.desy.de/sw/ILDConfig/v02-00-02/StandardConfig/production

## 2. Setup links to files
echo "ILCSOFT is ${ILCSOFT}"
which Marlin

ln -sf ${ildconfig}/PandoraSettings .
ln -sf ${ildconfig}/HighLevelReco .

bkgdir=/hsm/ilc/grid/storm/prod/ilc/mc-opt-3/ild/sim/500-TDR_ws
aalowpt_WW=`find ${bkgdir}/aa_lowpt_WW/ILD_l5_v02/v02-00-01 -name "*.slcio" -print | head -1`
aalowpt_BW=`find ${bkgdir}/aa_lowpt_BW/ILD_l5_v02/v02-00-01 -name "*.slcio" -print | head -1`
aalowpt_WB=`find ${bkgdir}/aa_lowpt_WB/ILD_l5_v02/v02-00-01 -name "*.slcio" -print | head -1`
aalowpt_BB=`find ${bkgdir}/aa_lowpt_BB/ILD_l5_v02/v02-00-01 -name "*.slcio" -print | head -1`
seeablepairs=`find ${bkgdir}/seeablepairs/ILD_l5_v02/v02-00-01 -name "*.slcio" -print | head -1`
## 4. Run marlin
echo ${lcgeo_DIR}

#   --constant.DetectorModel=${recdetector} \
#

time Marlin /cvmfs/ilc.desy.de/sw/ILDConfig/v02-00-02/StandardConfig/production/MarlinStdReco.xml \
  --global.LCIOInputFiles=../runddsim/bbudsc_3evt.m${simdetector}.slcio \
  --constant.OutputBaseName=bbudsc_3evt.m${recdetector} \
  --constant.DetectorModel=${recdetector} \
  --constant.lcgeo_DIR=${lcgeo_DIR} \
  --constant.RunOverlay=true \
  --constant.CMSEnergy=500 \
  --BgOverlayWW.InputFileNames=${aalowpt_WW} \
  --BgOverlayWB.InputFileNames=${aalowpt_WB} \
  --BgOverlayBW.InputFileNames=${aalowpt_BW} \
  --BgOverlayBB.InputFileNames=${aalowpt_BB} \
  --PairBgOverlay.InputFileNames=${seeablepairs} 
