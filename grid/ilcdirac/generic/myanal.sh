#!/bin/bash

echo "### Start myanal.sh : `date`"
source /cvmfs/ilc.desy.de/sw/x86_64_gcc49_sl6/v02-00-02/init_ilcsoft.sh

echo "### Get list of lcio files in the current directory "
/bin/ls *.slcio 2>&1 | tee slcio.list

echo "### Do anajob of the lcio files in the current directory "

mkdir -p anajoblog
cat slcio.list | while read f ; do 
  {
    echo "### Doing anajob of ${f} "
    logpref=`basename ${f} .slcio`
    anajob $f > anajoblog/${logpref}.log
    tail -2 anajoblog/${logpref}.log 
  }
done 

echo "### Create tar file of anajob"
tar zcf anajoblog.tar.gz anajoblog

echo "### Allstep completed : `date` "

