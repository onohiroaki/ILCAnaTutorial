#!/bin/bash

echo "This is mypre.sh.  Input arguments are"
echo "$*"

echo "### Time is `date` "
echo "### Host is `hostname` "
hostname -a
hostname -I
echo "### uname is `uname -a` "
echo "### Bash version is "
bash --version
[ -e /etc/redhat-release ] &&  {
  echo "### Redhat release `cat /etc/redhat-release` "
}
echo "### CPU information "
cat /proc/cpuinfo
echo "### Memory information "
cat /proc/meminfo
[ -e /bin/df ] && {
 echo "### Mounted file system"
 df
}


echo "### Check /cvmfs/ilc.desy.de directory "
/bin/ls -l /cvmfs/ilc.desy.de

echo "### Check /cvmfs/clicdp.cern.ch directory "
/bin/ls -l /cvmfs/clicdp.cern.ch

echo "### Check complated."


echo "### pwd is `pwd` "
echo "### /bin/ls -l of current directory "
/bin/ls -l

echo "### mypre.sh completed."
