No sensitive detector.
Only geometry for three layers of cylindrical sensitive detector.

Changes from original B2b
- Comment out "virtual void ConstructSDandField in include/B2DetectorConstruction.hh
- B2EventAction.cc : Do nothing in the end of event action.
- B2PrimaryGeneratorAction.cc : Generate particle from (0,0,0)

