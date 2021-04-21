#!/bin/bash

echo "Build for gcc-8.2.5 ############################### "
echo "######## Whizard2 build: `date` ################### "
echo "######## setting env parameters ##############"

. /cvmfs/sft.cern.ch/lcg/releases/gcc/8.2.0-3fa06/x86_64-centos7/setup.sh
export PATH=/cvmfs/sft.cern.ch/lcg/releases/LCG_96/Python/2.7.16/x86_64-centos7-gcc8-opt/bin:${PATH}
export LD_LIBRARY_PATH=/cvmfs/sft.cern.ch/lcg/releases/LCG_96/Python/2.7.16/x86_64-centos7-gcc8-opt/lib:${LD_LIBRARY_PATH}

version=2.8.5
install_dir=${HOME}/Tutorial/sw/x86_64_gcc82_centos7
mkdir -p ${install_dir}/whizard2/${version}
setup_file=${install_dir}/whizard2/${version}/init_whizard2.sh
ncores=8      # Number of cores for compiling
#
# Create script to define whizard2 parameters
#

cat > ${setup_file}<<EOF
# Setup environparameters for whizard2
#
source /cvmfs/sft.cern.ch/lcg/releases/gcc/8.2.0-3fa06/x86_64-centos7/setup.sh
export CXX=g++
export CC=gcc

export PYTHONDIR=/cvmfs/sft.cern.ch/lcg/releases/LCG_96/Python/2.7.16/x86_64-centos7-gcc8-opt
export PATH=\${PYTHONDIR}/bin:\$PATH
export LD_LIBRARY_PATH=\${PYTHONDIR}/lib:\${LD_LIBRARY_PATH}

export OCAML_DIR=${install_dir}/ocaml/4.05.0
export HEPMC_DIR=/cvmfs/sft.cern.ch/lcg/releases/LCG_96/HepMC/2.06.09/x86_64-centos7-gcc8-opt
# export LCIO_DIR=${install_dir}/lcio/v02-16-01
export LCIO_DIR=/cvmfs/ilc.desy.de/sw/x86_64_gcc82_centos7/v02-02/lcio/v02-15-01

export LD_LIBRARY_PATH=\$LCIO_DIR/lib:\$HEPMC_DIR/lib:\${OCAML_DIR}/lib:\$LD_LIBRARY_PATH
export PATH=\$LCIO_DIR/bin:\${OCAML_DIR}/bin:\$PATH

#WHIZARD
export LD_LIBRARY_PATH=${install_dir}/whizard2/${version}/lib:\${LD_LIBRARY_PATH}
export PATH=${install_dir}/whizard2/${version}/bin:\$PATH

#m4
M4_DIR=/cvmfs/sft.cern.ch/lcg/releases/LCG_96/m4/1.4.18/x86_64-centos7-gcc8-opt
export LD_LIBRARY_PATH=\${M4_DIR}/lib:\${LD_LIBRARY_PATH}
export PATH=\${M4_DIR}/bin:\$PATH

EOF


source ${setup_file}

echo "Download and unpacking whizard-${version}.tar.gz"
wget http://whizard.hepforge.org/whizard-${version}.tar.gz
tar zxf whizard-${version}.tar.gz

echo "cd to `pwd`"
cd whizard-${version}

echo "Configure in progress"
./configure --enable-fastjet \
           --with-fastjet=/cvmfs/sft.cern.ch/lcg/releases/LCG_96/fastjet/3.3.2/x86_64-centos7-gcc8-opt \
           --prefix=${install_dir}/whizard2/${version} \
           --datadir=${install_dir}/whizard2/${version}/share \
           --docdir=${install_dir}/whizard2/${version}/doc/whizard \
           --disable-lhapdf \
           --enable-fc-debug \
           F77=gfortran  FC=gfortran CC=gcc CXX=g++

echo "make in progress"
make -j ${ncores}

echo "make check in progress"
make -j ${ncores} check 

echo "make install in progress"
make -j ${ncores} install 

echo "######## Whizard2 build completed : `date` ################### "

