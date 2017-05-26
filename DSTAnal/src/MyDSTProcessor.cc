/** 
 * @file MyDSTProcessor.cc
 * @brief Example of DST analysis program
 * 
 * <h4>Overview</h4>
 * This processor reads LOI DST samples and calculate 
 *   - visible energy 
 *   - visible mass
 *   - jet angle ( not yet )
 *   - LCFIVertex tag ( not yet )
 * and results is written as a root ntuple file.
 *
 * @author Akiya Miyamoto
 * @date May 31, 2017 
 */


#include "MyDSTProcessor.h"
#include <iostream>

#include <EVENT/LCCollection.h>
#include <EVENT/MCParticle.h>
#include <EVENT/LCRelation.h>

// ----- include for verbosity dependend logging ---------
#include "marlin/VerbosityLevels.h"

#include <UTIL/PIDHandler.h>
#include <UTIL/LCTOOLS.h>
#include <UTIL/LCTime.h>

#include "TFile.h"
#include "TNtuple.h"
#include "CLHEP/Vector/LorentzVector.h"

using namespace lcio ;
using namespace marlin ;


MyDSTProcessor aMyDSTProcessor ;

/**
 * @fn
 * Constructor of MyDSTProcessor.
 * register input collections and parameters
 */
MyDSTProcessor::MyDSTProcessor() : Processor("MyDSTProcessor") {

    // register steering parameters: name, description, class-variable, default value
    registerInputCollection( LCIO::MCPARTICLE,
            "MCParticleCollectionName" , 
            "Name of the MCParticle collection"  ,
            _colNameMCParticle ,
            std::string("MCParticlesSkimmed")
    );
    registerInputCollection( LCIO::RECONSTRUCTEDPARTICLE,
            "ReconstructedParticleCollectionName",
            "Name of the ReconsructedParticle collection"  ,
            _colNamePFOs ,
            std::string("PandoraPFOs")
    );

    registerProcessorParameter("RootFileName",
                           "Root file name to output Ntuples, etc",
                           _rootFileName,
                           std::string("myanal.root"));

}

/**
 * Initialize MyDSTProcessor.  Called once at the begining of job
 */
void MyDSTProcessor::init() { 

    /* Output information can be controlled by streamlog_out method *************/
    streamlog_out(DEBUG) << "   init called  " << std::endl ;

    printParameters() ;

    _nRun = 0 ;
    _nEvt = 0 ;
 
    /* Initialize ROOT file *****************************************************/
    _rootf=new TFile(_rootFileName.c_str(), "RECREATE");
    _nt = new TNtuple("nt","Test ntuple","ev:np:mass");

    streamlog_out(MESSAGE) << _rootFileName << " is created" << std::endl;

}


/**
 * A method to process run header in LCIO file
 */ 
void MyDSTProcessor::processRunHeader( LCRunHeader* run) { 
    
    _nRun++ ;
    
    streamlog_out(MESSAGE) << "### Run Header ### " << std::endl;
    streamlog_out(MESSAGE) << "  Run Number: " << run->getRunNumber() << std::endl;
    streamlog_out(MESSAGE) << "  Detector name: " << run->getDetectorName() << std::endl;
    streamlog_out(MESSAGE) << "  Description: " << run->getDescription() << std::endl;

    const LCParameters& params = run->getParameters();
    StringVec intKeys, floatKeys, stringKeys ;
    int nIntKeys = params.getIntKeys(intKeys).size();
    int nFloatKeys = params.getFloatKeys(floatKeys).size();
//    int nStringKeys = params.getStringKeys(stringKeys).size();
    
    for ( int i=0; i < nIntKeys ; i++ ) {
      streamlog_out(MESSAGE) << " IntKey: " << intKeys[i] << std::endl;
    }
    for ( int i=0; i < nFloatKeys ; i++ ) {
      streamlog_out(MESSAGE) << " FloatKey: " << floatKeys[i] << std::endl;
    }
//    for ( int i=0; i < nStringKeys ; i++ ) {
//      streamlog_out(MESSAGE) << " StringKey: " << stringKeys[i] << std::endl;
//    }
    StringVec stringVals;
    params.getStringVals( "MOKKA_MacroFile", stringVals ) ;
    for ( unsigned int i=0; i < stringVals.size() ; i++ ) {
       streamlog_out(MESSAGE) << stringVals[i] << std::endl;
    }

} 

/**
 * Process event data. Main part of your analysis
 */
void MyDSTProcessor::processEvent( LCEvent * evt ) { 

    // this gets called for every event 
    // usually the working horse ...

    // Dump events in first 5 events
    static bool mydebug=true;
    if( _nEvt > 5 ) { mydebug=false; }
    if ( mydebug ) {
      streamlog_out(DEBUG) << "   processing event: " << evt->getEventNumber()
                       << "   in run:  " << evt->getRunNumber()
                       << std::endl ;
      LCTOOLS::dumpEvent(evt);
    }

    // print Some Event parameters
    if ( mydebug ) {
      streamlog_out(MESSAGE) << "  timestamp: " << evt->getTimeStamp() 
                        << "  weight: " << evt->getWeight() << std::endl;
      LCTime evtTime( evt->getTimeStamp() );
      streamlog_out(MESSAGE) << "  date: " << evtTime.getDateString() << std::endl;
      streamlog_out(MESSAGE) << "  detector: " << evt->getDetectorName() << std::endl;
      streamlog_out(MESSAGE) << " Event Parameters : " << std::endl;
  
      const LCParameters& params = evt->getParameters();
      FloatVec xsectVec;
      params.getFloatVals( "CrossSection_fb", xsectVec ) ;
      streamlog_out(MESSAGE) << "  CrossSection_fb: " << xsectVec[0] << std::endl;
      FloatVec energyVec;
      params.getFloatVals( "Energy", energyVec ) ;
      streamlog_out(MESSAGE) << "  Energy: " << energyVec[0] << std::endl;
      
    }

    // MCParticleCollections
    LCCollection* colMP = NULL;
    try { 
       colMP = evt->getCollection(_colNameMCParticle);
    }   
    catch ( lcio::DataNotAvailableException e )
    {
       streamlog_out(WARNING) << _colNameMCParticle << "collection not available" << std::endl;
       colMP = NULL;
    }
    if( colMP != NULL ) {
       int nMCP = colMP->getNumberOfElements();
       for( int i=0 ; i < nMCP ; i++ ) {
//          MCParticle *p = dynamic_cast<MCParticle*> (colMP->getElementAt(i)); 
       }
    }
    float visible_energy=0;
    float visible_mass=0;
    int   npart=0;


    // Scan ReconstructedParticle collection
    LCCollection* colRP = NULL;
    try {
       colRP = evt->getCollection( _colNamePFOs);
    }
    catch ( lcio::DataNotAvailableException e )
    {
       streamlog_out(WARNING) << _colNamePFOs << "collection not available" << std::endl;
       colRP = NULL;
    }
    if( colRP != NULL ) {
       int nRP = colRP->getNumberOfElements() ;
       npart=nRP;
       CLHEP::HepLorentzVector psum;
       for( int i=0 ; i < nRP ; i++ ) {
         ReconstructedParticle *rp = 
            dynamic_cast<ReconstructedParticle*> (colRP->getElementAt(i)) ;
         const double *pmom=rp->getMomentum();
         double energy = rp->getEnergy();
         CLHEP::HepLorentzVector p(pmom[0],pmom[1],pmom[2],energy);
         psum += p;
       }
       visible_energy=psum.e();
       visible_mass=psum.m();
    }

    // Using LCRelation object
    LCCollection* colRel = NULL;
    try { 
       colRel = evt->getCollection("RecoMCTruthLink");
    }
    catch ( lcio::DataNotAvailableException e )
    {
       streamlog_out(WARNING) << "RecoMCTruthLink collection not available" << std::endl;
       colRel = NULL;
    }
    if ( mydebug && colRel != NULL ) {
       for ( int i=0; i < colRel->getNumberOfElements(); i++ ) {
          LCRelation* lcrel = dynamic_cast<LCRelation*> (colRel->getElementAt(i));
          ReconstructedParticle *rp = 
	    dynamic_cast<ReconstructedParticle*> (lcrel->getFrom());           
          MCParticle *mcp = 
	    dynamic_cast<MCParticle*> (lcrel->getTo());           
          float weight = lcrel->getWeight();
          streamlog_out(MESSAGE) << " Rec. energy=" << rp->getEnergy() 
                               << " weight=" << weight 
                               << " MCP energy=" << mcp->getEnergy()
                               << " ID=" << mcp->getPDG()
                               << std::endl;
       }
    }

    // Fill data into Ntuple 
  
    _nt->Fill(visible_energy, float(npart), visible_mass);

    //-- note: this will not be printed if compiled w/o MARLINDEBUG=1 !

    streamlog_out(DEBUG) << "   processing event: " << evt->getEventNumber() 
        << "   in run:  " << evt->getRunNumber() << std::endl ;

    _nEvt ++ ;
}



void MyDSTProcessor::check( LCEvent * evt ) { 
    // nothing to check here - could be used to fill checkplots in reconstruction processor
}

/**
 * Called at the end of job
 */
void MyDSTProcessor::end(){ 

    std::cout << "MyDSTProcessor::end()  " << name() 
     	    << " processed " << _nEvt << " events in " << _nRun << " runs "
     	    << std::endl ;
    _rootf->Write();

}

