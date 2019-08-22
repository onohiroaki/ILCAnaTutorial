#!/bin/bash 
#
# Install circe2 and download circe2 data file.
#

mkdir -p circe2

( 
  cd circe2
  
  circe2_version=circe2-2.3.1
  circe2_targz=${circe2_version}.tar.gz
  install_dir=`dirname ${PWD}`
  
  if [ ! -e ${circe2_targz} ] ; then 
     wget https://whizard.hepforge.org/oldsrc/circe2-2.3.1.tar.gz
  fi
  
  tar zxf ${circe2_targz}
  (
    cd ${circe2_version}
    # ./configure --disable-ocaml --prefix=${install_dir}
    ./configure --disable-ocaml --enable-static=no --prefix=${install_dir}
    make 
    make install
    cp -pv src/.libs/*.o ${install_dir}/lib
  )

  circe2_ilc=${install_dir}/share/ilc
  if [ ! -e ${circe2_ilc}/250-TDR_ws-ee.circe2 ] ; then 
    mkdir -p ${install_dir}/share/ilc
    ( 
      cd ${install_dir}/share/ilc
      wget https://www-jlc.kek.jp/~miyamoto/CDS/whizard2/circe2/250-TDR_ws-ee.circe2.gz
      gunzip 250-TDR_ws-ee.circe2.gz
      echo "250-TDR_ws-ee.circe2 was downloaded to `pwd` "
    )
  fi
  
)

echo "Install circe2 completed."

