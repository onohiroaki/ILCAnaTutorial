#ifndef __CINT__ 
#include "lcio.h"
#include "IO/LCReader.h"
#include "IOIMPL/LCFactory.h"
#include "EVENT/LCCollection.h"
#include "EVENT/ReconstructedParticle.h"
#include "EVENT/LCEvent.h"
#include "UTIL/LCTOOLS.h"
#include "UTIL/LCIterator.h"
#endif

#include "TH1F.h"
#include "TLorentzVector.h"

using namespace lcio ;

/*
put this into your .rootlogon.C file

{
 gInterpreter->AddIncludePath("$LCIO");
 gSystem->Load("${LCIO}/lib/liblcio.so");
 gSystem->Load("${LCIO}/lib/liblcioDict.so");
}

for the LCIO API documentation see:
http://lcio.desy.de/v02-09/doc/doxygen_api/html/index.html
*/

void anajob(const char* FILEN) {
  
  const char* mcColName = "MCParticlesSkimmed"; 
  const char* pfoColName = "PandoraPFOs"; 
  int nEvents = 0  ;
  IO::LCReader* lcReader = IOIMPL::LCFactory::getInstance()->createLCReader() ;
  lcReader->setReadCollectionNames( {pfoColName, mcColName} );
  lcReader->open( FILEN ) ;

  EVENT::LCEvent* evt = 0 ;

  //----------- the event loop -----------
  while( (evt = lcReader->readNextEvent()) != 0 ) {

    UTIL::LCTOOLS::dumpEvent( evt ) ;
    LCIterator<ReconstructedParticle> pfos( evt, pfoColName ) ;
    LCIterator<MCParticle> mcps( evt, mcColName ) ;
    LCCollection* pfocol = evt->getCollection( pfoColName ) ;
    LCCollection* mccol = evt->getCollection( mcColName ) ;
    double energy = 0;
    int npfos = 0;
    //auto pfo = pfos.next(); 
    auto pfo = pfos.next();
    while ( pfo ) {
      npfos++;
      energy += pfo->getEnergy();
      pfo = pfos.next();
    }
    std::cout << "Npfos=" << npfos << ", Energy=" << energy << std::endl;
    nEvents ++ ;
    if ( nEvents == 100 ) break;
  }
  // -------- end of event loop -----------

  std::cout << std::endl 
	    <<  "  " <<  nEvents 
	    << " events read from file: " 
	    << FILEN << std::endl  ;
  

  lcReader->close() ;

  delete lcReader ;
}
