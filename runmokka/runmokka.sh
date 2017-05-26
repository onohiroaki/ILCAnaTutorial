#!/bin/bash
#
# Example to run Mokka, using mysql dump file.
# 

softdir=/sw/ilc/ilcsoft
ilcsoftdir=${softdir}/cvmfs/x86_64_gcc44_sl6/v01-16-02
ildconfigdir=${softdir}/cvmfs/ILDConfig/v01-14-01-p00

. ${ilcsoftdir}/init_ilcsoft.sh

gcc --version
ls ${ildconfigdir}

MokkaDBConfig=${ildconfigdir}/MokkaDBConfig
export MOKKA_DUMP_FILE=${MokkaDBConfig}/mokka-dbdump.sql.tgz
export MOKKA_TMP_DIR=/tmp/mokka-$(date +%F--%H-%M-%S)-$$
mkdir -p ${MOKKA_TMP_DIR}
export MSG_LOG_FILE=`pwd`/last-mokka-run-$(date +%F--%H-%M-%S)-$$.log

StandardConfig=${ildconfigdir}/StandardConfig/current
ln -sf ${StandardConfig}/particle.tbl .


datadir="../whizard1.95/jobs/E250-TDR_ws.Pe2e2h.Gwhizard-1_95.eL.pR.I990001"
ln -sf ${datadir}/E250-TDR_ws.Pe2e2h.Gwhizard-1_95.eL.pR.I990001.001.stdhep .

# Start Mokka here

${MokkaDBConfig}/scripts/mokka-wrapper.sh  -M ILD_o1_v05 mokka.steer

