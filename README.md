# Tutorial
Collection of examples for ILCSoft tutorial in June 2018.
Presentation materials of the turorial will be found at [here](https://kds.kek.jp/indico/event/27935/contribution/0/material/slides/0.pptx).

##  Get started.

Follpowing command downloads Tutorial package in your working directory, 
``` 
   git clone https://github.com/akiyamiyamoto/Tutorial.git Tutorial
```

The tutorial in this package assumes iLCSoft-v02-00-01 running on Scientific Linux 6
unless stated otherwise. iLCSoft-v02-00-01 is the version used for the ILD detector 
optimization. 

iLCSoft is maintained at [https://github.com/iLCSoft](https://github.com/iLCSoft).
Please read iLCSoft documentation in 
[https://github.com/iLCSoft/ilcsoftDoc/](https://github.com/iLCSoft/ilcsoftDoc/blob/master/README.md)
and links therein.  Many usefull information will be found there.

The released version of iLCSoft, both source and binaries, is available under `/cvmfs/ilc.desy.de/sw`. 
The most of the system used for studies using ilcsoft must have `cvmfs` installed. Here is
a [simple installation document](docs/setup-cvmfs.md). More detail information will be found 
at
[ILCSoft on CVMFS - CERN TWiki](https://twiki.cern.ch/twiki/bin/view/CLIC/CLICCvmfs) and 
[CVMFS at DESY - Grid@DESY](http://grid.desy.de/cvmfs/).

iLCSoft environment for v02-00-01 is initialized by 

```
. /cvmfs/ilc.desy.de/sw/x86_64_gcc49_sl6/v02-00-02/init_ilcsoft.sh
```

or equivalently by 
```
. lesson1/init_001
```

## Example folders

### [lesson1](lesson1)

scripts to initialize environment and run anajob and dumpevent

### [ced2go](ced2go)

Example to run CED event display

### [python](python)

Example of pythons for LCIO data and ROOT file analysis

### [runddsim](runddsim)

Run ddsim 

### [runmarlin](runmalin)

Run ILD standard marlin reconstruction with background overlay 

### [DSTAnal](DSTAnal)

Example to analize DST files, including a C++ source code.

### [grid](grid)

How to get grid account and ILCDirac examples.

### [docs](docs)

Help information to setup cvmfs and git.

### [geant4](geant4)

Introduction of geant4 simulation 

### [ilddawn](ilddawn)
 
Generate an ILD detector picture by a program DAWN

### [whizard2](whizard2)

whizard2 job example

### [bases](bases)

Event generation by bases

### [isrbs](isrbs)

Example for a generation of ISR spectrum used for DBD samples and beamstrahlung spectrum using Circe2


### Obsolete directory

#### runmokka

Simulate 250GeV e2e2H event by Mokka


