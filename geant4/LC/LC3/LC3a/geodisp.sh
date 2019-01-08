#!/bin/bash 

# . /cvmfs/clicdp.cern.ch/iLCSoft/builds/2018-10-26/x86_64-slc6-gcc7-opt/init_ilcsoft.sh 

. /cvmfs/ilc.desy.de/sw/x86_64_gcc49_sl6/v02-00-02/init_ilcsoft.sh

echo ${lcgeo_DIR}

geoDisplay -compact ${lcgeo_DIR}/ILD/compact/ILD_l5_v05/ILD_l5_v05.xml
