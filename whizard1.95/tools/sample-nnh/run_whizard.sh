#!/bin/bash 


.  /sw/ilc/gcc481/setup-gcc481.sh

. lumilinker_setup.sh 

echo "### Start whizard : `date` "

./whizard

echo "### whizard completed : `date` "


