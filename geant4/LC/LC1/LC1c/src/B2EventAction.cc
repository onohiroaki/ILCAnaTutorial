//
// ********************************************************************
// * License and Disclaimer                                           *
// *                                                                  *
// * The  Geant4 software  is  copyright of the Copyright Holders  of *
// * the Geant4 Collaboration.  It is provided  under  the terms  and *
// * conditions of the Geant4 Software License,  included in the file *
// * LICENSE and available at  http://cern.ch/geant4/license .  These *
// * include a list of copyright holders.                             *
// *                                                                  *
// * Neither the authors of this software system, nor their employing *
// * institutes,nor the agencies providing financial support for this *
// * work  make  any representation or  warranty, express or implied, *
// * regarding  this  software system or assume any liability for its *
// * use.  Please see the license in the file  LICENSE  and URL above *
// * for the full disclaimer and the limitation of liability.         *
// *                                                                  *
// * This  code  implementation is the result of  the  scientific and *
// * technical work of the GEANT4 collaboration.                      *
// * By using,  copying,  modifying or  distributing the software (or *
// * any work based  on the software)  you  agree  to acknowledge its *
// * use  in  resulting  scientific  publications,  and indicate your *
// * acceptance of all terms of the Geant4 Software license.          *
// ********************************************************************
//
// $Id: B2EventAction.cc 69652 2013-05-10 09:05:11Z ihrivnac $
//
/// \file B2EventAction.cc
/// \brief Implementation of the B2EventAction class

#include "B2EventAction.hh"

#include "G4Event.hh"
#include "G4EventManager.hh"
#include "G4TrajectoryContainer.hh"
#include "G4Trajectory.hh"
#include "G4ios.hh"
#include "MyAnalysis.hh"
#include "B2TrackerHit.hh"

//....oooOO0OOooo........oooOO0OOooo........oooOO0OOooo........oooOO0OOooo......

B2EventAction::B2EventAction()
: G4UserEventAction()
{}

//....oooOO0OOooo........oooOO0OOooo........oooOO0OOooo........oooOO0OOooo......

B2EventAction::~B2EventAction()
{}

//....oooOO0OOooo........oooOO0OOooo........oooOO0OOooo........oooOO0OOooo......

void B2EventAction::BeginOfEventAction(const G4Event*)
{}

//....oooOO0OOooo........oooOO0OOooo........oooOO0OOooo........oooOO0OOooo......

void B2EventAction::EndOfEventAction(const G4Event* event)
{
  // get number of stored trajectories

  G4TrajectoryContainer* trajectoryContainer = event->GetTrajectoryContainer();
  G4int n_trajectories = 0;
  if (trajectoryContainer) n_trajectories = trajectoryContainer->entries();

  // periodic printing

  G4int eventID = event->GetEventID();
  // if ( eventID < 100 || eventID % 100 == 0) {
  if ( eventID < 100 ) {
    G4cout << ">>> Event: " << eventID  << G4endl;
    if ( trajectoryContainer ) {
      G4cout << "    " << n_trajectories
             << " trajectories stored in this event." << G4endl;
    }
    G4VHitsCollection* hc = event->GetHCofThisEvent()->GetHC(0);
    G4cout << "    "  
           << hc->GetSize() << " hits stored in this event" << G4endl;
  }

  MyAnalysis *myanal = MyAnalysis::Instance();
  // myanal->Print();

  G4VHitsCollection* hc = event->GetHCofThisEvent()->GetHC(0);
  G4cout << hc->GetSize() << " Number of hits in this event" << G4endl;
  auto hitsCollection 
    = static_cast<B2TrackerHitsCollection*>(event->GetHCofThisEvent()->GetHC(0));

  // for_each ( B2TrackerHit *ahit in hc ) {
  for ( unsigned int ih=0; ih < hitsCollection->GetSize() ; ih ++ ) {
    B2TrackerHit *ahit = (B2TrackerHit*)hc->GetHit(ih);
  //  G4cerr << " Tid=" << ahit->GetTrackID() ;
  //  G4cerr << " fStatus=" << ahit->GetStatus(); 
  //  G4cerr << " Edep=" << ahit->GetEdep();
  //  G4cerr << G4endl;
    G4double xh = ahit->GetPostPos().x();
    G4double yh = ahit->GetPostPos().y();
    G4double zh = ahit->GetPostPos().z();
    G4double th = ahit->GetPostTime();
    G4double pxh = ahit->GetPostMom().x();
    G4double pyh = ahit->GetPostMom().y();
    G4double pzh = ahit->GetPostMom().z();
    G4double eh = ahit->GetPostEnergy();

    myanal->fNt->Fill((float)eventID, (float)ahit->GetTrackID(), 
                      (float)ahit->GetPDG(), (float)ahit->GetPostStatus(), 
                      (float)ahit->GetCopyNo(), 
                      (float)ahit->GetEdep(), 
                      (float)xh, (float)yh, (float)zh, (float)th, 
                      (float)pxh, (float)pyh, (float)pzh, (float)eh);
  }

}  

//....oooOO0OOooo........oooOO0OOooo........oooOO0OOooo........oooOO0OOooo......
