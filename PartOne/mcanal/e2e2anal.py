'''
Sample program to study e1E1 -> e2E2h by python

To run non-interactively, namely run main part of this script, do 

    $ python e2e2anal.py   

To run interactively, do
    $ python
    >> from e2e2anal import *
    >> dir()           # List importted names
    >> help(printData)    # Print help

    >> reader = getReader()
    >> printData(data)  # Print lcio data 

'''

from __future__ import print_function

import os, pprint, glob, json

from pyLCIO.io import LcioReader, StdHepReader
import ROOT
ROOT.gROOT.SetBatch()

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

        mcps = event.getCollection("MCParticle")
        print("Number of MCParticle elements ="+str(len(mcps)))
     
        # Loop over all elements of MCParticle collection
        for ip in range(0, mcps.getNumberOfElements()):
            mcp = mcps.at(ip)
            pv = mcp.getLorentzVec()
            pdgid = mcp.getPDG()
            charge = mcp.getCharge()
            status = mcp.getGeneratorStatus()
            parents = mcp.getParents()
            daughters = mcp.getDaughters()
            nb_daughters = len(daughters)

            # print data
            print("#ip=%d: id=%d pdgid=%d status=%d charge=%d #daughters=%d " % 
                 ( ip, mcp.id(), pdgid, status, charge, nb_daughters ), end="" )
            if len(parents) > 0:
               print(" parents=",end="")
               for parent in parents:
                  print("%d " % parent.id(), end="")
            if nb_daughters > 0:
               print(" daughters:(id,pdg)=",end="")
               for dau in daughters:
                   print("(%d,%d)" % (dau.id(), dau.getPDG()),end="")
            print("")
            print(" (E,px,py,pz)=(%g,%g,%g,%g)" % 
                 ( pv.E(), pv.Px(), pv.Py(), pv.Pz() ) )
    
    del reader  # Remove reader
    
# ====================================================== #
def makeNtuple( data , maxread=1000, genmeta_json=""):
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
    ##  Get enrgy and process id from filename
    filemeta = decodeFileName(os.path.basename(data["files"][0]))
    ecm = float(filemeta["E"].split("-")[0])   # Get Energy from file name
    procid = filemeta["I"]

    ##  Getcross section from a genmeta json file.
    if genmeta_json == "":
       genmeta_json = os.environ["HOME"]+"/Tutorial/data/genmetaByID.json"
    genmeta = json.load(open(genmeta_json))
    cross_section = float(genmeta[str(procid)]["cross_section_in_fb"])
    print("  Cross section of procid %s is %s " % ( procid, cross_section ) )

    ##  Create a root file.
    dataname = data["alias"]
    rootfile = dataname + ".root"
    rfile = ROOT.TFile(rootfile, "RECREATE")
    ntev = ROOT.TNtuple("nt",dataname + " analysis", "emum:emup:mmumu:mmiss:mrest")
    print("==== Creating root file " + str(rootfile) )

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
        pini = ROOT.TLorentzVector(0.0, 0.0, 0.0, ecm)

        mcp = event.getCollection("MCParticle")
    
        # Loop over all particle in MCParticle collection.
        # and find mu+ and mu- of the highest energy
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
        missmas = (pini - pmumu).M()
        restmas = ( psum - pmum - pmup ).M()

        # Fiil variables in Ntuple
        ntev.Fill(float(pmum.E()), float(pmup.E()), float(mumumas), float(missmas), float(restmas))
    
    print("### Read "+str(nread)+" events")
    intlumi = float(nread)/cross_section
    rfile.Write()
    rfile.Close()

    ret = {"cm_energy":ecm, "cross_section":cross_section, "nread":nread, "intlumi":intlumi, 
           "rootfile":rootfile}
    del reader

    return ret
      
#====================================================== #
def makePlot(indata, lumi=2000.0, plotpref="plot"):
    '''
    Function: 
       From rootfile, make plots 
          (1) Missing mass distribution for 80 < M(mu+mu-) < 100
       Results are written in png, pdf, and C(root macro) format. 
  
    Inputs:
       indata  : A dictional data, consists of data created by makeNtuple.
       lumi    : Integrated luminosity to be used for scaling of histograms.
       plotpref : prefix name of output file.
  
    '''
    
    # Get information from input data
    pldata = []
    # Polarization factor for (e-,e+)=(-80%,+30%)
    pol_factor = {"eLpR":0.585, "eRpL":0.035}

    # Get Ntuple from root files
    icol = 1
    for da in indata:
        rec = {}
        rec["alias"] = da["alias"]
        rec["rf"] = ROOT.TFile(da["rootfile"])
        rec["nt"] = rec["rf"].Get("nt")
        rec["scale"] = pol_factor[da["alias"].split("-")[1]]  # Get "eLpR/eRpL" from alias
        rec["scale"] = rec["scale"]*lumi/da["intlumi"]  # Scale factor depending on data statistics and polarization.
        rec["color"] = icol
        rec["nt"].SetLineColor(icol)
        icol = icol + 1
        pldata.append(rec)

    # Create canvas
    c1 = ROOT.TCanvas("c1", "Example", 1000, 1000)
    c1.Divide(1, 2)

    # ===============================================================================
    # Plots of all histogram
    # ===============================================================================
    # Draw uppper figure
    c1.cd(1)
    selection = "mmumu >81.0 && mmumu < 101.0"  # Event selection condition
    nsel = pldata[0]["nt"].Draw("mmiss",selection)
    pldata[0]["hist"] = pldata[0]["nt"].GetHistogram()
    pldata[0]["hist"].Scale(pldata[0]["scale"])
    ROOT.gPad.SetGridx(1)
    ROOT.gPad.SetGridy(1)
    pldata[0]["hist"].SetTitle("Number of events for %d fb^{-1}" % int(lumi))
    pldata[0]["hist"].GetXaxis().SetTitle("Mass recoil to #mu^{+}#mu^{-} GeV/c^2")
    pldata[0]["hist"].GetYaxis().SetTitle("Number of events")

    if len(pldata) > 1:
        for ip in range(1, len(pldata)):
            nsel = pldata[ip]["nt"].Draw("mmiss",selection,"same")
            pldata[ip]["hist"] = pldata[ip]["nt"].GetHistogram()
            pldata[ip]["hist"].Scale(pldata[ip]["scale"])

    xpos = 0.7
    ypos = 0.7
    dy = 0.07
    for ip in range(0, len(pldata)):
       pldata[ip]["label"] = ROOT.TLatex(xpos, ypos, pldata[ip]["alias"])
       pldata[ip]["label"].SetNDC(1)
       pldata[ip]["label"].SetTextColor(pldata[ip]["color"])
       pldata[ip]["label"].Draw("same")
       ypos = ypos - dy
   
    # ===============================================================================
    # Sum eLpR and eRpL hists and create sum hist of higgs and 2f_Z_l
    # ===============================================================================
    plindex = {}
    for ip in range(0, len(pldata)):
      plindex[pldata[ip]["alias"]] = ip 

    # Draw summed scaled histogram in 2nd canvas
    c1.cd(2)
    ROOT.gPad.SetGridx(1)
    ROOT.gPad.SetGridy(1)
    plsum = {}
    plsum["higgs"] = pldata[plindex["higgs-eLpR"]]["hist"] + pldata[plindex["higgs-eRpL"]]["hist"]
    plsum["zz_sl"] = pldata[plindex["zz_sl-eLpR"]]["hist"] + pldata[plindex["zz_sl-eRpL"]]["hist"]
    plsum["higgs + zz_sl"] = plsum["higgs"] + plsum["zz_sl"]

    plsum["zz_sl"].SetFillColor(21)
    plsum["higgs + zz_sl"].SetFillColor(48)
    plsum["higgs + zz_sl"].SetTitle("For Pol(e^{-}=-80%%, e^{+}=+30%%), %5.0f fb^{-1}" % float(lumi))

    plsum["higgs + zz_sl"].Draw("hist")
    plsum["zz_sl"].Draw("hist same")

    # Write labels
    xpos = 0.5
    ypos = 0.7
    dy = 0.07
    lbsum = {}
    for k in ["higgs + zz_sl", "zz_sl"]:
       color = 21 if k == "zz_sl" else 48
       lbsum[k] = ROOT.TLatex(xpos, ypos, k)
       lbsum[k].SetNDC(1)
       lbsum[k].SetTextColor(color)
       lbsum[k].Draw("same")
       ypos = ypos - dy

    # Count number of events in 123 to 130 GeV
    hmin = 123.0
    hmax = 130.0
    ihmin = plsum["zz_sl"].FindBin(hmin)
    ihmax = plsum["zz_sl"].FindBin(hmax)
    bkgevts = plsum["zz_sl"].Integral(ihmin, ihmax)
    ihmin = plsum["higgs + zz_sl"].FindBin(hmin)
    ihmax = plsum["higgs + zz_sl"].FindBin(hmax)
    totevts = plsum["higgs + zz_sl"].Integral(ihmin, ihmax)
    nsignal = totevts - bkgevts
    print("%d signal and %d background events " % (nsignal, bkgevts), end="")
    print("in %5.1f to %5.1f GeV/c^2" % ( hmin, hmax ))

    lbsum["S/N"] = ROOT.TLatex(xpos, ypos, 
        "S/N=%d/%d for M_{recoil} in %4.0f to %4.0f" % (nsignal, bkgevts, hmin, hmax ))
    lbsum["S/N"].SetNDC(1)
    lbsum["S/N"].SetTextColor(1)
    lbsum["S/N"].Draw("same")
    ypos = ypos - dy


    # Print canvas in various format
    c1.Print(plotpref+".png")
    c1.Print(plotpref+".pdf")  
    c1.Print(plotpref+".C")  
  
#======================================================
def getDatalist(tutorial=True):  
    '''
    Get the list of input files.
    : params logical tutorial : True to get from ~/Tutorial/data. False to get from KEK group disk
    '''

    if ( tutorial ):
        basepath = os.environ["HOME"] + "/Tutorial/data"
        datalist = [
        {"alias":"higgs-eLpR", "files":[ basepath + "/E250-TDR_ws.Pe2e2h.Gwhizard-1_95.eL.pR.I106479.001.slcio" ]},
        {"alias":"higgs-eRpL", "files":[ basepath + "/E250-TDR_ws.Pe2e2h.Gwhizard-1_95.eR.pL.I106480.001.slcio" ]},
        {"alias":"zz_sl-eLpR", "files":[ basepath + "/E250-TDR_ws.P4f_zz_sl.Gwhizard-1_95.eL.pR.I106575.001.slcio"]},
        {"alias":"zz_sl-eRpL", "files":[ basepath + "/E250-TDR_ws.P4f_zz_sl.Gwhizard-1_95.eR.pL.I106576.001.slcio"]} ]
 
    else:

        basepath = "/group/ilc/grid/storm/prod/ilc/mc-dbd/generated/250-TDR_ws"
        datalist = [
        {"alias":"higgs-eLpR", "search":basepath + "/higgs/E250-TDR_ws.Pe2e2h.*.eL.pR.I106479.*.stdhep" },
        {"alias":"higgs-eRpL", "search":basepath + "/higgs/E250-TDR_ws.Pe2e2h.*.eR.pL.I106480.*.stdhep" },
        {"alias":"zz_sl-eLpR", "search":basepath + "/4f/E250-TDR_ws.P4f_zz_sl.*.eL.pR.I106575.*.stdhep"},
        {"alias":"zz_sl-eRpL", "search":basepath + "/4f/E250-TDR_ws.P4f_zz_sl.*.eR.pL.I106576.*.stdhep"} ]
        for ip in range(0, len(datalist)):
           datalist[ip]["files"] = sorted(glob.glob(datalist[ip]["search"]))
           print("Found " + str(len(datalist[ip]["files"])) + " files for "+datalist[ip]["alias"])
           if len(datalist[ip]["files"]) == 0:
              print("No files found for " + datalist[ip]["alias"])
              exit(0)
           if "stdhep" in ",".join(datalist[ip]["files"]):
              print("Reading stdhep is disabled because of a memory leak.")
              exit(0)
           

    return datalist 

#======================================================#
if __name__ == '__main__':


    # Get list of files to analize.
    datalist = getDatalist()    

    # Excersize 1.
    printData(datalist[0])

    # Excersize 2
    #for ip  in range(0, len(datalist)):
    #   ret = makeNtuple( datalist[ip], maxread=0)    # maxread = 0 to read all events in file.
    #   datalist[ip].update(ret)     
    #json.dump(datalist, open("e2e2anal.json","w"))  # Write analysis parameter as json file.

    # Excersize 3
    # datalist = json.load(open("e2e2anal.json"))
    # makePlot( datalist )    

