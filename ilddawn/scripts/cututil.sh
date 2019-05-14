#!/bin/bash

# best view for 2Div is 45 and 290

docut()
{

zshift=$2
infile=$1
if [ "x$infile" == "x" ] ; then
  echo "Infile is not specidied"
  exit
fi

dawncut  0.0  1.0  0.0 0.0 $infile gr+ycut-$$.prim
dawncut  0.0 -1.0  0.0 0.0 $infile gr-ycut-$$.prim
# dawncut  1.0  0.0  0.0 0.0 gr+ycut-$$.prim gr+xcut-$$.prim
dawncut  1.0  -1.0  0.0 0.0 gr+ycut-$$.prim gr+xcut-$$.prim
# dawncut  0.695  -0.719  0.0 0.0 gr+ycut-$$.prim gr+xcut-$$.prim

# dawncut -1.0  0.0  0.0 0.0 gr+ycut-$$.prim gr-xcut-$$.prim
dawncut -1.0  -1.0  0.0 0.0 gr+ycut-$$.prim gr-xcut-$$.prim
dawncut  0.0  0.0  1.0 ${zshift} gr-xcut-$$.prim gr+zcut-$$.prim
# dawncut  0.0  0.0  1.0 0.0 gr+ycut-$$.prim gr+yzcut-$$.prim
dawncut  0.0  0.0  1.0 -4100.0 gr+ycut-$$.prim gr+yzcut-$$.prim

outfile=`basename $infile .prim`-3div.prim

cat gr-ycut-$$.prim | egrep -v -e "(EndModeling|DrawAll|CloseDevice)" > $outfile
cat gr+xcut-$$.prim | egrep -v -e "(BoundingBox|SetCamera|OpenDevice|BeginModeling)" | egrep -v -e "(EndModeling|DrawAll|CloseDevice)" >> $outfile
cat gr+zcut-$$.prim | egrep -v -e "(BoundingBox|SetCamera|OpenDevice|BeginModeling)" | egrep -v -e "(EndModeling|DrawAll|CloseDevice)" >> $outfile
cat gr+yzcut-$$.prim | egrep -v -e "(BoundingBox|SetCamera|OpenDevice|BeginModeling)" >> $outfile

rm *-$$.prim

}

merge()
{
  file1=$1
  file2=$2
  fileout=$3

  if [ ! -e $file1 ] ; then 
    echo "$file1 not exist"
    exit 
  fi
  if [ ! -e $file2 ] ; then  ( echo "$file2 not exist" ; exit ) ; fi
  cat $file1 | egrep -v -e "(EndModeling|DrawAll|CloseDevice)" > $fileout
  cat $file2 | egrep -v -e "(BoundingBox|SetCamera|OpenDevice|BeginModeling)" >> $fileout

}

