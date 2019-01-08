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
// $Id: B2PrimaryGeneratorAction.cc 66536 2012-12-19 14:32:36Z ihrivnac $
//
/// \file B2PrimaryGeneratorAction.cc
/// \brief Implementation of the B2PrimaryGeneratorAction class

#include "B2PrimaryGeneratorAction.hh"

#include "G4LogicalVolumeStore.hh"
#include "G4LogicalVolume.hh"
#include "G4Box.hh"
#include "G4Event.hh"
#include "G4ParticleGun.hh"
#include "G4ParticleTable.hh"
#include "G4ParticleDefinition.hh"
#include "G4SystemOfUnits.hh"

#include "G4MuonPlus.hh"
#include "G4MuonMinus.hh"
#include "Randomize.hh"

#include <cmath>

//....oooOO0OOooo........oooOO0OOooo........oooOO0OOooo........oooOO0OOooo......


G4double B2PrimaryGeneratorAction::fCosTheta=-100.0;
G4double B2PrimaryGeneratorAction::fPhi=-100.0;

B2PrimaryGeneratorAction::B2PrimaryGeneratorAction()
 : G4VUserPrimaryGeneratorAction()
{
  /*
  G4int nofParticles = 1;
  fParticleGun = new G4ParticleGun(nofParticles);

  // default particle kinematic

  G4ParticleDefinition* particleDefinition 
    = G4ParticleTable::GetParticleTable()->FindParticle("proton");

  fParticleGun->SetParticleDefinition(particleDefinition);
  // fParticleGun->SetParticleMomentumDirection(G4ThreeVector(0.,0.,1.));
  fParticleGun->SetParticleMomentumDirection(G4ThreeVector(0.5,0.5,0.2));
  fParticleGun->SetParticleEnergy(3.0*GeV);
  */

}

//....oooOO0OOooo........oooOO0OOooo........oooOO0OOooo........oooOO0OOooo......

B2PrimaryGeneratorAction::~B2PrimaryGeneratorAction()
{
  // delete fParticleGun;
}

//....oooOO0OOooo........oooOO0OOooo........oooOO0OOooo........oooOO0OOooo......

void B2PrimaryGeneratorAction::GeneratePrimaries(G4Event* anEvent)
{
  // This function is called at the begining of event

  // In order to avoid dependence of PrimaryGeneratorAction
  // on DetectorConstruction class we get world volume
  // from G4LogicalVolumeStore.
 /*
  G4double worldZHalfLength = 0;
  G4LogicalVolume* worldLV
    = G4LogicalVolumeStore::GetInstance()->GetVolume("World");
  G4Box* worldBox = NULL;
  if ( worldLV ) worldBox = dynamic_cast<G4Box*>(worldLV->GetSolid());
  if ( worldBox ) worldZHalfLength = worldBox->GetZHalfLength();
  else  {
    G4cerr << "World volume of box not found." << G4endl;
    G4cerr << "Perhaps you have changed geometry." << G4endl;
    G4cerr << "The gun will be place in the center." << G4endl;
  }
  */
  /*
  // fParticleGun->SetParticlePosition(G4ThreeVector(0., 0., -worldZHalfLength));
  fParticleGun->SetParticlePosition(G4ThreeVector(0., 0., 0.));

  fParticleGun->GeneratePrimaryVertex(anEvent);
  */

  G4double ene = 250.0 * GeV;
  G4double mass = 0.105 * GeV;
  G4double mom = std::sqrt( ene*ene - mass*mass );

  G4double pi = 3.141592653589793 ;

  G4PrimaryVertex *primaryVertex = new G4PrimaryVertex(0.0, 0.0, 0.0, 0.0);

  G4double phi = 2.0*pi*G4RandFlat::shoot();
  
  G4bool retry=true;
  G4double cosx = 0.0 ;
  while(retry) { 
    cosx = 1.0 - 2.0*G4RandFlat::shoot() ;
    G4double val = 0.5*( 1 + cosx*cosx );
    if ( G4RandFlat::shoot() < val ) {
      retry = false; 
    }
  }
  fCosTheta=cosx;
  fPhi = phi;

  for(int i=0; i<2; i++ ) {

    G4ParticleDefinition *particleDef = 0;
    if ( i == 1 ) particleDef = G4MuonMinus::MuonMinus();
    else          particleDef = G4MuonPlus::MuonPlus();

    cosx *= -1.0;
    phi += pi;

    G4double sinx = std::sqrt( (1.0 - cosx ) * ( 1.0 + cosx ) );
    G4double momx = mom * std::cos(phi) * sinx;
    G4double momy = mom * std::sin(phi) * sinx;
    G4double momz = mom * cosx;

    G4PrimaryParticle *p = new G4PrimaryParticle( particleDef, 
        momx, momy, momz);
    p->SetMass(particleDef->GetPDGMass());
    p->SetCharge(particleDef->GetPDGCharge());
    
    primaryVertex->SetPrimary(p);
    
  }  
  anEvent->AddPrimaryVertex(primaryVertex);


}

//....oooOO0OOooo........oooOO0OOooo........oooOO0OOooo........oooOO0OOooo......
