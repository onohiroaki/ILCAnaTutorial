#!/bin/bash

outfile="alldet.prim"
scriptdir="../../scripts"

cat ${scriptdir}/00header.dat > ${outfile}

for subd in yoke coil hcal ecal center av ; do 

   if [ -e ../${subd}/${subd}-3div.prim ] ; then 
     echo "Adding ${subd}-3div.prim"
     cat ../${subd}/${subd}-3div.prim | \
        egrep -v -e "(BoundingBox|SetCamera|OpenDevice|BeginModeling)" | \
        egrep -v -e "(EndModeling|DrawAll|CloseDevice)" \
        >> ${outfile}
   else
     echo "../${subd}/${subd}-3div.prim does not exist and skipped."
   fi

done

cat ${scriptdir}/zz_tail.dat >> ${outfile}

