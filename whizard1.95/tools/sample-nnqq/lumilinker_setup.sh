#
# setup for whizard integration and event generation
# 

lumi_linker_dir=/sw/ilc/gcc481/whizard/energy_spread

# Lumi linker number is defined as follows
# Lumi_linker_number  ECM  General_Description  Machine_Configuration
# 18 1000 ILC_1000_Waisty_opt_Jan_2012 B1b_ws
# 21 500 ilc_500_waisty_250_jan_2012 TDR_ws
# 22 250 ilc_250_waisty_250_jan_2012 TDR_ws
# 23 350 ilc_350_waisty_250_jan_2012 TDR_ws

lumi_linker_number=22   # for 250 GeV generation

case ${lumi_linker_number} in
  19|20)
    export LUMI_EE_LINKER=${lumi_linker_dir}/lumi_ee_linker_000
    export LUMI_EG_LINKER=${lumi_linker_dir}/lumi_eg_linker_000
    export LUMI_GE_LINKER=${lumi_linker_dir}/lumi_ge_linker_000
    export LUMI_GG_LINKER=${lumi_linker_dir}/lumi_gg_linker_000
  ;;
  *)
    export LUMI_LINKER=${lumi_linker_dir}/lumi_linker_000
    export PHOTONS_B1=${lumi_linker_dir}/photons_beam1_linker_000
    export PHOTONS_B2=${lumi_linker_dir}/photons_beam2_linker_000
    export EBEAM=${lumi_linker_dir}/ebeam_in_linker_000
    export PBEAM=${lumi_linker_dir}/pbeam_in_linker_000
  ;;
esac

