#!/bin/bash

echo "### Start whizard build : Date `date` "
. /sw/ilc/gcc481/setup-gcc481.sh
whizdir=/sw/ilc/gcc481/whizard
setup=${whizdir}/tools/setup_for_whizard.sh
tgz=${whizdir}/orig/lcgentools-whizard-1.95-20150518.tar.gz
patchfile=${whizdir}/tools/configure.patch

# Do compile
mkdir -p build
cd build
cp -p ../whizard.prc .
#
wrkdir=`pwd`
tar zxf ${tgz}
. ${setup}
ln -sfv whizard-1.95-20150518 whizard-1.95
export WHZ=${wrkdir}/whizard-1.95

(
cd ${WHZ}
patch -p0 < ${patchfile}

./configure \
  USERLIBS="$(pwd)/a6f/include/pytaud.o $(pwd)/a6f/lib/libinclude.a $TAUOLALIB/libtauola.a $PHOTOSLIB/libphotos.a"
make libs
make -C a6f/include/ A6F=.. WHIZ=../.. WH195=../.. SHELL=/bin/bash
make test
cd results
make realclean
cd ..
cp -v ${wrkdir}/whizard.prc ${WHZ}/conf
make prg
make gml
make install
)

echo "### End of configure : Date `date` "

#cp -fva ${WHZ}/results .
ln -fs ${WHZ}/results .

echo "### Complete building binaries in : Date `date` "
