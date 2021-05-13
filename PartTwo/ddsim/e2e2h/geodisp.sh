#!/bin/bash 

# ######################################################################
# geoDisplay displays detector geometry by ROOT.
# 
# Usefull command in ROOT's GL viewer
#   Clipping --> Plane
#            --> bY = 0, aX = -1
#            --> Apply
#
#   Help --> Help on GL Viewer ...  ; Show help 
#   j = zoom in, k = zoom out
#   right-mouse-button --> VisibleDaughters off 
# ######################################################################


. /cvmfs/ilc.desy.de/sw/x86_64_gcc82_centos7/v02-02-01/init_ilcsoft.sh

echo ${lcgeo_DIR}

geoDisplay -compact ${lcgeo_DIR}/ILD/compact/ILD_l5_v05/ILD_l5_v05.xml
