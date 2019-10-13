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

from pyLCIO import UTIL, EVENT, IMPL, IO, IOIMPL
from pyLCIO.io import LcioReader, StdHepReader

import os
import ROOT
ROOT.gROOT.SetBatch()
import pprint


#======================================================#
if __name__ == '__main__':

  # reader = getReader()
  datadir = "/hsm/ilc/grid/storm/prod/ilc/mc-opt-3/ild/dst-merged/1-calib/single/ILD_l5_o1_v02_nobg/v02-00-01/"
  # infile = "rv02-00-01.sv02-00-01.mILD_l5_o1_v02_nobg.E1-calib.I110131.Ps_22_p010_t5-14.e0.p0.n001.d_dstm_10752_0.slcio"
  infile = "rv02-00-01.sv02-00-01.mILD_l5_o1_v02_nobg.E1-calib.I110141.Ps_22_p010.e0.p0.n001.d_dstm_10752_0.slcio"
  fullpath = datadir + infile
  if not os.path.exists(fullpath):
      print "Error: input file, "+fullpath+" does not exist."
      exit(-1)

  reader = LcioReader.LcioReader(fullpath)
  maxevt = reader.getNumberOfEvents()
  print "There are " + str(maxevt) + " events in the file."

  tf = ROOT.TFile("ntuple.root","recreate")
  nt = ROOT.TNtuple("nt","sample ntuple","nevt:chg:ptype:e:px:py:pz")

  maxread = 1000
  nevt = 0
  
  for idx, event in enumerate(reader):
      ''' print collections in the event '''

      if nevt >= maxread:
         break 
      nevt += 1
      if nevt%100 == 0:
         print "### Reading event:" + str(nevt)

      pfos = event.getCollection("PandoraPFOs")
       
      for pfo in pfos:
          p = pfo.getLorentzVec()
          ptype = pfo.getType()
          charge = pfo.getCharge()
          ene = pfo.getEnergy()
          momvec = pfo.getMomentumVec()  # get TVector3
          px = momvec.Px()
          py = momvec.Py()
          pz = momvec.Pz()

          nt.Fill(float(nevt), float(charge), float(ptype), float(ene), 
                  float(px), float(py), float(pz))

  
  tf.Write()
  print "Wrote " + str(nevt) + " events in the ntuple"

  
