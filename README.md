# Tutorial
Collection of examples for ILCSoft tutorial in June 2018

##  Get started.

Follpowing command downloads Tutorial package in your working directory, 
``` 
   git clone https://github.com/akiyamiyamoto/Tutorial.git
```

The tutorial in this package assumes iLCSoft-v02-00-01 running on Scientific Linux 6
unless stated otherwise. iLCSoft-v02-00-01 is the version used for the ILD detector 
optimization. 

iLCSoft is maintained at [https://github.com/iLCSoft](https://github.com/iLCSoft).
Please read iLCSoft documentation in 
[https://github.com/iLCSoft/ilcsoftDoc/](https://github.com/iLCSoft/ilcsoftDoc/blob/master/README.md)
and links therein.  Many usefull information will be found there.

The released version of iLCSoft, both source and binaries, is available under `/cvmfs/ilc.desy.de/sw`. 
The most of the system used for studies using ilcsoft must have `cvmfs` installed. If not,
the information at 
[ILCSoft on CVMFS - CERN TWiki](https://twiki.cern.ch/twiki/bin/view/CLIC/CLICCvmfs) and 
[CVMFS at DESY - Grid@DESY](http://grid.desy.de/cvmfs/)
are usefull for the installation.

iLCSoft environment for v02-00-01 is initialized by 

```
. /cvmfs/ilc.desy.de/sw/x86_64_gcc49_sl6/v02-00-01/init_ilcsoft.sh
```

## Example folders

### CED

Example to run CED event display

following sub-folders are under-development.

### whizard-1.95 

Example of event generation by whizard-1.95.

### DSTAnal

Example to analize DST files, including a C++ source code.

### runmokka

Simulate 250GeV e2e2H event by Mokka

### runmarlin

Analize simulated file created by `runmokka` example.

### python

An example to analize e2E2h using python 
 
