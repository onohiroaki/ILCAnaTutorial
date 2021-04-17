
# Convert a stdhep file to lcio format.

mkdir -p ${HOME}/Tutorial/data

(
cd ${HOME}/Tutorial/data
file_prefix=E250-TDR_ws.Pe2e2h.Gwhizard-1_95.eL.pR.I106479.001
datadir=/group/ilc/grid/storm/prod/ilc/mc-dbd/generated/250-TDR_ws/higgs

if [ ! -e ${datadir} ] ; then 
  datadir="."
  wget http://osggridftp02.slac.stanford.edu:8080/sdf/group/lcddata/ilc/prod/ilc/mc-dbd/generated/250-TDR_ws/higgs/${file_prefix}.stdhep

else
  ln -sf ${datadir}/${file_prefix}.stdhep . 
fi


)
