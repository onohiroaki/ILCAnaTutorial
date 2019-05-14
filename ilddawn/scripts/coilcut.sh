#!/bin/bash


infile=$1
if [ "x$infile" == "x" ] ; then
  echo "Infile is not specidied"
  exit
fi

dawncut  0.0  1.0  0.0 0.0 $infile gr+ycut-$$.prim
dawncut  0.0 -1.0  0.0 0.0 $infile gr-ycut-$$.prim
# dawncut  1.0  0.0  0.0 0.0 gr+ycut-$$.prim gr+xcut-$$.prim
dawncut  1.0  -1.0  0.0 0.0 gr+ycut-$$.prim gr+xcut-$$.prim

# dawncut -1.0  0.0  0.0 0.0 gr+ycut-$$.prim gr-xcut-$$.prim
dawncut -1.0  -1.0  0.0 0.0 gr+ycut-$$.prim gr-xcut-$$.prim
dawncut  0.0  0.0  1.0 -1000.0 gr-xcut-$$.prim gr+zcut-$$.prim
dawncut  0.0  0.0  1.0 0.0 gr+ycut-$$.prim gr+yzcut-$$.prim

outfile=`basename $infile .prim`-3div.prim

cat gr-ycut-$$.prim | egrep -v -e "(EndModeling|DrawAll|CloseDevice)" > $outfile
cat gr+xcut-$$.prim | egrep -v -e "(BoundingBox|SetCamera|OpenDevice|BeginModeling)" | egrep -v -e "(EndModeling|DrawAll|CloseDevice)" >> $outfile
cat gr+zcut-$$.prim | egrep -v -e "(BoundingBox|SetCamera|OpenDevice|BeginModeling)" >> $outfile

rm *-$$.prim
    
