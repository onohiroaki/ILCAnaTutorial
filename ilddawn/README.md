# ilddrawn 

Example to create a cut view of ILD detector geometry using dawn and dawncut.
It consists of several steps which are described below.

## Step1 : Create a dawn file.

Run ddsim and create a dawn file. Example to run ddsim are,

* A sample script to run ddsim and create a dawn file [vis_ddsim.sh](ddsim/vis_ddsim.sh)

* A sample geant4 macro file [dawn3.mac](ddsim/dawn3.mac)

This script create a dawn file, g4_0001.prim, which is used in the subsequent section.

## Step2 : Create a working directory 

```
$ mkdir work
$ cd work
```

## Step3 : Separate prim file to sub-detectors

Following is an example to read a prim file created in Step1 
and devide it by sub-detectors based on the physical volume name (PVName). 


* Copy the prim file created by Step1 to the current directory 
```
$ cp ../g4.prim g4.prim
```

* Devide prim file to each physical volume data
```
$ ../scripts/prim2dat.sh
```
The prim data of each physical volume are written to 
sub-directories of a directory, `prim`. This command could take 
very long. It took about 5 CPU hours at KEKCC login server.

* Create a list of the names of physical volume.
```
$ grep "#/PVName " g4.prim > PVName.list
```

* Create a list of sub-detector names, which is used to merge 
physical volume data.
```
$ python ../scripts/pick_pvname.py > all.list
```

* Merge physical volume data belonging to a same sub-detector
```
$ ../scripts/step2.sh 
``` 
Prim data created in `prim` directory are merged based on the name 
in `all.list`.  

If the way to merge 
prime data is not what you wish,
modify scripts, [pick_pvname.py](scripts/pick_pvname.py) and [step2.sh](scripts/step2.sh). 

## Step4. Pick up a part of sub-detector and create a cut view you wish

### Step 4.1 yoke

Exeample in the case of Yoke is as follows.

```
$ mkdir yoke
$ cd yoke
$ ../../scripts/yoke_edit.sh 
```

dawncut is used inside [yoke_edit.sh](scripts/yoke_edit.sh).  Yoke prim data is cut separately 
and merged and new prim file, `yoke-3div.prim`, is created.
In this [yoke_edit.sh](scripts/yoke_edit.sh) script, yoke prim data in `prim` directory 
are merged by itself in order to change the default color of Yoke_module,
tough merged data are created by [pick_pvname.py](scripts/pick_pvname.py) and 
[step2.sh](scripts/step2.sh) in 
`primadd.dat` directory. 

`yoke-3div.prim` can be used for display by dawn.

To display yoke, 
```
$ cp ../../scripts/dot.DAWN_1.history .DAWN_1.history
$ dawn yoke-3div.prim
```
Last command invokes dawn-GUI using the setting in `.DAWN_1.history`.

When OK button of dawn-GUI is pressed, cut away view of Yoke part is 
displaied.  dawn creates a file, `yoke-3div.eps`. It is displaied by 
[disp90](scripts/disp90) command in [script](script) directory.  [disp90](scripts/disp90) is just to call
ImageMagik's display command with ` -rotate 90` argument. 
The png file can be created by 
```
$ convert -rotate -90 yoke-3div.eps yoke-3div.png
``` 
It can be found in [pictures/yoke-3div.png](pictures/yoke-3div.png)

### Step 4.2 Coil

Example to create a cut view of coil part is as follows
```
$ mkdir coil
$ cd coil
$ ../../scripts/coildata.sh
$ ../../scripts/coilcut.sh coil.prim
$ cp ../../scripts/dot.DAWN_1.history .DAWN_1.history 
$ dawn coil-3div.prim
```

### Step 4.3 Hcal

Example to create a cut view of coil part is as follows.
```
$ mkdir hcal
$ cd hcal
$ ../../scripts/hcaldata.sh
$ ../../scripts/hcalcut.sh hcal.prim
$ cp ../../scripts/dot.DAWN_1.history .DAWN_1.history 
$ dawn hcal-3div.prim
```

### Step 4.4 Ecal

Example to create a cut view of coil part is as follows.
```
$ mkdir ecal
$ cd ecal
$ ../../scripts/ecaldata.sh
$ ../../scripts/ecalcut.sh ecal.prim
$ cp ../../scripts/dot.DAWN_1.history .DAWN_1.history
$ dawn ecal-3div.prim
```

### Step 4.5 Central part

Example to create a cut view of coil part is as follows.
```
$ mkdir center
$ cd center
$ ../../scripts/centerdata.sh
$ ../../scripts/centercut.sh center.prim
$ cp ../../scripts/dot.DAWN_1.history .DAWN_1.history
$ dawn center-3div.prim
```

### Step 4.6 AV volumes of Central part

This part is prepared separately from Step 4.5 to avoid a techinical problem
```
$ mkdir center
$ cd av
$ ../../scripts/avdata.sh
$ ../../scripts/centercut.sh av.prim
$ cp ../../scripts/dot.DAWN_1.history .DAWN_1.history
$ dawn av-3div.prim
```


## Step 5. Add prim data sub-detector region and create a combined view

```
$ mkdir alldet
$ cd alldet
$ ../../scripts/alldet.sh 
$ cp ../../scripts/dot.DAWN_1.history .DAWN_1.history
$ dawn alldet.prim
```
Here, `alldet.prim` is the prim file including all sub-detectors each having 
different cut view.  `dawn` command would take several hours to produce 
the final eps file, `alldet.eps`.  

The produced eps file, `alldet.eps`, could 
contain small defects, probably due to a finite precission to calculate 
surface view. A simmple correction of defects could be modified by 
editting eps file using a graphic editor, like Illustrator. 

ILD geometry created this way is available at [ILD_l5_v02](pictures/ILD_l5_v02-x200.png)



