
#  For development, do 
#     python -i develop.py 
#  then, interactive session starts after executing this script


import os, pprint
from pyLCIO.io import LcioReader, StdHepReader
import ROOT
ROOT.gROOT.SetBatch()


basepath = os.environ["HOME"] + "/Tutorial/data"
infile = basepath + "/E250-TDR_ws.Pe2e2h.Gwhizard-1_95.eL.pR.I106479.001.stdhep"

reader = StdHepReader.StdHepReader()
reader.addFile(infile)

reader.skip(5)
event = reader.next()
params = event.getParameters()
mcps = event.getCollection("MCParticle")
mcp = mcps.at(0)


