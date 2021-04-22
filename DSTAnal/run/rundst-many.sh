#!/bin/bash

export MARLIN_DLL=   # Clear MARLIN_DLL before source init_ilcsoft.sh 

. /cvmfs/ilc.desy.de/sw/x86_64_gcc82_centos7/v02-02-01/init_ilcsoft.sh   # Latest ILCSoft

export MARLIN_DLL=../lib/libmydstanal.so:${MARLIN_DLL}

gearfile=/cvmfs/ilc.desy.de/sw/ILDConfig/v02-02-01/StandardConfig/production/Gear/gear_ILD_l5_v02.xml

maxrecords=0   # Analize all events

dstdir=/group/ilc/grid/storm/prod/ilc/mc-2020/ild/dst-merged/250-SetA/higgs/ILD_l5_o1_v02/v02-02
# dstfile=rv02-02.sv02-02.mILD_l5_o1_v02.E250-SetA.I402009.Pn23n23h.eL.pR.n000.d_dstm_15095_0.slcio

# Number of input files is limitted to 20, to avoid memory liit over.
infile=`find ${dstdir} -name "*.I402009.*.slcio" -print | head -20 | xargs -I{} echo -n "{} "` 

echo "Following files will be analized."
echo ${infile}

Marlin --global.LCIOInputFiles="${infile}" \
       --global.GearXMLFile=${gearfile} \
       --global.MaxRecordNumber=${maxrecords} \
       --MyMyDSTProcessor.RootFileName=myanal_many.root \
       mydstanal.xml

