#!/bin/bash 

source ${HOME}/Tutorial/PartOne/whizard2/whizard2.setup

rm -rf run
mkdir -p run
(
  cd run

  # Prepare sindarin for this run.  First fill on-the-fly parameters

  cat >whizard.sin <<EOF
#
# Higgs decay mode
  logical ?is_higgs_exclusive = false # Exclusive higgs decay or not.

# On/Off switch of Higss decay mode. Valid when is_higgs_exclusive = True
  int ih_dd = 1
  int ih_uu = 1
  int ih_ss = 1
  int ih_cc = 1
  int ih_bb = 1
  int ih_tt = 0
  int ih_gg = 1
  int ih_aa = 1
  int ih_az = 1
  int ih_zz = 1
  int ih_ww = 1
  int ih_e1e1 = 1
  int ih_e2e2 = 1
  int ih_e3e3 = 1

# Circes file and beam polarization
  \$circe2_file = "${WHIZARD_DIR}/share/circe2/data/250_SetA_ee024.circe"
# Beam poralization
# beams_pol_density = @(+1), @(-1) # eR.pL
  beams_pol_density = @(-1), @(+1) # eL.pR
  beams_pol_fraction = 1.0,1.0
#
  n_events = 10000  # Number of events to generate
  \$sample = "E250-SetA.Phiggs_n23n23h.Gwhizard-2_8_5.eL.pR"
#
#
# At KEK batch, diagrams and histograms can not be printed-out because latex
# command is not installed in batch system. To print, do
#    make -f zprime_mass_ana.makefile
# after batch job ended sucessfully/
#
  ?vis_diags = true # true to create diagrams. should be false to run in batch
#
  ?vis_history = true # display integration history
#
  logical ?do_hist = true # true to create histogram
#
  logical ?is_test = true # true for test mode with low precission
  if ?is_test then
    n_events = 1000
  endif
#
EOF
cat ../higgs.sin >> whizard.sin

whizard whizard.sin 2>&1 | tee run.log

)


