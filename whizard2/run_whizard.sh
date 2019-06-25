#!/bin/bash
# A script run Whizard jobs
# 

source ~/work/whizard2/whizard2.7-gcc73.setup

which whizard
which gfortran

which latex
which gfortran
which gcc

jobtop=/home/ilc/miyamoto/work/whizard2/jobs-2.7.0/250-SetA
sindir=${jobtop}/sindarin
aliases="${sindir}/aliases.sin"
pythia6_parameters="${sindir}/pythia6-parameters.sin"
beam_events_file="/sw/ilc/gcc481/GP/beamdata/lumiee250/lumiee250-run1.dat"
beam_events_file="/sw/ilc/gcc481/GP/beamdata/lumiee250-hs/lumiee250-run1to20.dat"
# n_events=100000
n_events=2000
which whizard

# ####################################
# Whizard run of one process
# ####################################
run_whizard() 
{
  proc=$1
  sample_name=${2}
  process_id=$3
  job_id=23451
  ( 
    # cd ${jobdir}
    sed -e "s|%%ALIASES%%|${aliases}|g" \
	-e "s|%%PYTHIA6_PARAMETERS%%|${pythia6_parameters}|g" \
        -e "s|%%BEAM_EVENTS_FILE%%|${beam_events_file}|g" \
        -e "s|%%SAMPLE_NAME%%|${sample_name}|g" \
        -e "s|%%PROCESS_ID%%|${process_id}|g" \
        -e "s|%%JOB_ID%%|${job_id}|g" \
        -e "s|%%SAMPLE_NAME%%|${sample_name}|g" \
        -e "s|%%N_EVENTS%%|${n_events}|g" \
        ${sindir}/${proc}.sin > ${proc}.sin
      /usr/bin/time whizard -r ${proc}.sin > run_whizard.log 2>&1  
  )
}

# #######################################
# Run onejob according to the parameters 
# #######################################
#

run_whizard $1 $2 $3


