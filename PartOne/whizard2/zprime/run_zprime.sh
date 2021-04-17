#!/bin/bash 
#
# A sample script to create Zprime events.
#
# To run as a KEKCC batch job, ?vis_diags should be false and compile_analysis 
# should be commented out because latex command is not available  
# 
circe_dir=$WHIZARD_DIR/share/circe2/data

rm -rf run
mkdir -p run
cd run

cat > run.sin <<EOF
!
! Sindarin script for e+ e- --> mu+ mu- with Zprime model 
!
  ?vis_diags = true  # Create diagrams of this process
!
  \$circe2_file="${circe_dir}/250_SetA_ee024.circe"  
  beams_pol_density = @(-1),@(1)  
  ?isr_handler = true 
!
  sample_format = lcio
  \$sample = "E250-SetA.P2f_zp180_mumu.Gwhizard-2_8_5.eL.pR"   
! 
  include("../zprime.sin")  # Include the default zprime setting
!
! --------------------------------------------------------
! TO overwrite parameters defined in zprime.sin
!
  mZH = 180.0   # Zprime  mass
  wZH = 0.5     # Zprime width
  a_lep = 0.25   # Multiply the Z lepton A coupling
  v_lep  = 0.25  # Multiply the Z lepton V coupling
!
! Integration accuracy 
  iterations = 1:100000, 10:100000, 1:500000
  relative_error_goal = 0.01

  n_events = 10000
!
! --------------------------------------------------------
! Create libraries and do integration
compile
integrate ( zprime_e2e2 ){ ?polarized_events = true } 
show(results)
!
! --------------------------------------------------------
! Analysis description
!
! Allocate plots
  \$title = "Invaiant mass of \${\mu^+\mu^-}$"
  \$x_label = "\$M_{\mu^+\mu^-}\$/GeV"
  histogram mumu_mass (0 GeV, 260 GeV, 2 GeV)

  \$title = "Number of photons per event"
  \$x_label = "Number of photons"
  histogram nb_photons ( 0, 10, 1 )

  \$title = "Photon energy "
  \$x_label = "\$E_{\gamma}\$/GeV"
  ?y_log = true
  y_min = 1
  histogram e_photon (0 GeV, 150 GeV, 2 GeV)

  analysis = record mumu_mass ( eval M[e2,E2] ); 
             record nb_photons ( count [photon] );
             record e_photon ( eval E[photon] )
!
! ------------------------------------------------------
! Simulate event
!
  simulate ( zprime_e2e2 ){ ?polarized_events = true } 
!
! Output analysis results
  compile_analysis

! End of run.sin
EOF

# time is optional to record cpu run required for this calculation
#
time whizard run.sin 2>&1 | tee run.log



