# This file was copied from /cvmfs/grid.cern.ch/etc/profile.d/setup-cvmfs-ui.sh
# and editted according to 
# http://kekcc.kek.jp/service/kekcc/html/EMIE382B7E382B9E38386E383A0.html#n86e5791
# 
# 7-Sep-2016 Akiya Miyamoto
#


#Base script written by David Smith, updated by Matt Doidge
#sets up PATHS for the tarball, source from /etc/profile.d/
#based on wn v8 setup script
#modified for cvmfs tarball
#v6, 25/02/2016 
#now with gfal2 variables
#and glite cream client config
#generic version for cvmfs, needs cleanup
  

base=/cvmfs/grid.cern.ch/emi3ui-latest

#EMI_TARBALL_BASE flag to let jobs know that this is a tarball node
#also used to locate etc/emi-version file by SAM nagios probes

export EMI_TARBALL_BASE=$base

export EMI_UI_CONF=$base

#to get all aspects of the cream client tools to work
export GLITE_CREAM_CLIENT_CONFIG=${base}/etc/emitar-cream-client.conf

#
#export X509_CERT_DIR=${base}/etc/grid-security/certificates
#export X509_VOMS_DIR=${base}/etc/grid-security/vomsdir

#use base cvmfs version of the X509 dirs for now.
export X509_CERT_DIR=/etc/grid-security/certificates
export X509_VOMS_DIR=/etc/grid-security/vomsdir

#export VOMS_USERCONF=${base}/etc/vomses

#use cvmfs vomses dir
export VOMS_USERCONF=/etc/grid-security/vomses


#gfal2 specific variables
export GFAL_CONFIG_DIR=$EMI_TARBALL_BASE/etc/gfal2.d/
export GFAL_PLUGIN_DIR=$EMI_TARBALL_BASE/usr/lib64/gfal2-plugins/

export GLOBUS_LOCATION=${base}/usr

# site specific (with default)
# set these too someting more appropriate to your site/region
export MYPROXY_SERVER=kek2-px.cc.cern.ch
export LCG_GFAL_INFOSYS=kek2-bdii01.cc.kek.jp:2170,kek2-bdii02.cc.kek.jp:2170,bdii.grid.sinica.edu.tw:2170
### export BDII_LIST=lcg-bdii.cern.ch:2170

# not site specific; usually no change needed
#
export -n GRID_ENV_LOCATION=
export -n GLITE_ENV_SET=
export GT_PROXY_MODE=old

#note that if the "base" LD_LIBRARY_PATH isn't set elsewhere you need to
#set it here, so that it also points to the local /lib, /lib64, /usr/lib,
#/usr/lib64 directories
v="$LD_LIBRARY_PATH"
export LD_LIBRARY_PATH=${base}/lib64:${base}/lib:${base}/usr/lib64:${base}/usr/lib:/usr/lib64:/usr/lib
#if your site uses gsi dcap you will need to add to the LD_LIBRARY_PATH :${base}/usr/lib64/dcap
if [ -n "$v" ]; then
  export LD_LIBRARY_PATH="${LD_LIBRARY_PATH}:$v"
fi
#similar to LD_LIBRARY_PATH, if the PATH is not set elsewhere the "base elements" (/bin, /sbin etc)
#will need to be set here
export PATH=${base}/bin:${base}/sbin:${base}/usr/bin:${base}/usr/sbin:$PATH

v="$MANPATH"
export MANPATH=${base}/usr/share/man
if [ -n "$v" ]; then
  export MANPATH="${MANPATH}:$v"
fi

v="$PERL5LIB"
export PERL5LIB=${base}/usr/lib64/perl5/vendor_perl:${base}/usr/lib/perl5/vendor_perl:${base}/usr/share/perl5
if [ -n "$v" ]; then
  export PERL5LIB="${PERL5LIB}:$v"
fi
v="$PYTHONPATH"
export PYTHONPATH=${base}/usr/lib64/python2.6/site-packages:${base}/usr/lib/python2.6/site-packages

#SL6 users have it easier as there is only one version of python to worry about

if [ -n "$v" ]; then
  export PYTHONPATH="${PYTHONPATH}:$v"
fi

#if java is installed on the node it's advisable to use that version instead
#it's also worth checking to see if the version of java has changed within the
#tarball, although this should be correct - as of EMI3 the "tarball" java is in the
#os-extras tarball
export JAVA_HOME=${base}/usr/lib/jvm/jre-1.6.0-openjdk.x86_64
export LCG_LOCATION=${base}/usr
export GLITE_LOCATION=${base}/usr
export GLITE_LOCATION_VAR=/var
export SRM_PATH=${base}/usr/share/srm
unset v base


export VO_ILC_DEFAULT_SE=kek2-se01.cc.kek.jp

