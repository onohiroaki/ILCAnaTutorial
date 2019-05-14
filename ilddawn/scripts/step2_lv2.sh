#!/bin/bash

outdir=`pwd`/primadd_lv2
mkdir -p ${outdir}
sdir=prim-v0
list=all_lv2.list


while read f ; do 
  outfile=${outdir}/${f}.dat
  echo "Creating ${outfile}"
  for d in ${sdir}/${f}* ; do 
    cat ${d}/*.dat >> ${outfile}
  done
done < ${list}


