#!/bin/bash 

# Make sure to use the same compiler as root, lcio, ...
. /cvmfs/sft.cern.ch/lcg/releases/gcc/8.2.0-3fa06/x86_64-centos7/setup.sh
export PATH=/cvmfs/sft.cern.ch/lcg/releases/LCG_96/Python/2.7.16/x86_64-centos7-gcc8-opt/bin:${PATH}
export LD_LIBRARY_PATH=/cvmfs/sft.cern.ch/lcg/releases/LCG_96/Python/2.7.16/x86_64-centos7-gcc8-opt/lib:${LD_LIBRARY_PATH}

version=4.05.0
install_dir=${HOME}/Tutorial/sw/x86_64_gcc82_centos7/ocaml/${version}
wget https://github.com/ocaml/ocaml/archive/${version}.tar.gz
tar zxf ${version}.tar.gz

cd ocaml-${version}
./configure -prefix ${install_dir}

echo "`date` make world.opt 1st"
make world.opt 
boot/ocamlrun

echo "`date` make world.opt 2nd"
make world.opt
boot/ocamlrun

echo "`date` make 1nstall 1st"
make install
boot/ocamlrun

echo "`date` make install 2nd"
make install

