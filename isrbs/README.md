# pyBSISR 

Example to generate IS spectrum using Whizard-1.95 functions 
and Beamstruclung spectrum using CIRCES2 are included.

## Install and build

- install circe2

Download circe2 source, build circe2 library, and download circe2 parameter file 
for ILC 250-TDR_ws. 
 
```
build_circe2.sh
```

- install and build of this package.

```
mkdir build
cd build
cmake ..
make 
make install
```

## How to run

demo scripts are prepared in demo directory. 
To run, just do 

```
python isrplot.py 
```

A root file of generated ISR spectrum is created.

## circe2 commands and files.

- List brief summary of circe2 file
```
./bin/circe2_ls <cire2_file>
```
for example,
```
./bin/circe2_ls ./share/ilc/250-TDR_ws-ee.circe2
```

- Generate electron/photon energy after beam strahlung
```
./bin/circe2_generate <circe2_file> <design> <roots> <#events> <seed>
```
for example,
```
./bin/circe2_generate ./share/ilc/250-TDR_ws-ee.circe2 ILC 250 100 312134
```
Electron/positron energy after beam strahlung normalized by nominal beam energy 
is generated and results are printed on the screen.  

- Run circe2 example program to print out BS spectrum  
```
ln -s share/ilc/250-TDR_ws-ee.circe2 .
export LD_LIBRARY_PATH=lib:${LD_LIBRARY_PATH}
./bin/circe2_print_spectrum_f77.exe
``` 
This will print out 20 events of electron and positron energy normalized by norminal beam energy. 
`circe2_print_spectrum_f77.exe` is a version written in fortran77.
`circe2_print_spectrum_f90.exe` is a similar program but written in fortran90.

## Reference

- Library for a generation of ISR spectrum was taken from Whizard1.95 library 
used in ILC DBD study.
