#!/bin/bash 

outfile="ecal.prim"
datadir="../primadd.dat"
scriptsdir="../../scripts"

cat ${scriptsdir}/00header.dat > ${outfile}

while read f ; do
  cat ${datadir}/${f} >> ${outfile}
done <<EOF
Cu.dat
EcalBarrel.dat
EcalEndcap.dat
EcalEndcapQuadrant.dat
EcalPlug.dat
ECRing.dat
PELogical.dat
phiGap.dat
EOF

cat ${scriptsdir}/zz_tail.dat >> ${outfile}

