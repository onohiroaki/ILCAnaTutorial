/** 
 * @file MyDSTProcessor.cc
 * @brief Example of DST analysis program
 * 
 * <h4>Overview</h4>
 * This processor reads ILD optimization samples and calculate 
 *   - visible energy 
 *   - visible mass
 *   - jet angle 
 *   - LCFIVertex tag ( not yet )
 * and results is written as a root ntuple file.
 *
 * @author Akiya Miyamoto
 * @date June 22, 2018 
*/


#include "MyDSTProcessor.h"
#include <iostream>

#include <EVENT/LCCollection.h>
#include <EVENT/MCParticle.h>
#include <EVENT/LCRelation.h>

// ----- include for verbosity dependend logging ---------
#include <marlin/VerbosityLevels.h>

#include <UTIL/PIDHandler.h>
#include <UTIL/LCTOOLS.h>
#include <UTIL/LCTime.h>

#include <TFile.h>
#include <TNtuple.h>
#include "CLHEP/Vector/LorentzVector.h"

using namespace lcio ;
using namespace marlin ;


MyDSTProcessor aMyDSTProcessor ;

TFile *MyDSTProcessor::_rootf = NULL ;
TNtuple *MyDSTProcessor::_nt = NULL ;

/**
 * @fn
 * Constructor of MyDSTProcessor.
 * register input collections and parameters
 */
MyDSTProcessor::MyDSTProcessor() : Processor("MyDSTProcessor") {

    _description = "A sample DST analysis processor " ;

    // register steering parameters: name, description, class-variable, default value
    registerInputCollection( LCIO::MCPARTICLE,
        "MCParticleCollectionName" , 
        "Name of the MCParticle collection"  ,
        _colNameMCParticle ,
        std::string("MCParticle")
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
    _nt = new TNtuple("nt","Test ntuple","ev:np:mass:nj:jm:csj:csj1:csj2");

    streamlog_out(MESSAGE) << _rootFileName << " is created" << std::endl;

}


/**
 * A method to process run header in LCIO file
 */ 
void MyDSTProcessor::processRunHeader( LCRunHeader* run) { 
    
    _nRun++ ;
    
    streamlog_out(MESSAGE) << std::endl;
    streamlog_out(MESSAGE) << "### Got " << _nRun << "-th Run Header ### " << std::endl;
    streamlog_out(MESSAGE) << "  Run Number: " << run->getRunNumber() << std::endl;
    streamlog_out(MESSAGE) << "  Detector name: " << run->getDetectorName() << std::endl;
    streamlog_out(MESSAGE) << "  Description: " << run->getDescription() << std::endl;

    const LCParameters& params = run->getParameters();
    StringVec intKeys, floatKeys, stringKeys ;
    int nIntKeys = params.getIntKeys(intKeys).size();
    int nFloatKeys = params.getFloatKeys(floatKeys).size();
    int nStringKeys = params.getStringKeys(stringKeys).size();
    
    if ( _nRun < 2 ) { 
      for ( int i=0; i < nIntKeys ; i++ ) {
        streamlog_out(MESSAGE) << " IntKey: " << intKeys[i] << std::endl;
      }
      for ( int i=0; i < nFloatKeys ; i++ ) {
        streamlog_out(MESSAGE) << " FloatKey: " << floatKeys[i] << std::endl;
      }
      for ( int i=0; i < nStringKeys ; i++ ) {
        streamlog_out(MESSAGE) << " StringKey: " << stringKeys[i] << std::endl;
      }
    } 
} 

/**
 * Process event data. Main part of your analysis
 */
void MyDSTProcessor::processEvent( LCEvent * evt ) { 

    // this gets called for every event 
    // usually the working horse ...

    static bool mydebug=true;
    if( _nEvt == 1 ) { mydebug=false; }
    if ( mydebug ) {
        streamlog_out(DEBUG) << "   processing event: " << evt->getEventNumber()
                             << "   in run:  " << evt->getRunNumber()
                             << std::endl ;
//        LCTOOLS::dumpEvent(evt);
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
        params.getFloatVals( "crossSection", xsectVec ) ;
        streamlog_out(MESSAGE) << "  crossSection: " << xsectVec[0] << " fb" << std::endl;
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
        streamlog_out(WARNING) << _colNameMCParticle << " collection not available" << std::endl;
        colMP = NULL;
    }
    if( colMP != NULL ) {
        int nMCP = colMP->getNumberOfElements();
        for( int i=0 ; i < nMCP ; i++ ) {
//          MCParticle *p = dynamic_cast<MCParticle*> (colMP->getElementAt(i)); 
        }
    }

    // Scan ReconstructedParticle collection
    LCCollection* colRP = NULL;
    try {
        colRP = evt->getCollection( _colNamePFOs);
    }
    catch ( lcio::DataNotAvailableException e )
    {
        streamlog_out(WARNING) << _colNamePFOs << " collection not available" << std::endl;
        colRP = NULL;
    }
    float visible_energy=0;
    float visible_mass=0;
    int   npart=0;
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

    // Get FatsJet clustring result.
    LCCollection *colJet = NULL;
    try {
        colJet = evt->getCollection("JetOut");
    }
    catch ( lcio::DataNotAvailableException e )
    {
        streamlog_out(WARNING) << "JetOut collection not available." << std::endl;
        colJet = NULL;   
    }
    float jetmas = 0.0;
    float csjet = -10.0;
    float csj1 = -10.0;
    float csj2 = -10.0;
    int   njet = 0;
    if( colJet != NULL ) {
        njet = colJet->getNumberOfElements();
        if ( colJet->getNumberOfElements() > 1 ) {
            ReconstructedParticle *jet1 = 
   	        dynamic_cast<ReconstructedParticle*> (colJet->getElementAt(0));
            ReconstructedParticle *jet2 = 
  	        dynamic_cast<ReconstructedParticle*> (colJet->getElementAt(1));
            const double *j1_mom = jet1->getMomentum();
            CLHEP::HepLorentzVector j1(j1_mom[0], j1_mom[1], j1_mom[2], jet1->getEnergy());
            const double *j2_mom = jet2->getMomentum();
            CLHEP::HepLorentzVector j2(j2_mom[0], j2_mom[1], j2_mom[2], jet2->getEnergy());
            jetmas = (j1+j2).m();
            csjet  = (j1+j2).cosTheta();
            csj1   = j1.cosTheta();
            csj2   = j2.cosTheta();
        }
    }    

    // Fill data into Ntuple 

    _nt->Fill(visible_energy, float(npart), visible_mass, float(njet), jetmas, csjet, csj1, csj2);  

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


