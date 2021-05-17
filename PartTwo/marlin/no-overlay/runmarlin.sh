#!/bin/bash
# ############################################################
# Example to run Marlin without background overlay.
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
recbasename="rv02-02-01.m${rec_detector}_nobg.`basename ${simfile} .slcio`.d"

## 2. Setup links to files

ln -sf ${ildconfig}/PandoraSettings .
ln -sf ${ildconfig}/HighLevelReco .

## 4. Run marlin

Marlin ${ildconfig}/MarlinStdReco.xml \
  --global.LCIOInputFiles=${simdir}/${simfile} \
  --constant.OutputBaseName=${recbasename} \
  --constant.DetectorModel=${rec_detector} \
  --constant.lcgeo_DIR=${lcgeo_DIR} 

echo "### ddsim completed at `date` "
echo "### This is the last line of runddsim.sh output. (except 3 more blank lines) #########################"
echo ""
echo ""
echo ""

# ######################################################################################
# (Note)
# 1. Simulated files produced by mc-2020 is in /hsm/ilc/grid/storm/prod/ilc/mc-2020/ild/sim/
# 2. Other usefull command line option includes
#   --global.MaxRecordNumber=<N>   # 0 to analize all events
#   --global.SkipNEvents=<N>       # default is 0
#   --global.Verbosity=<verbosity> # 
#    <parameter name="Verbosity" options="DEBUG0-4,MESSAGE0-4,WARNING0-4,ERROR0-4,SILENT"> MESSAGE </parameter>
#   See MarlinStandardReco.xml for full options.
#
# ######################################################################################

