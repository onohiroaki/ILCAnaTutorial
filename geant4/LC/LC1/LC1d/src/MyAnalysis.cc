
#include <cstdlib>
#include <iostream>
// #include <string>
// #include <sstream>
#include <stdio.h>
#include "MyAnalysis.hh"

using namespace std;
// using namespace dd4hep;
// using namespace dd4hep::sim;

MyAnalysis *MyAnalysis::fMySelf=0;
G4String  MyAnalysis::fRootFile=G4String("myanal.root");

MyAnalysis::MyAnalysis()
{
  fMySelf=this;
}

MyAnalysis::~MyAnalysis()
{
  fMySelf = 0;
}

void MyAnalysis::Initialize()
{

   std::cerr << " MyAnalysis ... constructed.   Analysis result is writeen to " << fRootFile << std::endl;

   fFile = new TFile(fRootFile.data(),"recreate");
   fNt = new TNtuple("nt","tracker hit","ev:tid:pdg:st:cno:edep:xh:yh:zh:th:pxh:pyh:pzh:eh");
   fNtEvt = new TNtuple("ntevt","tracker hit","ev:cs:phi");

}

void MyAnalysis::Print()
{
  std::cerr << "dummy print function." << std::endl;

}

void MyAnalysis::Close()
{
    cerr << "MyAnalysis .... closing..." << endl;
    fFile->Write();
    fFile->Close();
}

