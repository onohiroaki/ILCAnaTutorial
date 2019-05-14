#!/bin/bash 

outfile="hcal.prim"
datadir="../primadd.dat"
scriptsdir="../../scripts"

cat ${scriptsdir}/00header.dat > ${outfile}

while read f ; do
  cat ${datadir}/${f} >> ${outfile}
done <<EOF
ElectronicsInterfaceLayerLogical.dat
FEELayerCu.dat
FEELayer.dat
FEELayerFR4.dat
FEELayerSteel.dat
HcalBarrel.dat
HcalEndcap.dat
HcalEndCapRingLogical.dat
HcalEndCapRingStaveLogical.dat
HcalRing.dat
EOF

cat ${scriptsdir}/zz_tail.dat >> ${outfile}

