#!/bin/bash 
# 
# Creat link or downloas files for tutorial

slachttp="http://osggridftp02.slac.stanford.edu:8080/sdf/group/lcddata/ilc"
kekdisk="/group/ilc/grid/storm"
kyusyudir="/home/miyamotoi/data"
basedir="prod/ilc/mc-dbd/generated/250-TDR_ws"

curdir=`pwd`
mkdir -p ${HOME}/Tutorial/data

cd ${HOME}/Tutorial/data 
while read infile ; do 
  datafile=${kekdisk}/${basedir}/${infile}
  if [ -e ${kyusyudir}/${infile} ] ; then 
    ln -sfv ${kyusyudir}/${infile} . 
  elif [ -e ${datafile} ] ; then 
    ln -sfv ${datafile} .
  else
    wget ${slachttp}/${basedir}/${infile}
  fi
done <<EOF
higgs/E250-TDR_ws.Pe2e2h.Gwhizard-1_95.eR.pL.I106480.001.stdhep
4f/E250-TDR_ws.P4f_zz_sl.Gwhizard-1_95.eL.pR.I106575.001.stdhep
4f/E250-TDR_ws.P4f_zz_sl.Gwhizard-1_95.eR.pL.I106576.001.stdhep
EOF
# higgs/E250-TDR_ws.Pe2e2h.Gwhizard-1_95.eL.pR.I106479.001.stdhep

# Convert stdhep files to LCIO format
for f in *.stdhep; do 
  if [ -e ${f/stdhep/slcio} ] ; then 
     rm -fv ${f/stdhep/slcio}
  fi
  stdhepjob ${f} ${f/stdhep/slcio} -1 
done

# Get generator meta file.
wget https://ild.ngt.ndu.ac.jp/CDS/files/genmetaByID.json

cd ${curdir}

