'''
Sample program to read lcio file and create root file.

To run non-interactively, 

  $ python lcio_ntuple.py  

Some help of function could be obtained by for example,

  $ python 
  >> import ROOT
  >> help(ROOT.TLorentzVector)
  >>
  >> import pyLCIO
  >> dir(pyLCIO.EVENT)
  >> help(pyLCIO.Event.ReconstructedParticle)


'''

import os
import ROOT
ROOT.gROOT.SetBatch()
import pprint


#======================================================#
if __name__ == '__main__':

  tf = ROOT.TFile("ntuple.root")
  nt = tf.Get("nt")

  nevt = nt.GetEntries()
  print "There are "+str(nevt)+" entries"

  c1 = ROOT.TCanvas("c1","CosTheta distribution",600,600)
  th = ROOT.TH1F("th","CosTheta distribution",100,-1.0, 1.0)

  for ievt in range(0, long(nevt)):
      nt.GetEntry(ievt)

      if nt.ptype == 22:
          p = ROOT.TLorentzVector(nt.px, nt.py, nt.pz, nt.e)
          cs = p.CosTheta()
          th.Fill(cs)

  th.Draw()
  c1.Print("costheta.png")
      

