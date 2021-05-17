#ifndef MyDSTProcessor_h
#define MyDSTProcessor_h 1

#include "marlin/Processor.h"
#include "lcio.h"
#include <string>
#include <limits.h>

class TNtuple;
class TFile;

using namespace lcio ;
using namespace marlin ;


/**  Example processor for DST analysis
 * 
 *  <h4>Input - Prerequisites</h4>
 *  Needs the collection of MCParticles and ReconstructedParticles.
 *
 *  <h4>Output</h4> 
 *  A Root histogram
 * 
 * @param ReconstructedParticleCollectionName  Name of the ReconstructedParticleCollection 
 *
 * @author Akiya Miyamoto, KEK
 * @version
 */

class MyDSTProcessor : public Processor {
  
    public:
  
        /**
        Create an instance of  MyDTProcessor
        */
        virtual Processor*  newProcessor() { return new MyDSTProcessor ; }
  
        MyDSTProcessor() ;
  
        /** Called at the begin of the job before anything is read.
        * Use to initialize the processor, e.g. book histograms.
        */
        virtual void init() ;
      
        /** Called for every run.
        */
        virtual void processRunHeader( LCRunHeader* run ) ;
      
        /** Called for every event - the working horse.
        */
        virtual void processEvent( LCEvent * evt ) ; 
      
        // virtual void check( LCEvent * evt ) ; 
      
        /** Called after data processing for clean up.
        */
        virtual void end() ;
  
    protected:

        /** Input collection names.  */
	std::string _colNamePFOs = "" ;

        /** run number */
        int _nRun = 0;  

        /** event number */
        int _nEvt = 0;  
        
        /** If true, throw SkipEVentException if the condition is met. */ 
        bool _selectEvents = false;   

        /** Maximum number of output events */
        int _noutMax = INT_MAX;

        /** Output root file name.   */
	std::string _rootFileName = "";
      
        /** Ntuple to output analysis result   */
        static TNtuple *_nt;

        /** root file object */
        static TFile   *_rootf;
};

#endif

