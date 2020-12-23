#!/bin/bash 

cput=$1
queue=""
if [ "x${cput}" != "x" ] ; then 
   queue="-${cput}"
fi

arcsub -j arcjob${queue}.xml -o jobid${queue}.txt -c https://kek2-ce01.cc.kek.jp/arex arcjob${queue}.xrsl

# arcsub --debug=DEBUG -j jobs.xml -o jobid.txt -c https://kek2-ce02.cc.kek.jp/arex test.xrsl

