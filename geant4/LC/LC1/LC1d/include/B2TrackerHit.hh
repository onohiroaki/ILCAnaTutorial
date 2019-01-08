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
// $Id: B2TrackerHit.hh 69505 2013-05-07 01:57:27Z asaim $
//
/// \file B2TrackerHit.hh
/// \brief Definition of the B2TrackerHit class

#ifndef B2TrackerHit_h
#define B2TrackerHit_h 1

#include "G4VHit.hh"
#include "G4THitsCollection.hh"
#include "G4Allocator.hh"
#include "G4ThreeVector.hh"
#include "tls.hh"

/// Tracker hit class
///
/// It defines data members to store the trackID, chamberNb, energy deposit,
/// and position of charged particles in a selected volume:
/// - fTrackID, fChamberNB, fEdep, fPos

class B2TrackerHit : public G4VHit
{
  public:
    B2TrackerHit();
    B2TrackerHit(const B2TrackerHit&);
    virtual ~B2TrackerHit();

    // operators
    const B2TrackerHit& operator=(const B2TrackerHit&);
    G4int operator==(const B2TrackerHit&) const;

    inline void* operator new(size_t);
    inline void  operator delete(void*);

    // methods from base class
    virtual void Draw();
    virtual void Print();

    // Set methods
    void SetTrackID  (G4int track) { fTrackID = track; }
    void SetCopyNo(G4int copyno)   { fCopyNo = copyno; }

    void SetPDG(G4int pdg) { fPDG = pdg; }
    void SetCharge(G4double charge) { fCharge=charge; }
    void SetPreStatus(G4int prestatus)  { fPreStatus = prestatus; }
    void SetPostStatus(G4int poststatus) { fPostStatus = poststatus; }
    void SetEdep(G4double de)      { fEdep = de; }

    void SetPrePos( G4ThreeVector pos) { fPrePos = pos; }
    void SetPreTime( G4double time) { fPreTime = time; }
    void SetPreMom( G4ThreeVector mom) { fPreMom = mom; }
    void SetPreEnergy( G4double energy) { fPreEnergy = energy; }

    void SetPostPos( G4ThreeVector pos) { fPostPos = pos; }
    void SetPostTime( G4double time) { fPostTime = time; }
    void SetPostMom( G4ThreeVector mom) { fPostMom = mom; }
    void SetPostEnergy( G4double energy) { fPostEnergy = energy; }

    // Get methods
    G4int GetTrackID() const     { return fTrackID; };
    G4int GetCopyNo() const   { return fCopyNo; };
    G4double GetEdep() const     { return fEdep; };

    G4int GetPDG() { return fPDG; }
    G4double GetCharge() { return fCharge; }
    G4int GetPreStatus() { return fPreStatus; }
    G4int GetPostStatus() { return fPostStatus; }
    G4double SetEdep() { return fEdep; }

    G4ThreeVector GetPrePos() { return fPrePos; }
    G4double GetPreTime() { return fPreTime; }
    G4ThreeVector GetPreMom() { return fPreMom; }
    G4double GetPreEnergy() { return fPreEnergy; }

    G4ThreeVector GetPostPos() { return fPostPos; }
    G4double GetPostTime() { return fPostTime; }
    G4ThreeVector GetPostMom() { return fPostMom; }
    G4double GetPostEnergy() { return fPostEnergy; }

  private:

      G4int         fTrackID;
      G4int         fCopyNo;
      G4double      fEdep;
      G4int         fPDG;
      G4double      fCharge;
      
      G4int         fPreStatus;
      G4ThreeVector fPrePos;
      G4double      fPreTime;
      G4ThreeVector fPreMom;
      G4double      fPreEnergy;

      G4int         fPostStatus;
      G4ThreeVector fPostPos;
      G4double      fPostTime;
      G4ThreeVector fPostMom;
      G4double      fPostEnergy;

};

//....oooOO0OOooo........oooOO0OOooo........oooOO0OOooo........oooOO0OOooo......

typedef G4THitsCollection<B2TrackerHit> B2TrackerHitsCollection;

extern G4ThreadLocal G4Allocator<B2TrackerHit>* B2TrackerHitAllocator;

//....oooOO0OOooo........oooOO0OOooo........oooOO0OOooo........oooOO0OOooo......

inline void* B2TrackerHit::operator new(size_t)
{
  if(!B2TrackerHitAllocator)
      B2TrackerHitAllocator = new G4Allocator<B2TrackerHit>;
  return (void *) B2TrackerHitAllocator->MallocSingle();
}

//....oooOO0OOooo........oooOO0OOooo........oooOO0OOooo........oooOO0OOooo......

inline void B2TrackerHit::operator delete(void *hit)
{
  B2TrackerHitAllocator->FreeSingle((B2TrackerHit*) hit);
}

//....oooOO0OOooo........oooOO0OOooo........oooOO0OOooo........oooOO0OOooo......

#endif
