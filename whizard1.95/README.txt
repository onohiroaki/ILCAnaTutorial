How to run whizard1 jobs

1. Build whizard for your process

  1.1) edit whizard.prc and define processes for your binary

  1.2) build whizard by 

    $ ./tools/bldwhiz.sh 2>&1 | tee bldwhiz.log

2. Run whizard

  2.1) Create a sample directory to run whizard. 

   $ ./tools/make_rundir.sh 
    
   A directory, jobs/E250-TDR_ws.Pe2e2h.Gwhizard-1_95.eL.pR.I990001,
   which include input files to generate e2e2h events at 250 GeV. 
   To submit job for event generation, 
  
   $ cd jobs/E250-TDR_ws.Pe2e2h.Gwhizard-1_95.eL.pR.I990001
   $ . subjob.sh 

   The job result is written in run_whizard.log.  Make sure that job
   finished with a message "Succesfully completed."
   Event file with stdhep format is 
     E250-TDR_ws.Pe2e2h.Gwhizard-1_95.eL.pR.I990001.001.stdhep 

  [Note]

  The whizard job parameter written in "whizard.in" is prepared
  just for an example not for physics study.


3. References

  - Whizard home page : http://whizard.hepforge.org/
  - Whizard-1.95 manual : /sw/ilc/gcc481/whizard/docs/Whizard-manual.pdf

  - stdhep manual : /sw/ilc/gcc481/stdhep/docs/stdhep_50601_manual.pdf

  - pythia6 home page : https://pythia6.hepforge.org/
  - pythia6 manual : https://pythia6.hepforge.org/

  - Lumi-linker files and SM samples produced at SLAC:
    https://confluence.slac.stanford.edu/display/ilc/Standard+Model+Data+Samples

  - Centrally produced generator samples for ILC DBD study and later: 
    http://ilcsoft.desy.de/dbd/generated/
  - Generator meta information collected on ELOG server:
    https://ild.ngt.ndu.ac.jp/elog/genmeta/

  

