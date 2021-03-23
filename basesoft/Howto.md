# How to install lcio and root 

How to install lcio and root using the ilcsoft tool is described below, 
in the case of CentOS7 and gcc82. 

## Setting compiler and python2.7 

```
export PATH=/cvmfs/sft.cern.ch/lcg/releases/LCG_96/Python/2.7.16/x86_64-centos7-gcc8-opt/bin:${PATH}
export LD_LIBRARY_PATH=/cvmfs/sft.cern.ch/lcg/releases/LCG_96/Python/2.7.16/x86_64-centos7-gcc8-opt/lib:${LD_LIBRARY_PATH}
export CXX=g++
export CC=gcc
```

## Download iLCInstall from github, then run ilcsoft-install

```
mkdir ilcinstall
cd ilcinstall
wget https://github.com/iLCSoft/iLCInstall/archive/v02-02-01.tar.gz
tar zxf v02-02-01.tar.gz
cd iLCInstall-02-02-01

cp releases/LATEST/release-versions.py . 
cp releases/LATEST/release-base.cfg .
patch release-base.cfg < ../../release-base.cfg.patch


./ilcsoft-install -j <num_cores> --install-prefix=<install_dir> -i release-base.cfg

```

where `<install_dir>` is a directory to install lcio and root. `<num_cores>` is the number of cores to be used 
during the build.  At KEKCC, ftp downloading of gsl source fails. For http download, edit  
iLCInstall-02-02-01/ilcsoft/gsl.py and modify 
`self.download.url = "ftp://ftp.gnu.org/....` to 
`self.download.url = "http://ftp.gnu.org/....`.

This installation turns off `DAVIX` of root, as the downloading of DAVIX source fails as of this writing.


## Run lcio and root.

Environment parameters to use lcio, root, etc is initialized by 
```
source <install_dir>/init_ilcsoft.sh
```

## Install to ubuntu-20.04LTS-ja
Installation method above should work for ubuntu-20.04LTS,
using the default compiler, gcc-9.3.0 and python2-2.7.18. 

Dependant packages have to be installed in advance. They are 
```
# Compilers, python2, ...
sudo apt install gcc g++ gfortran git 
sudo apt install python2 libpython2.7-dev libpython2-stdlib
sudo apt install make curl cmake doxygen 
sudo apt install mysql-client libmysqlclient-dev

# Especially for root
sudo apt install llvm llvm-10 libclang-dev 
sudo apt install libxml2-dev libxpm-dev libxft-dev libxext-dev xpmutils uuid-dev 
sudo apt install libopengl-dev
sudo apt install 

```

## root installation with DAVIX
If DAVIX is required, a possible way to build would be 
```
# Do following command at ~/Tutorial/basesoft/root

## Rename existing directories
mv 6.18.04 6.18.04-old
mv build-6.18.04 build-6.18.04-old

## Get root source and apply patch to davix/CMakeLists.txt
wget https://root.cern.ch/download/root_v6.18.04.source.tar.gz
tar zxf root_v6.18.04.tar.gz
mv root_v6.18.04 6.18.04
( cd 6.18.04/builtins/davix && patch CMakeLists.txt < ../../../../builtin-davix.patch )

## Re-build root with options of ilcsoft
mkdir build-6.18.04
cd build-6.18.04
cmake -DCMAKE_INSTALL_PREFIX=<install_dir> \ 
   -DGSL_ROOT_DIR=${GSL_HOME} \ 
   -DGSL_CONFIG_EXECUTABLE=${GSL_HOME}/bin/gsl-config \
   -Dgsl_shared=ON -Dgdml=ON -Dminuit2=ON -Droofit=ON \
   -Dunran=ON -Dxrootd=ON -Dmathmore=ON -Dbuiltin_xrootd=ON -Dbuiltin_gsl=OFF \ 
   -Dfortran=OFF -Dmysql=OFF -Dsqlite=OFF -Droot7=ON -Dwebgui=ON \
   ../6.18.04
make -j24
```
where 
```
<install_dir> : is where root is installed.  
```

