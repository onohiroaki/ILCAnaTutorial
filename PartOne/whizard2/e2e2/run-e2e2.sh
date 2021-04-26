#!/bin/bash 

source ${HOME}/Tutorial/PartOne/whizard2/whizard2.setup



rm -rf run
mkdir -p run
(
  cd run

  # Prepare sindarin for this run.  First fill on-the-fly parameters
 
  cat >whizard.sin <<EOF
#
\$circe2_file = "${WHIZARD_DIR}/share/circe2/data/250_SetA_ee024.circe"
n_events = 1000  # Number of events to generate
#
# At KEK batch, diagrams and histograms can not be printed-out because latex 
# command is not installed in batch system. To print, do 
#    make -f mumu_mass_ana.makefile
# after batch job ended sucessfully/
#
?vis_diags = true # true to create diagrams
#
logical ?do_hist = true # true to create histogram
# 
logical ?is_test = false # true for test mode with low precission
#
EOF
cat ../e2e2.sin >> whizard.sin

whizard whizard.sin 2>&1 | tee run.log

)



