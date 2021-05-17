/** 
 * @file MyDSTProcessor.cc
 * @brief Example of DST analysis program
 * 
 * <h4>Overview</h4>
 * This processor reads ILD optimization samples and calculate 
 *   - visible energy 
 *   - visible mass
 * and results is written as a root ntuple file.
 *
 * <h4>Usefull links</h4>
 * Following links are usefull for LCIO, Marlin, and doxygen
 * <ul>
 *  <li><a href="https://ilcsoft.desy.de/LCIO/current/doc/doxygen_api/html/index.html">LCIO documents</a>. Especially, member functions of <a href="https://ilcsoft.desy.de/LCIO/current/doc/doxygen_api/html/classEVENT_1_1ReconstructedParticle.html">EVENT::ReconstructedParticle</a></li>
 *  <li><a href="https://ilcsoft.desy.de/Marlin/current/doc/html/index.html">Marlin documents</a></li>
 *  <li><a href="http://www.doxygen.jp">http://www.doxygen.jp</a> for help of doxygen.</li>
 * </ul>
 *
 * @author Akiya Miyamoto
 * @date May 24, 2021 
*/


#include "MyDSTProcessor.h"
#include <iostream>

#include <EVENT/LCCollection.h>
#include <EVENT/MCParticle.h>
#include <EVENT/LCRelation.h>

// ----- include for verbosity dependend logging ---------
#include <marlin/VerbosityLevels.h>
#include <marlin/Exceptions.h>

#include <UTIL/PIDHandler.h>
#include <UTIL/LCTOOLS.h>
#include <UTIL/LCTime.h>

#include <TFile.h>
#include <TNtuple.h>
#include "CLHEP/Vector/LorentzVector.h"

using namespace lcio ;
using namespace marlin ;

/** 
Instance of MyDSTProcessor 
*/
MyDSTProcessor aMyDSTProcessor ;

TFile *MyDSTProcessor::_rootf = NULL ;
TNtuple *MyDSTProcessor::_nt = NULL ;

/**
 * Constructor of MyDSTProcessor.
 * register input collections and parameters
 */
MyDSTProcessor::MyDSTProcessor() : Processor("MyDSTProcessor") {

    _description = "A sample DST analysis processor " ;

    // register steering parameters: name, description, class-variable, default value
    registerInputCollection( LCIO::RECONSTRUCTEDPARTICLE,
        "ReconstructedParticleCollectionName",
        "Name of the ReconsructedParticle collection"  ,
        _colNamePFOs,  std::string("PandoraPFOs")
    );

    registerProcessorParameter("RootFileName",
        "Root file name to output Ntuples, etc",
        _rootFileName, std::string("myanal.root"));

    registerProcessorParameter("DoSelection", 
        "Select events if the condition is met.", 
        _selectEvents, bool(false));

    registerProcessorParameter("MaxEventsToWrite", 
        "Max number of events to output.", 
        _noutMax, int(-1));
    
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
    _nt = new TNtuple("nt","ntuple","emum:emup:mmumu:mmiss:mrest:np");

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
 * 
 */
void MyDSTProcessor::processEvent( LCEvent * evt ) { 

    // this gets called for every event 
    // usually the working horse ...

    const LCParameters& params = evt->getParameters();
    const double cmenergy = params.getFloatVal( "Energy" );

    static int noutEvents = 0;
    bool good_event = false;  // Output event if true.
    // print parameters of first event.
    static bool mydebug=true;
    if ( mydebug ) {
        mydebug = false;
        streamlog_out(DEBUG) << "   processing event: " << evt->getEventNumber()
                             << "   in run:  " << evt->getRunNumber()
                             << std::endl ;
//        LCTOOLS::dumpEvent(evt);
        streamlog_out(MESSAGE) << "  timestamp: " << evt->getTimeStamp() 
                               << "  weight: " << evt->getWeight() << std::endl;
        LCTime evtTime( evt->getTimeStamp() );
        streamlog_out(MESSAGE) << "  date: " << evtTime.getDateString() << std::endl;
        streamlog_out(MESSAGE) << "  detector: " << evt->getDetectorName() << std::endl;
        streamlog_out(MESSAGE) << " Event Parameters : " << std::endl;
  
        streamlog_out(MESSAGE) << "  crossSection: " << params.getFloatVal("crossSection") << " fb" << std::endl;
        streamlog_out(MESSAGE) << "  Energy: " << cmenergy << std::endl;
      
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

    if( colRP != NULL ) {
        CLHEP::HepLorentzVector psum;
        CLHEP::HepLorentzVector pmum;
        CLHEP::HepLorentzVector pmup;
        CLHEP::HepLorentzVector pini(0.0, 0.0, 0.0, cmenergy );
        int nRP = colRP->getNumberOfElements() ;
        // streamlog_out(DEBUG) << "There are " << nRP << " PandoraPFOs" << std::endl;
        for( int i=0 ; i < nRP ; i++ ) {
            ReconstructedParticle *rp = 
                dynamic_cast<ReconstructedParticle*> (colRP->getElementAt(i)) ;
            const double *pmom=rp->getMomentum();
            double energy = rp->getEnergy();
            CLHEP::HepLorentzVector p(pmom[0],pmom[1],pmom[2],energy);
            psum += p;

            const int pdg = rp->getType();
            // if ( pdg == 13 || pdg == -13 ) {
            //   streamlog_out(MESSAGE) << "i=" << i << " energy=" << energy << " pdg=" << pdg << std::endl;
            // }
            if ( pdg ==  13 && p.e() > pmum.e() ) { pmum = p; }
            if ( pdg == -13 && p.e() > pmup.e() ) { pmup = p; }

        }
        if ( pmum.e() > 0.0 && pmup.e() > 0.0 ) {
          CLHEP::HepLorentzVector pmumu = pmum + pmup;
          double mumumass= pmumu.m();
          double missmass = ( pini - pmumu ).m();
          double restmass = ( psum - pmum - pmup ).m();
          _nt->Fill(float(pmum.e()), float(pmup.e()), float(mumumass), float(missmass), float(restmass), float(nRP));

        // Check event parameter and set good_event = true, 
        // if mumu mass arround Z mass and both muon in central region.
          bool good_mumumass = ( mumumass > 80.0 && mumumass < 100.0 ) ;
          bool good_cosign = ( abs(pmum.cosTheta()) < 0.5 && abs(pmup.cosTheta()) < 0.5 );
          good_event = good_mumumass && good_cosign ;
          streamlog_out(MESSAGE) << " mumumass " << mumumass << " good_mumumass =" << good_mumumass ;
          streamlog_out(MESSAGE) << " good_cosign=" << good_cosign << " good_event=" << good_event << std::endl;
        }
    }


    // Fill data into Ntuple 

    streamlog_out(DEBUG) << "   processing event: " << evt->getEventNumber() 
                         << "   in run:  " << evt->getRunNumber() << std::endl ;
    _nEvt ++ ;

    // Set return value always true.
    // setReturnValue( true );

    // Following processors are skipped, if skipEVentException is true 
    if ( _selectEvents ) {
      if ( ! good_event ) {
        throw SkipEventException( this );
      }
    }

    // Exception to stop event processing 
    noutEvents ++;  // Count number of output events.
    if ( _noutMax > 0 && noutEvents > _noutMax ) {
       streamlog_out(MESSAGE) << "Number of events written exceeds requested." << std::endl;
       throw StopProcessingException( this );
    }
    // Other examples are available in 
    // ${MARLIN}/source/src/marlin/TestProcessor.cc

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


