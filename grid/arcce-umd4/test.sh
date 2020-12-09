#!/bin/sh

echo "Hello World!"
echo "I am `hostname`"
df
pwd
echo "*******************************"
echo "** ls -la /home/scratch "
ls -la /home/scratch
echo "*******************************"
echo "** ls -la ${HOME} "
ls -la ${HOME}
echo "*******************************"
echo "** env  "
env 2>&1 | tee output.txt
echo "*******************************"
echo "** ls -la ${HOME} "
ls -la 



