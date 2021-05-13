#!/bin/bash 


. /cvmfs/ilc.desy.de/sw/x86_64_gcc82_centos7/v02-02-01/init_ilcsoft.sh

echo ${lcgeo_DIR}

geoDisplay -compact ${lcgeo_DIR}/ILD/compact/ILD_l5_v05/ILD_l5_v05.xml
