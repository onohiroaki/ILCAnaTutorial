#!/bin/bash 

outfile="coil.prim"
datadir="../primadd.dat"
scriptsdir="../../scripts"

cat ${scriptsdir}/00header.dat > ${outfile}
cat ${datadir}/coil*.dat >> ${outfile}
cat ${scriptsdir}/zz_tail.dat >> ${outfile}


