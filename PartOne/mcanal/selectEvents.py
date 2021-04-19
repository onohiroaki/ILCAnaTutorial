'''
An example to write a LCIO file.
Select events wit |M(mu+mu-) - Mz| ~ delta, and write them in to a new file.

Other example will be found in ${LCIO}/examples/python
'''

from __future__ import absolute_import
from __future__ import print_function
from pyLCIO import EVENT, IOIMPL, IMPL
from pyLCIO.io import LcioReader
import os, sys, copy

import ROOT
ROOT.gROOT.SetBatch()

# ===========================================================================
def copyObjectParameters( obj, copyObj ):
    ''' Copies the parameters of an LCObject to another LCObject'''
    parameters = obj.getParameters()
    copyParameters = copyObj.parameters()
    keyVec = ROOT.vector('string')()
    for intKey in parameters.getIntKeys( keyVec ):
        intVec = ROOT.vector('int')()
        copyParameters.setValues( intKey, parameters.getIntVals( intKey, intVec ) )
    keyVec.clear()
    for floatKey in parameters.getFloatKeys( keyVec ):
        floatVec = ROOT.vector('float')()
        copyParameters.setValues( floatKey, parameters.getFloatVals( floatKey, floatVec ) )
    keyVec.clear()
    for stringKey in parameters.getStringKeys( keyVec ):
        stringVec = ROOT.vector('string')()
        copyParameters.setValues( stringKey, parameters.getStringVals( stringKey, stringVec ) )

# ====================================================== #
def selectEvents( inputFileName, outputFileName , maxread=1000):
    '''
    Function: Select events from inputFileName and write to outputFileName
   
    Inputs:
       inputFileName  :
       outputFileName :
       maxread        : max number of events to read 

    '''

    # =======================================================================
    MASS_MIN = 81.1876
    MASS_MAX = 101.1876

    # create a reader
    if not os.path.exists(inputFileName): 
       print(inputFileName + " does not exist.")
       exit(0)

    reader = LcioReader.LcioReader( str(inputFileName) )
    print("Input file is " + inputFileName)

    # create a writer
    print("Selected events are written in " + outputFileName)
    if os.path.exists(outputFileName):
       print("Output file, " + outputFileName + ", exists. Remove it first.")
       exit(0) 

    writer = IOIMPL.LCFactory.getInstance().createLCWriter()
    writer.open( str(outputFileName), EVENT.LCIO.WRITE_NEW ) 
 
    # Write run header
    aRunNumber = 1234
    runHeader = IMPL.LCRunHeaderImpl()
    runHeader.setRunNumber( aRunNumber )
    runpara = runHeader.getParameters()
    # keyVec = ROOT.vector("string")()
    runpara.setValue("InputFileName", str(inputFileName))
    runpara.setValue("Mass Maximum", float(MASS_MAX))
    runpara.setValue("Mass Minimum", float(MASS_MIN))
    writer.writeRunHeader( runHeader )

    nread = 0 
    nwrite = 0

    ##  Create a root file to monitor selection.
    rootfile = outputFileName.replace(".slcio", ".root")
    rfile = ROOT.TFile(rootfile, "RECREATE")
    ntev = ROOT.TNtuple("nt","event selection", "emum:emup:mmumu:mmiss:mrest")
    print("==== Creating root file " + str(rootfile) )

    # =======================================================================
    # Read events in the file, and fill Ntuple
    # =======================================================================
    nread = 0
    for event in reader:
        if not event:
           print("Read EOF at nread ="+str(nread))
           break
        if maxread > 0 and nread >= maxread:
           print("Reached maxread(%d) at nread=%d" % (maxread, nread))
           break
        nread = nread + 1
        if nread%1000 == 0:
           print(" reading "+str(nread)+"-th event")

        psum = ROOT.TLorentzVector(0.0, 0.0, 0.0, 0.0)
        pmum = ROOT.TLorentzVector(0.0, 0.0, 0.0, 0.0)
        pmup = ROOT.TLorentzVector(0.0, 0.0, 0.0, 0.0)
        pini = ROOT.TLorentzVector(0.0, 0.0, 0.0, 250.0)


        # for colname in event.getCollectionNames():
        #    print(" colname="+colname)

        mcps = event.getCollection(str("MCParticle"))
    
        # Loop over all particle in MCParticle collection.
        # and find mu+ and mu- of the highest energy
        for mcp in mcps:
            if mcp.getGeneratorStatus() == 1 :  # select final state particles
               p = mcp.getLorentzVec()
               psum += p
               pdg = mcp.getPDG()
               if pdg == 13 and p.E() > pmum.E():
                  pmum = p
               if pdg == -13 and p.E() > pmup.E():
                  pmup = p
            
        pmumu = pmum + pmup   
        mumumas = pmumu.M()
        missmas = (pini - pmumu).M()
        restmas = ( psum - pmum - pmup ).M()

        # Fiil variables in Ntuple
        ntev.Fill(float(pmum.E()), float(pmup.E()), float(mumumas), float(missmas), float(restmas))
    
        # #################################################  
        # Select events
        # #################################################
        
        if float(mumumas) < MASS_MIN or float(mumumas) > MASS_MAX:
           continue

        # Passed event selection.  Create output collection
        nwrite = nwrite + 1
        print("Passed selection: M(mumu)=%f, nwrite/nread=%d/%d" % ( float(mumumas), nwrite, nread))
        writeEvent = IMPL.LCEventImpl()
        # Event header
        writeEvent.setEventNumber( event.getEventNumber() )
        writeEvent.setRunNumber( aRunNumber )
        writeEvent.setDetectorName( event.getDetectorName() )
        writeEvent.setTimeStamp( event.getTimeStamp() )
        copyObjectParameters( event, writeEvent )
        # Event parameters
        writeParams = writeEvent.getParameters()
        # keyVec = ROOT.vector("string")()
        writeParams.setValue("nwrite", nwrite)  # integer
        writeParams.setValue("mumu_mass", float(mumumas))  # float

        # Collections
        for colname in ["MCParticle"]:
          col = event.getCollection( colname )
          colwrite = copy.deepcopy(col)
          writeEvent.addCollection( colwrite, colwrite.getTypeName()) # Add input correction to output

        # Write event
        writer.writeEvent( writeEvent )
    
    # close file at the end.
    writer.flush()
    writer.close
        
    print("### Read %d events. Write %d events" % ( nread, nwrite) )
    rfile.Write()
    rfile.Close()

    return

#======================================================#
if __name__ == '__main__':


    basepath = os.environ["HOME"] + "/Tutorial/data"
    inputFileName = basepath + "/E250-TDR_ws.P4f_zz_sl.Gwhizard-1_95.eL.pR.I106575.001.slcio"
    outputFileName = "selected_events.slcio"

    # Select events
    selectEvents( inputFileName, outputFileName , maxread=1000)

