#!/bin/bash
#
# Example to run Marlin. 
# 

export MARLIN_DLL=   # Reset MARLIN_DLL.  Libraries define in MARLIN_DLL are loaded dynamically
softdir=/sw/ilc/ilcsoft
ilcsoftdir=${softdir}/cvmfs/x86_64_gcc44_sl6/v01-16-02-p1
ildconfigdir=${softdir}/cvmfs/ILDConfig/v01-16-p10_250

. ${ilcsoftdir}/init_ilcsoft.sh

export MARLIN_DLL=${ROOTSYS}/lib/libTreePlayer.so:${ROOTSYS}/lib/libGui.so:${ROOTSYS}/lib/libGed.so:${MARLIN_DLL}

STDCONFIG=${ildconfigdir}/StandardConfig/current  # Standard ILDConfig directory.

ln -sf ${STDCONFIG}/PandoraLikelihoodData9EBin.xml .     # required by PandoraSettingsDefault.xml
pandora_settings=${STDCONFIG}/PandoraSettingsDefault.xml # Pandora parameter file

# lowpt pair background file fo BCAL
background_filename=${STDCONFIG}/bg_aver.sv01-14-01-p00_fieldX02.mILD_o1_v05.E250-TDR_ws.PBeamstr-pairs.I270000.root

# For background overlay. aa_lowpt background simulated file.
aalowpt_dir=/group/ilc/soft/samples/mc-dbd/ild/sim/250-TDR_ws/aa_lowpt/eL80.pR30/ILD_o1_v05/v01-14-01-p03
aalowpt_file=${aalowpt_dir}/sv01-14-01-p03.mILD_o1_v05.E250-TDR_ws.Paa_lowpt.I106725.eL80.pR30-04367.slcio

# Gear detector geometry file used by Mokka simulation
gear_xml_file=../runmokka/GearOutput.xml

# Input and output file
input_file=../runmokka/sv01-14-01-p00.mILD_o1_v05.pE250-TDR_ws.Pe2e2h.Gwhizard-1_95.eL.pR.I990001.z20evt.slcio
output_rec_file=rv01-16-p10_250.sv01-14-01-p00.mILD_o1_v05.E250-TDR_ws.I990001.Pe2e2h.eR.pL.dREC.z20evt.slcio
output_dst_file=rv01-16-p10_250.sv01-14-01-p00.mILD_o1_v05.E250-TDR_ws.I990001.Pe2e2h.eR.pL.dDST.z20evt.slcio

# Start Marlin here
# Non-default values are modified by command line options.
time Marlin --global.LCIOInputFiles=${input_file} \
     --global.GearXMLFile=${gear_xml_file} \
     --MyBCalReco.BackgroundFilename=${background_filename} \
     --MyMarlinPandora.PandoraSettingsXmlFile=${pandora_settings} \
     --BgOverlay.InputFileNames=${aalowpt_file} \
     --MyLCIOOutputProcessor.LCIOOutputFile=${output_rec_file} \
     --DSTOutput.LCIOOutputFile=${output_dst_file} \
     ${STDCONFIG}/bbudsc_3evt_stdreco.xml

