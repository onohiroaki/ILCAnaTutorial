#!/bin/bash

tdir=prim
mkdir -p ${tdir}
primfile="g4.prim"
curdir=header
mkdir -p ${tdir}/${curdir}
lastindex=${tdir}/${curdir}/index
echo "0" > ${lastindex}
lastfile=${tdir}/${curdir}/header.dat

pvname=
while read line ; do 
  haspv=`echo $line | grep -c PVName`
  if [ $haspv -ne 0 ] ; then 
    pvname=`echo $line | sed -e "s/  */ /g" | cut -d" " -f2 `
    curdir=${tdir}/${pvname}
    echo "$pvname  $curdir " >> prim2dat.log 
    mkdir -p ${curdir}
    curindex=${curdir}/index
    lastindex=0
    if [ -e ${curindex} ] ; then 
      lastindex=`cat ${curindex}`
    fi
    lastindex=$[$lastindex+1]
    echo "$lastindex" > ${curindex}
    lastfile=${curdir}/${lastindex}.dat
  fi
  echo "${line}" >> ${lastfile}
done < ${primfile}
