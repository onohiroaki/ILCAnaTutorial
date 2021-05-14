#!/bin/bash

. /cvmfs/ilc.desy.de/sw/x86_64_gcc82_centos7/v02-02-01/init_ilcsoft.sh

if [ ! -e lcgeo ] ; then 
  ln -s ${lcgeo_DIR} lcgeo
fi

ddsim  --compactFile exam01.xml \
       --gun.energy "1.0*GeV" \
       --enableGun \
       --gun.particle proton \
       --gun.thetaMin 1.0 \
       --gun.thetaMax 2.0 \
       --gun.distribution uniform \
       --macroFile init_vis.mac \
       --runType vis

# ######################################################################
# Usefull commands during an interactive session
#  help              # Show help
#  /run/beamOn <N>   # simulate <N> events
#  /ddg4/Gun/Energy <energy>*<unit>    # /ddg4/Gun/Energy 1.0*GeV  for example.
#  /ddg4/Gun/particle <particle_name>  # Particle name to generate.  
#                                      # For example, mu-, kaon0S, tau+, sigma0, ...
#  /particle/list                      # list particles defined in geant4 
#
