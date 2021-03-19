#
# Install lcio and root, without geant4 and ilcsoft

Required packages are built using ilcinstall tool

```
cd ~/Tutorial/basesoft
mkdir ilcinstall
wget https://github.com/iLCSoft/iLCInstall/archive/v02-02-01.tar.gz
tar zxf v02-02-01.tar.gz
cd iLCInstall-02-02-01

cp releases/LATEST/release-versions.py

# setup gcc82 and python2 environment by 
. /cvmfs/sft.cern.ch/lcg/releases/gcc/8.2.0-3fa06/x86_64-centos7/setup.sh

export PATH=/cvmfs/sft.cern.ch/lcg/releases/LCG_96/Python/2.7.16/x86_64-centos7-gcc8-opt/bin:${PATH}
export LD_LIBRARY_PATH=/cvmfs/sft.cern.ch/lcg/releases/LCG_96/Python/2.7.16/x86_64-centos7-gcc8-opt/lib:${LD_LIBRARY_PATH}
export CXX=g++
export CC=gcc
 


# To built default base soft of iLCInstall ( lcio not included )
cp releases/LATEST/release-base.cfg .

# To built only lcio, root, and only other dependants
cp ../tutorial-base.cfg . 

# increase or decrease ncores if you have more or less cores

```

Install directory is defined by ilcsoft_install_prefix. 
The default location of release-base.cfg is $HOME/ilcsoft, 
and tutorial-base.cfg is $HOME/Tutorial/basesoft. 
Modify to install to other location.

```

```
vim iLCInstall-02-02-01/ilcsoft/gsl.py 

       # self.download.url = "ftp://ftp.gnu.org/gnu/gsl/gsl-" + self.version + ".tar.gz"
        self.download.url = "http://ftp.gnu.org/gnu/gsl/gsl-" + self.version + ".tar.gz"

```

# Install packages 

./ilcsoft-install -i tutorial-base.cfg






