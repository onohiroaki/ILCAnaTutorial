
#  For development, do 
#     python -i develop.py 
#  then, interactive session starts after executing this script


import os, pprint
from pyLCIO.io import LcioReader, StdHepReader
import ROOT
ROOT.gROOT.SetBatch()


basepath = os.environ["HOME"] + "/Tutorial/data"
infile = basepath + "/E250-TDR_ws.Pe2e2h.Gwhizard-1_95.eL.pR.I106479.001.stdhep"

reader = StdHepReader.StdHepReader()  # Create reader
reader.addFile(infile)

reader.skip(5)                        # Skip 5 records
event = reader.next()                 # Get event collection fron next event
params = event.getParameters()        # Get event paraneter
mcps = event.getCollection("MCParticle")  # Get MCParticle collection 
mcp = mcps.at(0)                          # Get element 0 of MCParticle collection


