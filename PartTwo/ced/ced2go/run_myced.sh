#
#  MyCED using myced_steering.xml
#

# If Marlin not in PATH, source init_ilcsoft
which Marlin > /dev/null 2>&1
if [ $? -ne 0 ] ; then
   unset MARLIN_DLL
   source /cvmfs/ilc.desy.de/sw/x86_64_gcc82_centos7/v02-02-01/init_ilcsoft.sh
fi

# Check CED_PORT
if [ -z ${CED_PORT} ] ; then
  echo "CED_PORT is undefined. use a default port."
else
  echo "CED_PORT ${CED_PORT} will be used."
fi

# View REC file
datadir=/group/ilc/grid/storm/prod/ilc/mc-2020/ild/rec/250-SetA/higgs_excl/ILD_l5_o1_v02/v02-02/00015206/000
datafile=rv02-02.sv02-02.mILD_l5_o1_v02.E250-SetA.I402137.Pe2e2h_bb.eL.pR.n000_024.d_rec_00015206_161.slcio
viewer="MyCEDViewer"

# View DST file : Uncomment this to view DST file.
# datadir=/group/ilc/grid/storm/prod/ilc/mc-2020/ild/dst-merged/250-SetA/higgs/ILD_l5_o1_v02/v02-02
# datafile=rv02-02.sv02-02.mILD_l5_o1_v02.E250-SetA.I402003.Pe2e2h.eL.pR.n000.d_dstm_15089_0.slcio
# viewer="MyDSTViewer"

# Example to view Delphes file. Add following two options
#       --MyDSTViewer.ParticleCollection="PFOs" \
#       --MyDSTViewer.JetCollections="Jets Durham_2Jets Durham_3Jets Durham_4Jets Durham_5Jets Durham_6Jets" \
datadir=~/Tutorial/data
datafile=delphes_E250.Pe2e2h.eL.pR.slcio
viewer="MyDSTViewer"

# Geometry file of ILD_L5_v02
gearfile=/cvmfs/ilc.desy.de/sw/ILDConfig/v02-02-01/StandardConfig/production/Gear/gear_ILD_l5_o1_v02.xml

Marlin --global.LCIOInputFiles=${datadir}/${datafile} \
       --global.GearXMLFile=${gearfile} \
       --constant.viewer=${viewer} \
       myced_steering.xml


gearfile=/cvmfs/ilc.desy.de/sw/ILDConfig/v02-02-01/StandardConfig/production/Gear/gear_ILD_l5_o1_v02.xml

Marlin --global.LCIOInputFiles=${datadir}/${datafile} \
       --global.GearXMLFile=${gearfile} \
       --constant.viewer=${viewer} \
       myced_steering.xml 

# ###############################################################
#
# Data layer in the case of DSTViewer
#   Data layer  1 : photon and others (muon?)
#               6 : TPC track
#               9 : Cluster ( by cylinder )
#              11 : Jets
#              18 : Cluster ( by ellipse )
#              19 : Cluster ( by ellipse )
#
#   data are obtained from "PandoraPFOs" except 11.
#           11 (Jets) are obtained from "JetOut Durham_2Jets Durham_3Jets Durham_4Jets Durham_5Jets Durham_6Jets"
# ###############################################################
~

