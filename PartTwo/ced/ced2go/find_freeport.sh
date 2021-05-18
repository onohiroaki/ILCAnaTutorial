#!/bin/bash   
#  
# Source this file so as to find a free port for CED and define CED_PORT
#

# Find port not in use
if [ -z ${CED_PORT} ] ; then
   CED_PORT=-1
   for loop in `seq 1 10` ; do
      ced_port=${RANDOM}
      [ ${ced_port} -lt 1000 ] && continue
      port_list=`netstat -nl | grep "tcp " | cut -c21-35 | cut -d":" -f2 | sort -n | uniq | cut -d" " -f1 `
      match=`echo ${port_list} | tr " " "\n" | grep -w "${ced_port}"`
      [ ! -z ${match} ] && continue
      export CED_PORT=${ced_port}
      echo "Found free port for CED, ${CED_PORT}"
      break
   done   
   
   if [ ${CED_PORT} -lt 0 ] ; then 
      echo "Free port for ced2go is not available after 10 tries."
      exit
   fi
else
   echo "CED_PORT is defined already. It is ${CED_PORT}."
   exit
fi
   
