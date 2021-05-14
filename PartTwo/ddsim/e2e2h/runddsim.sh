#!/bin/bash

## 1. Initialize the current ilcsoft release

softdir=/cvmfs/ilc.desy.de/sw
. ${softdir}/x86_64_gcc82_centos7/v02-02-01/init_ilcsoft.sh
ildconfig=${softdir}/ILDConfig/v02-02-01/StandardConfig/production

## 2. input parameters
numberOfEvents=10     # Number of events to simulate. Should not exceed number of events 
                      # in generated file. Otherwise Run Time error exception is thrown at the end
# input/output files
gendir=/group/ilc/grid/storm/prod/ilc/mc-2020/generated/250-SetA/higgs
genfile=E250-SetA.Pe2e2h.Gwhizard-2_8_5.eL.pR.I402003.0.slcio
simfile=sv02-02-01.E250-SetA.Pe2e2h.eL.pR.I402003.n0.slcio
# detectors
detector="ILD_l5_v02" # Other detector model can be found in 
                      # ${lcgeo_DIR}/ILD/comnact/README.md 
# 
steeringFile=${ildconfig}/ddsim_steer.py   # Use the steering file in ILDConfig

####################################################################################################
### Vertex smearing parameter for 250-SetA. Should be changed depending on the beam nature. 
### See ${ildconfig}/Documentation/ProductionSettings.md
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
echo "### This is the last line of runddsim.sh output. (except 3 more blank lines) #########################"
echo ""
echo ""
echo ""

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
#  -v {1,2,3,4,5,6,7,VERBOSE,DEBUG,INFO,WARNING,ERROR,FATAL,ALWAYS}, 
#  --printLevel {1,2,3,4,5,6,7,VERBOSE,DEBUG,INFO,WARNING,ERROR,FATAL,ALWAYS}
#                        Verbosity use integers from 1(most) to 7(least) verbose
#                        or strings: VERBOSE, DEBUG, INFO, WARNING, ERROR, FATAL, ALWAYS
#  --runType {batch,vis,run,shell}
#                        The type of action to do in this invocation
#                        batch: just simulate some events, needs numberOfEvents, and input file or gun
#                        vis: enable visualisation, run the macroFile if it is set
#                        run: run the macroFile and exit
#                        shell: enable interactive session
#
##################################################################################################
# Command line arguments and steering file used are written to the run header of output slcio file.
# Example to browse information saved in the header is  
#   anajob ${simfile} | sed -e "s/\\\n/\n/g" | more
#  
##################################################################################################

