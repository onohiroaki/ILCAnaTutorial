#!/bin/bash 

. /cvmfs/ilc.desy.de/sw/x86_64_gcc82_centos7/v02-02-01/init_ilcsoft.sh

if [ ! -e lcgeo ] ; then 
  ln -s ${lcgeo_DIR} lcgeo
fi

geoDisplay -compact simple01.xml
