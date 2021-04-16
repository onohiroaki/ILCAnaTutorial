#!/bin/bash

# #######################################################################
# Warning
# This example allocates only one file for each type of background.
# Good for only small number of signal events. 
# Not suitable to process many number of events.
# #######################################################################

# #######################################################
getBkgFile()
{
  find ${1} -name "*.slcio" -print > temp.list
  nfile=`cat temp.list | wc -l`
  if [ ${nfile} -lt 1 ] ; then
    echo "### ERROR not file find in ${1}"
    return 
  fi
  pick_line=$[${RANDOM}*${nfile}/32768+1]
  pickfile=`sed -n ${pick_line}P temp.list`
  echo ${pickfile}
}
# #######################################################

recdetector=ILD_l5_o1_v02
simdetector=`echo ${recdetector} | cut -d"_" -f1,2,4`
cmsenergy=250

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

bkgdir=/group/ilc/grid/storm/prod/ilc/mc-2020/ild/sim/250-SetA
aalowpt_WW=`getBkgFile ${bkgdir}/aa_lowpt_WW/ILD_l5_v02/v02-02/00015330`
aalowpt_BW=`getBkgFile ${bkgdir}/aa_lowpt_BW/ILD_l5_v02/v02-02/00015324`
aalowpt_WB=`getBkgFile ${bkgdir}/aa_lowpt_WB/ILD_l5_v02/v02-02/00015325`
aalowpt_BB=`getBkgFile ${bkgdir}/aa_lowpt_BB/ILD_l5_v02/v02-02/00015323`
seeablepairs=`getBkgFile ${bkgdir}/seeablepairs/ILD_l5_v02/v02-02/00015322`
## 4. Run marlin
echo ${lcgeo_DIR}
echo "##### Following background files are found. ############################"
echo "aa_lowpt_WW=${aalowpt_WW}"
echo "aa_lowpt_BW=${aalowpt_BW}"
echo "aa_lowpt_WB=${aalowpt_WB}"
echo "aa_lowpt_BB=${aalowpt_BB}"
echo "seeablepairs=${seeablepairs}"
echo "########################################################################"


time Marlin /cvmfs/ilc.desy.de/sw/ILDConfig/v02-02/StandardConfig/production/MarlinStdReco.xml \
  --global.LCIOInputFiles=../runddsim/bbudsc_3evt.m${simdetector}.slcio \
  --constant.OutputBaseName=bbudsc_3evt.m${recdetector} \
  --constant.DetectorModel=${recdetector} \
  --constant.lcgeo_DIR=${lcgeo_DIR} \
  --constant.RunOverlay=true \
  --constant.CMSEnergy=${cmsenergy} \
  --BgOverlayWW.InputFileNames="${aalowpt_WW}" \
  --BgOverlayWB.InputFileNames="${aalowpt_WB}" \
  --BgOverlayBW.InputFileNames="${aalowpt_BW}" \
  --BgOverlayBB.InputFileNames="${aalowpt_BB}" \
  --PairBgOverlay.InputFileNames="${seeablepairs}"
 
