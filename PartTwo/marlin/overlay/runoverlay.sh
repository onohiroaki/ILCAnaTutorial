#!/bin/bash
# ############################################################
# Example to run Marlin with background overlay.
# ############################################################
#

## 1. Initialize the current ilcsoft release
unset MARLIN_DLL     # Clear existing setting
softdir=/cvmfs/ilc.desy.de/sw
. ${softdir}/x86_64_gcc82_centos7/v02-02-01/init_ilcsoft.sh
ildconfig=${softdir}/ILDConfig/v02-02-01/StandardConfig/production

## 2. Input parameters
# detector and analysis option
rec_detector="ILD_l5_o1_v02" # Other detector model can be found in
                         # ${lcgeo_DIR}/ILD/comnact/README.md

# simdir=/group/ilc/users/miyamoto/data/20210524
# simfile=sv02-02-01.E250-SetA.Pe2e2h.eL.pR.I402003.n0.slcio  # 1000 events in this file.
simdir=../../ddsim/e2e2h
simfile=sv02-02-01.E250-SetA.Pe2e2h.eL.pR.I402003.n0.slcio
recbasename="rv02-02-01.m${rec_detector}.`basename ${simfile} .slcio`.d"

# Get number of events from input file
nevents=`lcio_event_counter ${simdir}/${simfile}`

# Get CM energy from the E-key_word in the file name
cmsenergy=`echo ${simfile} | sed -e "s/\./\n/g" | grep -e "^E" | cut -d"-" -f1 | sed -e "s/E//g"`

# Get a list of background files to overlay
ww=`./getBGFiles.py ww ${nevents}`
wb=`./getBGFiles.py wb ${nevents}`
bw=`./getBGFiles.py bw ${nevents}`
bb=`./getBGFiles.py bb ${nevents}`
pairs=`./getBGFiles.py pairs ${nevents}`

## 2. Setup links to files

ln -sf ${ildconfig}/PandoraSettings .
ln -sf ${ildconfig}/HighLevelReco .

## 4. Run marlin

Marlin ${ildconfig}/MarlinStdReco.xml \
  --global.LCIOInputFiles=${simdir}/${simfile} \
  --constant.OutputBaseName=${recbasename} \
  --constant.DetectorModel=${rec_detector} \
  --constant.lcgeo_DIR=${lcgeo_DIR} \
  --constant.RunOverlay=true \
  --constant.CMSEnergy=${cmsenergy} \
  --BgOverlayWW.InputFileNames="${ww}" \
  --BgOverlayWB.InputFileNames="${wb}" \
  --BgOverlayBW.InputFileNames="${bw}" \
  --BgOverlayBB.InputFileNames="${bb}" \
  --PairBgOverlay.InputFileNames="${pairs}"

echo "### runoverlay completed at `date` "
echo "### This is the last line of runoverlay.sh output. (except 3 more blank lines) #########################"
echo ""
echo ""
echo ""

