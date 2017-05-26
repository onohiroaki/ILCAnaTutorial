#!/bin/bash 

# Create a directory to run sample whizard job

mkdir -p jobs

rundir_nnh=E250-TDR_ws.Pnnh.Gwhizard-1_95.eL.pR.I990001
cp -a build/whizard-1.95/results jobs/${rundir_nnh}
/bin/cp tools/sample-nnh/* jobs/${rundir_nnh}

rundir_nnqq=E250-TDR_ws.Pnnqq.Gwhizard-1_95.eL.pR.I990002
cp -a build/whizard-1.95/results jobs/${rundir_nnqq}
/bin/cp tools/sample-nnqq/* jobs/${rundir_nnqq}

echo "A sample directory to generate 250 GeV nnh and nnqq events were created"
echo "in jobs/${rundir_nnh} and jobs/${rundir_nnqq}.  " 
echo "To run jobs, do \". subjob.sh\" in each directory"
echo "  . subjob.sh "
echo "A batch job is submitted.  \"bjobs\" is a command to see job status."
echo "The job log will be found in run_whizard.log."

