
#  For development, do 
#     python -i develop.py 
#  then, interactive session starts after executing this script


import os, pprint
from pyLCIO import EVENT, UTIL
from pyLCIO.io import LcioReader, StdHepReader
import ROOT
ROOT.gROOT.SetBatch()


# basepath = os.environ["HOME"] + "/Tutorial/data"
# infile = basepath + "/E250-TDR_ws.Pe2e2h.Gwhizard-1_95.eL.pR.I106479.001.stdhep"
infile = "sdelphes.E250-TDR_ws.Pe2e2h.eL.pR.I106479.0.slcio"

# reader = StdHepReader.StdHepReader()  # Create reader
reader = LcioReader.LcioReader()  # Create reader
reader.addFile(infile)

reader.skip(5)                        # Skip 5 records
event = reader.next()                 # Get event collection fron next event
params = event.getParameters()        # Get event paraneter
mcps = event.getCollection("MCParticles")  # Get MCParticle collection 
mcp = mcps.at(0)                          # Get element 0 of MCParticle collection

pfos = event.getCollection("PFOs")  # Get PFOs collection 
pfo = pfos.at(0)  # Get PFO

