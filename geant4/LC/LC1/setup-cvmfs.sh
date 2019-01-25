# 
# Setup using files on cvmfs

# g++ and python2.7

export PATH=/cvmfs/sft.cern.ch/lcg/contrib/gcc/4.9.3/x86_64-slc6/bin:/cvmfs/sft.cern.ch/lcg/releases/LCG_87/Python/2.7.10/x86_64-slc6-gcc49-opt/bin:${PATH}
export LD_LIBRARY_PATH=/cvmfs/sft.cern.ch/lcg/contrib/gcc/4.9.3/x86_64-slc6/lib64:/cvmfs/sft.cern.ch/lcg/contrib/gcc/4.9.3/x86_64-slc6/lib:/cvmfs/sft.cern.ch/lcg/releases/LCG_87/Python/2.7.10/x86_64-slc6-gcc49-opt/lib:${LD_LIBRARY_PATH}

# Setup cmake
export PATH="/cvmfs/ilc.desy.de/sw/x86_64_gcc49_sl6/CMake/3.6.3/bin:$PATH"
export CXX=g++
export CC=gcc
 
# Setup geant4 and cmake 
. /cvmfs/geant4.cern.ch/geant4/10.3.p03/x86_64-slc6-gcc49-opt/CMake-setup.sh 
. /cvmfs/geant4.cern.ch/geant4/10.3.p03/x86_64-slc6-gcc49-opt/bin/geant4.sh

# Setup root
. /cvmfs/ilc.desy.de/sw/x86_64_gcc49_sl6/root/6.08.06/bin/thisroot.sh
