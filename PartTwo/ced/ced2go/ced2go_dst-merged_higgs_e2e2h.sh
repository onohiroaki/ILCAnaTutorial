#
#  ced2to will starts glced, then cedviewer.
#

# If ced2go not in PATH, source init_ilcsoft
which ced2go > /dev/null 2>&1
if [ $? -ne 0 ] ; then
   unset MARLIN_DLL
   source /cvmfs/ilc.desy.de/sw/x86_64_gcc82_centos7/v02-02-01/init_ilcsoft.sh
fi

datadir=/group/ilc/grid/storm/prod/ilc/mc-2020/ild/dst-merged/250-SetA/higgs/ILD_l5_o1_v02/v02-02
datafile=rv02-02.sv02-02.mILD_l5_o1_v02.E250-SetA.I402003.Pe2e2h.eL.pR.n000.d_dstm_15089_0.slcio
gearfile=/cvmfs/ilc.desy.de/sw/ILDConfig/v02-02-01/StandardConfig/production/Gear/gear_ILD_l5_o1_v02.xml

ced2go -v DSTViewer -d ${gearfile} ${datadir}/${datafile}
# ced2go -v GenericViewer -d ${gearfile} ${datadir}/${datafile}

# ###############################################################
# 
# Data layer in the case of DSTViewer
#   Data layer  1 : Momentum at IP,   color by log(Energy)
#               6 : Charged track
#                   Color: pi+(red), pi-(orange), e-(blue), e+(violet), other(black)
#               9 : Cluster ( by cylinder ), color by log(Energy)
#              11 : Jets
#              18 : Cluster ( by ellipse )
#              19 : Cluster ( by ellipse )
#
#   data are obtained from "PandoraPFOs" except 11.
#           11 (Jets) are obtained from "JetOut Durham_2Jets Durham_3Jets Durham_4Jets Durham_5Jets Durham_6Jets"
# ###############################################################
