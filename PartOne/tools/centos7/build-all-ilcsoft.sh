#
# WARNING: Do not mix installation by build-base.sh and baseinst.sh
# They write to the same directory.
#
# install ilcsoft-base and ilcsoft itself.
# 
install_dir=${HOME}/Tutorial/sw/x86_64_gcc82_centos7
ncores=8    # Number of cores to use for build

if [ -d ${install_dir}/root ] ; then
  echo "${install_dir}/root exists. Are sure ? Don't mix build-base.sh and baseinst.sh"
  echo -n "Are you sure (y to continue):"
  read ans
  if [ "x${ans}" != "xy" ] ; then 
     exit
  fi
fi

# Get the latest ILCSoft
wget https://github.com/iLCSoft/iLCInstall/archive/v02-02-01.tar.gz
tar zxf v02-02-01.tar.gz
cd iLCInstall-02-02-01

# Setup compiler environment.

. /cvmfs/sft.cern.ch/lcg/releases/gcc/8.2.0-3fa06/x86_64-centos7/setup.sh
export PATH=/cvmfs/sft.cern.ch/lcg/releases/LCG_96/Python/2.7.16/x86_64-centos7-gcc8-opt/bin:${PATH}
export LD_LIBRARY_PATH=/cvmfs/sft.cern.ch/lcg/releases/LCG_96/Python/2.7.16/x86_64-centos7-gcc8-opt/lib:${LD_LIBRARY_PATH}
export CXX=g++
export CC=gcc

# Install base soft
./ilcsoft-install -j ${ncores} --install-prefix=${install_dir} -i release-base.cfg

# Install ilcsoft itself
./ilcsoft-install -j ${ncores} --install-prefix=${install_dir} -i release-ilcsoft.cfg

