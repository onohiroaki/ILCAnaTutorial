#!/bin/bash 

outfile="av.prim"
datadir="../primadd.dat"
scriptsdir="../../scripts"

cat ${scriptsdir}/00header.dat > ${outfile}
cat ${datadir}/av_33.dat >> ${outfile}

echo "Special treatment for following geometry to avoid error in downcut"
( cd ../prim && /bin/ls -d av_34_* | grep -v "_impr_1_CoolPipe_" ) | \
while read d ; do 
    cat ${datadir}/${d}/*.dat >> ${outfile}
done

cat ${datadir}/av_3[5-9].dat >> ${outfile}
cat ${datadir}/av_[45]*.dat >> ${outfile}

cat ${scriptsdir}/zz_tail.dat >> ${outfile}


