#ifndef GEANT4_MY_ANALYSIS_H
#define GEANT4_MY_ANALYSIS_H

#include "TFile.h"
#include "TNtuple.h"
#include <iostream>
#include "G4String.hh"

class MyAnalysis {
  public:
    TFile *fFile;
    TNtuple *fNt;

    static MyAnalysis *fMySelf;
    static G4String fRootFile;

  public:
    MyAnalysis();
    static MyAnalysis *Instance(){ 
       if ( !fMySelf ) { fMySelf = new MyAnalysis(); }   
       return fMySelf; 
    }
    void Print();
    void Close();
    virtual ~MyAnalysis();
    void Initialize();

    void SetRootFile(G4String fname) { fRootFile=fname; }

};


#endif
