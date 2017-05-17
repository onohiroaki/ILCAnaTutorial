#!/bin/bash
#
# Example to run Marlin. 
# 

export MARLIN_DLL=
softdir=/sw/ilc/ilcsoft
ilcsoftdir=${softdir}/cvmfs/x86_64_gcc44_sl6/v01-16-02-p1
ildconfigdir=${softdir}/cvmfs/ILDConfig/v01-16-p10_250

. ${ilcsoftdir}/init_ilcsoft.sh

export MARLIN_DLL=${ROOTSYS}/lib/libTreePlayer.so:${ROOTSYS}/lib/libGui.so:${ROOTSYS}/lib/libGed.so:${MARLIN_DLL}

STDCONFIG=${ildconfigdir}/StandardConfig/current
ln -sf ${STDCONFIG}/PandoraLikelihoodData9EBin.xml .

pandora_settings=${STDCONFIG}/PandoraSettingsDefault.xml
background_filename=${STDCONFIG}/bg_aver.sv01-14-01-p00_fieldX02.mILD_o1_v05.E250-TDR_ws.PBeamstr-pairs.I270000.root
aalowpt_dir=/group/ilc/soft/samples/mc-dbd/ild/sim/250-TDR_ws/aa_lowpt/eL80.pR30/ILD_o1_v05/v01-14-01-p03
aalowpt_file=${aalowpt_dir}/sv01-14-01-p03.mILD_o1_v05.E250-TDR_ws.Paa_lowpt.I106725.eL80.pR30-04367.slcio

gear_xml_file=../runmokka/GearOutput.xml
input_file=../runmokka/E250-TDR_ws.Pe2e2h.Gwhizard-1_95.eL.pR.I106479.001.20evt.slcio
output_rec_file=REC.E250-TDR_ws.Pe2e2h.Gwhizard-1_95.eL.pR.I106479.001.20evt.slcio
output_dst_file=DST.E250-TDR_ws.Pe2e2h.Gwhizard-1_95.eL.pR.I106479.001.20evt.slcio


# Start Marlin here

time Marlin --global.LCIOInputFiles=${input_file} \
     --global.GearXMLFile=${gear_xml_file} \
     --MyBCalReco.BackgroundFilename=${background_filename} \
     --MyMarlinPandora.PandoraSettingsXmlFile=${pandora_settings} \
     --BgOverlay.InputFileNames=${aalowpt_file} \
     --MyLCIOOutputProcessor.LCIOOutputFile=${output_rec_file} \
     --DSTOutput.LCIOOutputFile=${output_dst_file} \
     ${STDCONFIG}/bbudsc_3evt_stdreco.xml

