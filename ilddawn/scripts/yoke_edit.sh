#!/bin/bash 

# Change collor of layers so as to be visible by dawn display

cat  ../prim/YokeBarrel_layer*/*.dat  | sed -e "s/  */ /g" | \
   sed -e "s/ColorRGB 1 1 0/ColorRGB 0 0 1.0/g" >   YokeBarrel_layer.dat
cat  ../prim/YokeEndcap_layer*/*.dat  | sed -e "s/  */ /g" | \
   sed -e "s/ColorRGB 1 1 0/ColorRGB 0 0 1.0/g" >   YokeEndcap_layer.dat

cat  ../prim/YokeBarrel_module*/*.dat | sed -e "s/  */ /g" > YokeBarrel_module.dat
cat  ../prim/YokeEndcap_module*/*.dat | sed -e "s/  */ /g" > YokeEndcap_module.dat
cat  ../prim/YokeEndcap_plug*/*.dat | sed -e "s/  */ /g" > YokeEndcap_plug.dat

# cat 00header.dat YokeBarrel_module.dat YokeBarrel_layer.dat zz_tail.dat > YokeBarrel.prim
cat ../../scripts/00header.dat YokeBarrel_module.dat YokeEndcap_module.dat \
     YokeEndcap_plug.dat YokeEndcap_layer.dat YokeBarrel_layer.dat \
     ../../scripts/zz_tail.dat > yoke.prim

source ../../scripts/cututil.sh 

docut yoke.prim -2000.0

echo "yoke-3div.prim was created."
