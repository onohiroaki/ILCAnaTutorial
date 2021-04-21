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
# Beam poralization
# beams_pol_density = @(+1), @(-1) # eR.pL
  beams_pol_density = @(-1), @(+1) # eL.pR
  beams_pol_fraction = 1.0,1.0
# 
  n_events = 10000  # Number of events to generate
  \$sample = "E250-SetA.P2f_zp180_mumu.Gwhizard-2_8_5.eL.pR"
#
# Zprime mass and couplings, to define after reading model file.
  real my_mZH = 180.0  # Zprime mass
  real my_lepton_coupling = 0.25  # Multiply the Z lepton A & V coupling
# 
#
# At KEK batch, diagrams and histograms can not be printed-out because latex 
# command is not installed in batch system. To print, do 
#    make -f zprime_mass_ana.makefile
# after batch job ended sucessfully/
#
  ?vis_diags = false # true to create diagrams. should be false to run in batch
#
  logical ?do_hist = true # true to create histogram
# 
  logical ?is_test = false # true for test mode with low precission
  if ?is_test then
    n_events = 1000
  endif
#
EOF
cat ../zprime.sin >> whizard.sin

whizard whizard.sin 2>&1 | tee run.log

)



