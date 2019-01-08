

================================================
LC1a
================================================

No sensitive detector.
Only geometry for three layers of cylindrical sensitive detector.

Changes from original B2b
- Comment out "virtual void ConstructSDandField in include/B2DetectorConstruction.hh
- B2EventAction.cc : Do nothing in the end of event action.
- B2PrimaryGeneratorAction.cc : Generate particle from (0,0,0)


==================================================
LC1b
==================================================
Add solenoid field and sensitive detector.

/vis/geometry/set/visibility world 1 true  # Turn on visibility of world volume


/vis/viewer/set/viewpointThetaPhi 0.0 0.0  # Fron view

/vis/viewer/setChamberMaterial  

3 layers of sensitive layer detector

================================================
LC1c
================================================
Accumulate SD hits in ROOT ntuple

gROOT->SetBatch(true) in main to avoid conflict of 
openGL and root graphic.

ROOT output file name can be modified by using DetectorMessenger.

================================================
LC1d
================================================
Generate mu+mu- events at 250 GeV (QED only)

