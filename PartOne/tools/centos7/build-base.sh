#!/bin/bash 

## Install root, lcio, and dependant software
# 
# Install required packages by 
#  sudo yum install  mysql mariadb-devel libXpm-devel libXft-devel libXext-devel doxygen
#  

# Get the latest ILCSoft
wget https://github.com/iLCSoft/iLCInstall/archive/v02-02-01.tar.gz
tar zxf v02-02-01.tar.gz
cd iLCInstall-02-02-01

cp releases/LATEST/release-versions.py .
cp ../../partone-base.cfg .

# Setup compiler environment.

. /cvmfs/sft.cern.ch/lcg/releases/gcc/8.2.0-3fa06/x86_64-centos7/setup.sh
export PATH=/cvmfs/sft.cern.ch/lcg/releases/LCG_96/Python/2.7.16/x86_64-centos7-gcc8-opt/bin:${PATH}
export LD_LIBRARY_PATH=/cvmfs/sft.cern.ch/lcg/releases/LCG_96/Python/2.7.16/x86_64-centos7-gcc8-opt/lib:${LD_LIBRARY_PATH}
export CXX=g++
export CC=gcc

ncores=8    # Number of cores to use for build
./ilcsoft-install -j ${ncores} --install-prefix=${HOME}/Tutorial/sw/x86_64_gcc82_centos7 \
    -i partone-base.cfg 

