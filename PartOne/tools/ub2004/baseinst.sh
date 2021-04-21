#
#
# install ilcsoft-base 
# 
# Required packages
# apt install -y net-tools gcc g++ gfortran openssh-server vim git
# apt install -y ocaml python2 mysql-client libmysqlclient-dev make curl 
# apt install -y libclang-dev libopengl-dev llvm-10 llvm
# apt install -y doxygen cmake libxml2-dev uuid-dev 
# apt install -y libxpm-dev xpmutils libxft-dev libxext-dev
# apt install -y libpython2.7-dev libpython2-stdlib
# apt install -y dpkg-dev gsl-bin libgsl-dev python-numpy libjpeg-dev libgif-dev libtiff-dev cmake-curses-gui
# apt install -y imagemagick mesa-common-dev libglu1-mesa-dev

./ilcsoft-install -j 8 --install-prefix=${HOME}/Tutorial/sw/x86_64_gcc93_ub2004 -i release-base.cfg


