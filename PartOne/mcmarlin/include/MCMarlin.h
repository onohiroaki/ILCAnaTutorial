#ifndef MCMarlin_h
#define MCMarlin_h 1

#include "marlin/Processor.h"
#include "lcio.h"
#include <string>

class TNtuple;
class TFile;

using namespace lcio ;
using namespace marlin ;

/**  Example processor for MCParticle Collection
 * 
 *  <h4>Input - Prerequisites</h4>
 *  Needs the collection of MCParticles.
 *
 *  <h4>Output</h4> 
 *  A Root histogram
 * 
 * @param MCParticleCollectionName Name of the MCParticle collection
 *
 * @author Akiya Miyamoto, KEK
 * @version
 */

class MCMarlin : public Processor {
  
    public:
  
        virtual Processor*  newProcessor() { return new MCMarlin ; }
  
        MCMarlin() ;
  
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
      
        virtual void check( LCEvent * evt ) ; 
      
        /** Called after data processing for clean up.
        */
        virtual void end() ;
  
    protected:

        /** Input collection names.
         */
        std::string _colNameMCParticle {} ;
        
        /** Output root file name.
         */
        std::string _rootFileName {} ;
      
        int _nRun{};  /**< run number */
        int _nEvt{};  /**< event number */
        
        /** Ntuple to output analysis result
         */
        static TNtuple *_nt;
        static TFile   *_rootf;  /**< root file object */
};

#endif

