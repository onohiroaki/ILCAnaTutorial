
if [ ! -e ~/.glite/glite_cream.conf ] ; then 
    echo "### ~/.glite/glite_cream.conf does not exist. It is created now."
    mkdir -vp ~/.glite
    echo "[" > ~/.glite/glite_cream.conf
    echo " UBERFTP_CLIENT=\"/cvmfs/grid.cern.ch/emi3ui-latest/usr/bin/uberftp\"" >> ~/.glite/glite_cream.conf
    echo "]" >> ~/.glite/glite_cream.conf
    echo "~/.glite/glite_cream.conf was created. "
    echo ""
fi

source ./setup-cvmfs-ui.sh 
voms-proxy-init --voms ilc -valid 144:00 -vomslife 144:00

