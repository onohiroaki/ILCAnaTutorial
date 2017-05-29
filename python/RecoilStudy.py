'''
Sample program to study e1E1 -> e2E2h by python

To run non-interactively, namely run main part of this script, do 

  $ python RecoilStudy.py  


To run interactively, do
  $ python 
  >> import RecoilStudy
  >> reader = getInputFile()

  >> help(RecoilStudY)          # show help
  >> examplePrintEvent(reader)  # Execute examplePrintEvent


'''

from pyLCIO.io import LcioReader, StdHepReader

import ROOT
# ROOT.gROOT.SetBatch()

import pprint

# ====================================================== #
def getReader(datafile='rv01-16-p10_250.sv01-14-01-p00.mILD_o1_v05.E250-TDR_ws.I106479.Pe2e2h.eL.pR-00001-DST.slcio', 
   datadir = '/hsm/ilc/grid/storm/prod/ilc/mc-dbd/ild/dst-merged/250-TDR_ws/higgs_ffh/ILD_o1_v05/v01-16-p10_250/'):
  '''
  Returns LcioReader of input file.   Prepared for interactive use.

  :params string datafile : input filename. The default is 
  :params string datadir  : directory of input file. The default is  
  '''
  inputpath = datadir+datafile
  return LcioReader.LcioReader(inputpath)

# ====================================================== #
def examplePrintEvent(reader, maxRead=5):
  ''' 
  Example to access basic information in the DST file 

  :param LcioReader reader: LcioReader object for input file.
  :param int maxRead: Number of events to read.

  '''

  for idx, event in enumerate(reader):
    if maxRead > 0 and idx >= maxRead:
      break

    print "\n### Reading event:" + str(idx+1)
    ''' print collections in the event '''
    cols = event.getCollectionNames()
    for col in cols:
      print "  "+col

    pfos = event.getCollection("PandoraPFOs")
    print " # of PFO Objects ="+str(len(pfos))

    # pfo = pfos.at(0) # Get first element in PandoraPFOs collection

    print "PFO: PID Charge  Px pY Pz E "
    for pfo in pfos:

      p = pfo.getLorentzVec()
      ene = pfo.getEnergy()
      ch  = pfo.getCharge()
      ptype = pfo.getType()

      print "    ",
      print pfo.getType(),
      print pfo.getCharge(),
     
      print str(p.X())+" "+str(p.Y())+" "+str(p.Z()),
      print ene

# ====================================================== #
def makeNtuple(reader, rootFile="anal.root", ecm=250.0, maxRead=1000):
  '''
  Analize reader file and create a root Ntuple file   

  :params LcioReader reader : reader for an input file
  :params string rootFile: a root file name to write ntuple
  :params float ecm: nominal CM energy 
  :params int maxRead: max number of events to read

  '''
  rfile = ROOT.TFile(rootFile, "recreate")
  nt = ROOT.TNtuple("nt","e2E2h analysis", "nminus:nplus:mas:mm")

  for idx, event in enumerate(reader):
    if maxRead > 0 and idx >= maxRead:
      break
    
    psum = ROOT.TLorentzVector(0.0, 0.0, 0.0, 0.0)
    pfos = event.getCollection("PandoraPFOs")
    nminus = 0
    nplus = 0

    for pfo in pfos:
      p = pfo.getLorentzVec()
      ptype = pfo.getType()
      pabs = p.P()
      if abs(ptype) == 13 and pabs > 10.0 :
        if ptype == 13 and nminus == 0:
          psum += p
          nminus = 1
        if ptype == -13 and nplus == 0:
          psum += p
          nplus = 1
     
    pini = ROOT.TLorentzVector(0.0, 0.0, 0.0, ecm)
    pmis = pini - psum
    missmass = pmis.M()
    mumumass = psum.M()
    nt.Fill(float(nminus), float(nplus), mumumass, missmass )

  print "### Last event was "+str(idx)
  rfile.Write()
  rfile.Close()
    
#====================================================== #
def makePlots(rootfile="anal.root", pngfile="plots.png"):
  '''
  From rootfile, make plots of mumu mass and missing mass 

  :params string rootfile : Root file name whose data are plotted
  :params string pngfile : plot file name

  '''
  rfile = ROOT.TFile(rootfile)
  nt = rfile.Get("nt")

  c1 = ROOT.TCanvas("c1")
  c1.Divide(1, 2)
  c1.cd(1)
  nt.Draw("mas")

  c1.cd(2)
  nt.Draw("mm")
  
  c1.Print(pngfile)  
  rfile.Close()


#======================================================#
if __name__ == '__main__':

  reader = getReader()

#  examplePrintEvent(reader)

  makeNtuple(reader)

  makePlots()
