#!/bin/bash 

outfile="center.prim"
datadir="../primadd.dat"
scriptsdir="../../scripts"

cat ${scriptsdir}/00header.dat > ${outfile}

while read f ; do
  cat ${datadir}/${f} >> ${outfile}
done <<EOF
FTDPetalSensitiveLogical.dat
FTDPetalSupportLogical.dat
railLogical.dat
SIT.dat
TPCCathodeConductorLog.dat
TPCCathodeInnerGripLog.dat
TPCcathodeInsulatorLog.dat
TPCCathodeLog.dat
TPCCathodeOuterGripLog.dat
TPCEndplateLog.dat
TPCInnerWallLayerLog.dat
TPCInnerWallLog.dat
TPCOuterWallLayerLog.dat
TPCOuterWallLog.dat
TPCReadoutLog.dat
TPCReadoutPieceLog.dat
tube.dat
EOF

cat ${scriptsdir}/zz_tail.dat >> ${outfile}

