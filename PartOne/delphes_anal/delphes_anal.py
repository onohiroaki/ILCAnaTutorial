'''
Analize e1 E1 --> e2 E2 h sample produced by Delphes.
Functions in mcanal/e2e2anal.py are reused.

'''

from __future__ import print_function
import sys, os, json

# Put PartOne/mcanal/e2e2anal.py to PYTHONPATH environment parameter
sys.path.append(os.environ["HOME"]+"/Tutorial/PartOne/mcanal")
from e2e2anal import *

# ====================================================== 
def printPFOData(data, maxdump=1):
    ''' 
    Function: Read maxdump of records defined in data and print it contents.
  
    Input arguments: 
        data : Dictionay object describing data
                  data = {"alias": "alias of data file", "files": ["file1","file2",...] } 
        maxdump : Number of events to dump.
    
    '''

    dataname = data["alias"]
    print("==== Dump events from " + data["files"][0] )

    reader = LcioReader.LcioReader()
    # reader = StdHepReader.StdHepReader()
    for infile in data["files"]:
        print("Adding " + infile)
        reader.addFile(infile)

    print("There are " + str(reader.getNumberOfEvents()) + " in this file.")

    for idx, event in enumerate(reader):
        if maxdump > 0 and idx >= maxdump:
            break

        print("\n=== Reading:" + str(idx+1) + "-th record. ==============")
        print("### Event header ",)
        print("    Run number=%d  Event number=%d " % (event.getRunNumber(), event.getEventNumber()))
        print("### Event parameters ")
    #  Dump event parameters 
        strvec = ROOT.vector("string")()  
        params = event.getParameters()
    #### List Float parameter values
        for key in params.getFloatKeys(strvec):
            print("    Float parameters "+str(key)+" = " + str(params.getFloatVal(key)) )
    #### List Int parameter values
        strvec.clear()
        for key in params.getIntKeys(strvec):
            print("    Int parameters "+str(key)+" = " + str(params.getIntVal(key)) )
    #### List String parameter values
        strvec.clear()
        for key in params.getStringKeys(strvec):
            print("    String parameters "+str(key)+" = " + str(params.getStringVal(key)) )


    #  print collections in the event 
        print("### Collections in this event")
        cols = event.getCollectionNames()
        for col in cols:
            print("  "+col)

        pfos = event.getCollection("PFOs")
        print("Number of PFOs elements =" + str(len(pfos)))
     
        # Loop over all elements of MCParticle collection
        # for ip in range(0, mcps.getNumberOfElements()):
        #    mcp = mcps.at(ip)  
        for ip, pfo in enumerate(pfos):
            pv = pfo.getLorentzVec()
            pdgid = pfo.getParticleIDUsed().getPDG() 
            charge = pfo.getCharge()

            # print data
            print("#ip=%d: pdgid=%s charge=%s " % 
                 ( ip, str(pdgid), str(charge) ), end="" )
            print(" (E,px,py,pz)=(%g,%g,%g,%g)" % 
                 ( pv.E(), pv.Px(), pv.Py(), pv.Pz() ) )
    
    del reader  # Remove reader
    
# ====================================================== #
def delphesNtuple( data , maxread=1000, genmeta_json=""):
    '''
    Function: Read maxread of events from data and create a root file of ntuple.  
   
    Inputs:
       data : Dictionay object describing data
              data = {"alias": "alias of data file", "files": ["file1","file2",...]}
       maxread : Number of events to be read from files.
       genmeta_json : A generator meta information in json format.
              If not given, read from os.environ["HOME"]+"/Tutorial/data/genmetaByID.json"
              The standard one is at https://ild.ngt.ndu.ac.jp/CDS/files/genmetaByID.json

    Output: 
       Returns dictionary consists as follows.
       ret = {"cm_energy":Center of mass energy, extracted from the first file name , 
              "cross_section":cross section of this process, 
              "nread":Number of events read from an input stream
              "intlumi":Integrated luminosity of analized events. 
              "rootfile":root_file_name }
       

    '''

    # =======================================================================
    # Preparing to read and analize files
    # =======================================================================
    ##  Create a root file.
    dataname = data["alias"]
    rootfile = dataname + ".root"
    rfile = ROOT.TFile(rootfile, "RECREATE")
    ntev = ROOT.TNtuple("nt",dataname + " analysis", "emum:emup:mmumu:mmiss:mrest")
    print("==== Creating root file " + str(rootfile) )

    ##  Get enrgy and process id from filename

    filemeta = decodeFileName(os.path.basename(data["files"][0]))
    ecm = float(filemeta["E"].split("-")[0])   # Get Energy from file name

    ## Get cross_section from input data or genmeta file.
    if "cross_section" in data:
        cross_section = float(data["cross_section"])
        print("Cross section of input file is %f " % ( cross_section ) )
    else:
    ##  Getcross section from a genmeta json file.
        procid = filemeta["I"] 
        genmeta_json = os.environ["HOME"]+"/Tutorial/data/genmetaByID.json"
        if not os.path.exists(genmeta_json):
           print("ERROR : " + genmeta_json + " does not exist.")
           exit(0)
        genmeta = json.load(open(genmeta_json))
        cross_section = float(genmeta[str(procid)]["cross_section_in_fb"]) 
        print("Cross section of procid %s is %f " % ( procid, cross_section ) )

    # ========================================================================
    # Create reader
    # ========================================================================
    reader = LcioReader.LcioReader()
    #######  reader = StdHepReader.StdHepReader()  # Memory leak ?  Not work to read too many files.
    for infile in data["files"]:
        print("Adding " + infile)
        reader.addFile(infile)

    nbevents = reader.getNumberOfEvents() if maxread == 0 else maxread
    print("There are " + str(nbevents) + " events in this file.")

    # =======================================================================
    # Read events in the file, and fill Ntuple
    # =======================================================================
    nread = 0
    for idx, event in enumerate(reader):
        if maxread > 0 and nread >= maxread:
            print("Reached maxread(%d) at nread=%d" % (maxread, nread))
            break
        nread = nread + 1
        if nread%1000 == 0:
            print(" reading "+str(nread)+"-th event")

        psum = ROOT.TLorentzVector(0.0, 0.0, 0.0, 0.0)
        pmum = ROOT.TLorentzVector(0.0, 0.0, 0.0, 0.0)
        pmup = ROOT.TLorentzVector(0.0, 0.0, 0.0, 0.0)
        pini = ROOT.TLorentzVector(0.0, 0.0, 0.0, ecm)

        pfos = event.getCollection("PFOs")
    
        # Loop over all particle in MCParticle collection.
        # and find mu+ and mu- of the highest energy
        for pfo in event.getCollection("PFOs"):
   #            if pfo.getGeneratorStatus() == 1 :  # select final state particles
                p = pfo.getLorentzVec()
                psum += p
                pdg = pfo.getParticleIDUsed().getPDG()
                if pdg == 13 and p.E() > pmum.E():
                    pmum = p
                if pdg == -13 and p.E() > pmup.E():
                    pmup = p
            
        pmumu = pmum + pmup   
        mumumas = pmumu.M()
        missmas = (pini - pmumu).M()          # Mass recoil to mu+, mu- 
        restmas = ( psum - pmum - pmup ).M()  # Mass other than mu+, mu-

        # Fiil variables in Ntuple
        ntev.Fill(float(pmum.E()), float(pmup.E()), float(mumumas), float(missmas), float(restmas))
 
        if nread >= nbevents :
            print("### Completed last event. Nread is "+str(nread))
            break 
    
    print("### Read "+str(nread)+" events")
    intlumi = float(nread)/cross_section if float(cross_section) > 0.0 else 0.0
    rfile.Write()
    rfile.Close()    # Close root file

    ret = {"cm_energy":ecm, "cross_section":cross_section, "nread":nread, "intlumi":intlumi, 
           "rootfile":rootfile}
    del reader

    return ret

#======================================================
def getDatalist(tutorial=True):  
    '''
    Get the list of input files.
    : params logical tutorial : True to get from ~/Tutorial/data. False to get from KEK group disk
    '''

    if ( tutorial ):
        basepath = "."

        ## NOTE  
        ## Input file name should follow ILC naming convension. 
        ## Namely, at least following meta key and value should exist to 
        ## obtain relevant information from the file name.
        ## 
        ## E<ecm>-<machine_para>.I<process_ID>.<serial_number>.slcio
        datalist = [
        {"alias":"higgs-eLpR", "files":[ "sdelphes.E250-TDR_ws.Pe2e2h.eL.pR.I106479.0.slcio" ]},
        {"alias":"higgs-eRpL", "files":[ "sdelphes.E250-TDR_ws.Pe2e2h.eR.pL.I106480.0.slcio" ]},
        {"alias":"zz_sl-eLpR", "files":[ "sdelphes.E250-TDR_ws.P4f_zz_sl.eL.pR.I106575.0.slcio"]},
        {"alias":"zz_sl-eRpL", "files":[ "sdelphes.E250-TDR_ws.P4f_zz_sl.eR.pL.I106576.0.slcio"]} ]

    return datalist 

#======================================================#
if __name__ == '__main__':
 

    ##### Get list of files to analize.
    datalist = getDatalist()    

    ##### Excersize 1.
    printPFOData(datalist[0])

    ##### Excersize 2
    for ip  in range(0, len(datalist)):
        ret = delphesNtuple( datalist[ip], maxread=0)    # maxread = 0 to read all events in file.
        datalist[ip].update(ret)     
    json.dump(datalist, open("delphes.json","w"))  # Write analysis parameter as json file.

    #####Excersize 3
    datalist = json.load(open("delphes.json"))
    makePlot( datalist )   # makePlot for e2e2anal doesn't work for zprime data    

