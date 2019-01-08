//
// ********************************************************************
// * License and Disclaimer                                           *
// *                                                                  *
// ********************************************************************
//
// $Id$
//
// Small example to write LCIO file by C++

//....oooOO0OOooo........oooOO0OOooo........oooOO0OOooo........oooOO0OOooo......

#include "lcio.h"
#include "IO/LCWriter.h"
#include "IOIMPL/LCFactory.h"
#include "IMPL/LCRunHeaderImpl.h"
#include "IMPL/SimTrackerHitImpl.h"
#include "IMPL/LCCollectionVec.h"
#include "IMPL/LCEventImpl.h"
#include "EVENT/LCIO.h"

using namespace IOIMPL;
using namespace IO;
using namespace IMPL;
using namespace EVENT;

int main(int argc,char** argv)
{
  // Detect interactive mode (if no arguments) and define UI session
  //

  LCWriter* lcwriter = LCFactory::getInstance()->createLCWriter();

  lcwriter->open("my_file.slcio");

  int run_number = 21;
  int number_of_hit = 5;
  LCRunHeaderImpl *runHdr = new LCRunHeaderImpl();
  runHdr->setRunNumber(run_number);
  runHdr->setDetectorName("MyDetector");
  lcwriter->writeRunHeader(runHdr);

  for (int ievt=0; ievt<10; ievt++ ) {
     LCEventImpl *evt=new LCEventImpl();
     evt->setRunNumber(run_number);
     evt->setEventNumber(ievt);

     LCCollectionVec *trkVec = new LCCollectionVec( LCIO::SIMTRACKERHIT );

     for ( int ihit=0; ihit<number_of_hit; ihit++ ) {
        SimTrackerHitImpl *hit=new SimTrackerHitImpl();

        hit->setCellID1(ihit);
        const double pos[3]={10.0, 5.0, 100.0};
        hit->setPosition(pos);
        trkVec->push_back(hit);

     }
          
     evt->addCollection(trkVec, "MyTrackerHit");

     lcwriter->writeEvent(evt);
     delete evt;
  }
  
  lcwriter->close();

}
