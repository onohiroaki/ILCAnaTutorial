#!/bin/bash 

geardir=/cvmfs/ilc.desy.de/sw/ILDConfig/v02-00-02/StandardConfig/production/Gear

ced2go -v CEDViewer -d ${geardir}/gear_ILD_l5_v02.xml \
    sim.E250GeV.Pee_mumu.mILD_l5_v02.slcio

