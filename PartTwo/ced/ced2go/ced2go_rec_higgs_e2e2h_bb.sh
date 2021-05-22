#!/bin/bash 
# 
#
#  ced2to will starts glced, then cedviewer.
#
#

# If ced2go not in PATH, source init_ilcsoft
which ced2go > /dev/null 2>&1 
if [ $? -ne 0 ] ; then 
   unset MARLIN_DLL
   source /cvmfs/ilc.desy.de/sw/x86_64_gcc82_centos7/v02-02-01/init_ilcsoft.sh
fi

# ######## Start ced2go here ##########################
# Free port for CED is searched by ced2go

datadir=/group/ilc/grid/storm/prod/ilc/mc-2020/ild/rec/250-SetA/higgs_excl/ILD_l5_o1_v02/v02-02/00015206/000
datafile=rv02-02.sv02-02.mILD_l5_o1_v02.E250-SetA.I402137.Pe2e2h_bb.eL.pR.n000_024.d_rec_00015206_161.slcio
gearfile=/cvmfs/ilc.desy.de/sw/ILDConfig/v02-02-01/StandardConfig/production/Gear/gear_ILD_l5_o1_v02.xml

ced2go -v CEDViewer -d ${gearfile} ${datadir}/${datafile}

