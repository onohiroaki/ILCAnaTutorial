#!/bin/bash

outdir=`pwd`/primadd.dat
mkdir -p ${outdir}
sdir=prim
list=all.list


while read f ; do 
  outfile=${outdir}/${f}.dat
  echo "Creating ${outfile}"
  for d in ${sdir}/${f}* ; do 
    cat ${d}/*.dat >> ${outfile}
  done
done < ${list}


