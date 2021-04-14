'''
Sample program to study e1E1 -> e2E2h by python

To run non-interactively, namely run main part of this script, do 

    $ python RecoilStudy.py  


To run interactively, do
    $ python 
    >> from RecoilStudy import *
    >> dir()           # List importted names
    >> help(examplePrintEvent)    # Print help  

    >> reader = getReader()  
    >> examplePrintEvent(reader)  # Execute examplePrintEvent
  

'''

import os
import pprint

from pyLCIO.io import LcioReader, StdHepReader

import ROOT
ROOT.gROOT.SetBatch()

import json
GENMETA = json.load(open(os.environ["HOME"]+"/Tutorial/data/genmetaByID.json"))

# ====================================================== 
def decodeFileName(filename):
    '''
    Decode file name and return {key:value} dictionary data
    '''
    
    meta = {}
    fsplit = filename.split('.')
    for key in fsplit[:-2]:
       meta[key[0:1]] = key[1:]

    meta["n"] = fsplit[-2]
    meta["f"] = fsplit[-1]

    return meta

# ====================================================== 
def printData(data, maxdump=1):
    ''' 
    print data  
   
    :param data : Dictionay object describing data
                  data = {"alias": "alias of data file", "files": ["file1","file2",...] }
    :param maxdump : Number of events to dump.
    
    '''

    dataname = data["alias"]
    print("==== Dump events from " + data["files"][0] )

    # reader = LcioReader.LcioReader()
    reader = StdHepReader.StdHepReader()
    for infile in data["files"]:
        print "Reading " + infile
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


        ''' print collections in the event '''
        print("### Collections in this event")
        cols = event.getCollectionNames()
        for col in cols:
            print("  "+col)

        mcps = event.getCollection("MCParticle")
        print("Number of MCParticle elements ="+str(len(mcps)))
        print("Dump first 4 particle files.")
        for ip in range(0, mcps.getNumberOfElements()):
            mcp = mcps.at(ip)
            print("ip="+str(ip))
            pv = mcp.getLorentzVec()
            pdgid = mcp.getPDG()
            charge = mcp.getCharge()
            status = mcp.getGeneratorStatus()
            parents = mcp.getParents()
            daughters = mcp.getDaughters()
            nb_daughters = len(daughters)
            print(" pdgid=%d status=%d charge=%d #daughters=%d " % 
                 ( pdgid, status, charge, nb_daughters ) )
            print(" (E,px,py,pz)=(%g,%g,%g,%g)" % 
                 ( pv.E(), pv.Px(), pv.Py(), pv.Pz() ) )
    
    del reader  # Remove reader
    
# ====================================================== #
def makeNtuple( data , maxread=10):
    '''
    print data  
   
    :param data : Dictionay object describing data
                  data = {"alias": "alias of data file", "files": ["file1","file2",...] }
    :param maxread : Number of events to read.
    
    '''

    MAX_COSTH = 0.90

    dataname = data["alias"]
    rootfile = dataname + ".root"
    rfile = ROOT.TFile(rootfile, "RECREATE")
    ntev = ROOT.TNtuple("nt",dataname + " analysis", "emum:emup:mmumu:mmiss:mrest")
    print("==== Creating root file " + str(rootfile) )

    # Get cross section and enrgy from filename
    filemeta = decodeFileName(os.path.basename(data["files"][0]))
    ecm = float(filemeta["E"].split("-")[0])   # Get Energy from file name
    procid = filemeta["I"]
    cross_section = GENMETA[str(procid)]["cross_section_in_fb"]
    print("  Cross section of procid %s is %s " % ( procid, cross_section ) )

    # reader = LcioReader.LcioReader()
    reader = StdHepReader.StdHepReader()
    for infile in data["files"]:
        print "Reading " + infile
        reader.addFile(infile)

    nbevents = reader.getNumberOfEvents() if maxread == 0 else maxread
    print("There are " + str(nbevents) + " events in this file.")

    for idx, event in enumerate(reader):
        print(" idx="+str(idx))
        if not event:
           print("Read EOF at index="+str(idx))
           break
        if maxread > 0 and idx > maxread:
           print("Reached maxread(%d) at idx=%d" % (maxread, idx))
           break
        
        psum = ROOT.TLorentzVector(0.0, 0.0, 0.0, 0.0)
        pmum = ROOT.TLorentzVector(0.0, 0.0, 0.0, 0.0)
        pmup = ROOT.TLorentzVector(0.0, 0.0, 0.0, 0.0)
        mcp = event.getCollection("MCParticle")
    
        for mcp in event.getCollection("MCParticle"):
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
        pini = ROOT.TLorentzVector(0.0, 0.0, 0.0, ecm)
        missmas = (pini - pmumu).M()
        restmas = ( psum - pmum - pmup ).M()

        ntev.Fill(float(pmum.E()), float(pmup.E()), float(mumumas), float(missmas), float(restmas))
    
    print "### Last event was "+str(idx)
    rfile.Write()
    rfile.Close()

    del reader
      
#====================================================== #
def makePlots(plotdata, pngfile="plots.png"):
    '''
    From rootfile, make plots of mumu mass and missing mass 
  
    :params string plotdata : dict object of root file name and plot options ( {"rootfile":  , "option":   }
    :params string pngfile : plot file name
  
    '''
    
    data = []
    # rfs = []
    # nts = []
    # data = copy.deepcopy(plotdata)
    # Get TNtuple objects from ROOT files
    for pldata in sorted(plotdata):
        rf = pldata["rootfile"]
        opts = pldata["option"]
        rec = {}
        rec["rf"] = ROOT.TFile(rf)
        rec["nt"] = rec["rf"].Get("nt")
        rec["nt"].SetLineColor(opts["color"])
        rec["opts"] = opts
        data.append(rec)

    c1 = ROOT.TCanvas("c1", "Example", 800, 800)
    c1.Divide(1, 2)

    # Draw uppper figure
    c1.cd(1)
    selection = "mas>80.0 && mas < 120.0"
    nent = data[0]["nt"].GetEntries()
    nsel = data[0]["nt"].Draw("mas",selection)
    ROOT.gPad.SetGridx(1)
    ROOT.gPad.SetGridy(1)
    data[0]["eff"] = float(nsel)/float(nent)*100.0
    if len(data) > 1:
        for da in data[1:]:
            nent = da["nt"].GetEntries()
            nsel = da["nt"].Draw("mas",selection,"same")
            da["eff"] = float(nsel)/float(nent)*100.0
    for da in data:
        print "%8.4f" % da["eff"]
 

    xpos = 0.7
    ypos = 0.75
    tobj1 = []
    for da in data:
       text = "%s : Eff=%8.2f %%" % (da["opts"]["legend"], da["eff"])
       ypos -= 0.05
       tobj1.append(ROOT.TLatex(xpos, ypos, text))
       tobj1[-1].SetTextColor(da["opts"]["color"])
       tobj1[-1].SetNDC(True)
       tobj1[-1].Draw()
    
    # Draw second figure
    c1.cd(2)
    selection = "mm>100.0 && mm < 500.0"
    nent = data[0]["nt"].GetEntries()
    nsel = data[0]["nt"].Draw("mm",selection)
    ROOT.gPad.SetGridx(1)
    ROOT.gPad.SetGridy(1)
    data[0]["eff"] = float(nsel)/float(nent)*100.0
    if len(data) > 1:
        for da in data[1:]:
            nent = da["nt"].GetEntries()
            nsel = da["nt"].Draw("mm",selection,"same")
            da["eff"] = float(nsel)/float(nent)*100.0

    xpos = 0.7
    ypos = 0.75
    tobj2 = []
    for da in data:
       text = "%s : Eff=%8.2f %%" % (da["opts"]["legend"], da["eff"])
       ypos -= 0.05
       tobj2.append(ROOT.TLatex(xpos, ypos, text))
       tobj2[-1].SetTextColor(da["opts"]["color"])
       tobj2[-1].SetNDC(True)
       tobj2[-1].Draw()
    # Write results to a file.
    c1.Print(pngfile)  
  
  

#======================================================#
if __name__ == '__main__':

    basepath = os.environ["HOME"] + "/Tutorial/data"

            
    datalist = [
   {"alias":"higgs-eLpR", "files":[ basepath + "/E250-TDR_ws.Pe2e2h.Gwhizard-1_95.eL.pR.I106479.001.stdhep" ]},
   {"alias":"higgs-eRpL", "files":[ basepath + "/E250-TDR_ws.Pe2e2h.Gwhizard-1_95.eR.pL.I106480.001.stdhep" ]},
   {"alias":"zz_sl-eLpR", "files":[ basepath + "/E250-TDR_ws.P4f_zz_sl.Gwhizard-1_95.eL.pR.I106575.001.stdhep"]},
   {"alias":"zz_sl-eRpL", "files":[ basepath + "/E250-TDR_ws.P4f_zz_sl.Gwhizard-1_95.eR.pL.I106576.001.stdhep"]} ]


    do_anal = True
    maxread = 8996
    # maxread = 100

    # printData(datalist[0], maxdump=5)

    makeNtuple( datalist[0] , maxread=0)

