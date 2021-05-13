#!/bin/bash

## 1. Initialize the current ilcsoft release

softdir=/cvmfs/ilc.desy.de/sw
. ${softdir}/x86_64_gcc82_centos7/v02-02-01/init_ilcsoft.sh
ildconfig=${softdir}/ILDConfig/v02-02-01/StandardConfig/production

## 2. input generated data
gendir=/group/ilc/grid/storm/prod/ilc/mc-2020/generated/250-SetA/higgs
genfile=E250-SetA.Pe2e2h.Gwhizard-2_8_5.eL.pR.I402003.0.slcio
simfile=sv02-02-01.E250-SetA.Pe2e2h.eL.pR.I402003.n0.slcio
detector="ILD_l5_v02"
steeringFile=${ildconfig}/ddsim_steer.py   # Use the steering file in ILDConfig
numberOfEvents=5     # Number of events to simulate. Should not exceed number of events 
                     # in generated file. Otherwise Run Time error exception is thrown at the end

####################################################################################################
### Vertex smearing parameter for 250-SetA. Should be changed depending on the beam nature.
### See /cvmfs/ilc.desy.de/sw/ILDConfig/v02-02-01/StandardConfig/production/Documentation/ProductionSettings.md
vertexSigma="0.0 0.0 0.202 0.0" # Sigma of vertex sigma X Y Z T
vertexOffset="0.0 0.0 0. 0.0"   # Offset of vertex point X Y Z T
####################################################################################################

## 2. run the lcgeo/ddsim simulation example

echo "### ddsim starts at `date`"
ddsim --inputFiles ${gendir}/${genfile} \
      --outputFile ${simfile} \
      --numberOfEvents ${numberOfEvents} \
      --compactFile ${lcgeo_DIR}/ILD/compact/${detector}/${detector}.xml \
      --vertexSigma ${vertexSigma}  \
      --vertexOffset ${vertexOffset} \
      --steeringFile ${steeringFile} 
      
echo "### ddsim completed at `date` "

##################################################################################################
# Other usefull option of ddsim.  
#  -h, --help            show this help message and exit
#  --numberOfEvents NUMBEROFEVENTS, -N NUMBEROFEVENTS
#                        number of events to simulate, used in batch mode
#  --skipNEvents SKIPNEVENTS
#                        Skip first N events when reading a file
#  --crossingAngleBoost CROSSINGANGLEBOOST
#                        Lorentz boost for the crossing angle, in radian!
#                        Default is 7mrad, which is defined in ${ildconfig}/${steeringFile}
##################################################################################################

