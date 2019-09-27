
from pyLCIO.io import LcioReader

infile="/".join(["/hsm/ilc/grid/storm/prod/ilc/mc-opt-3/ild/dst-merged/500-TDR_ws/higgs_ffh/ILD_l5_o1_v02/v02-00-01",
                 "rv02-00-01.sv02-00-01.mILD_l5_o1_v02.E500-TDR_ws.I106523.Pnnh.eL.pR.n005.d_dstm_10763_18.slcio"])

reader = LcioReader.LcioReader(infile)
event = reader.next()

reco_mc_links = event.getCollection("RecoMCTruthLink")

lnk = reco_mc_links.getElementAt(0) # Get First element

# help(lnk)  # Get help of link object
# lfrom = lnk.getFrom()
# lweight = lnk.getWeight()
# help(lweight)
# lto = lnk.getTo()
# help(lto)   # Get help of to object

for lnk in reco_mc_links:
   mcp = lnk.getTo()
   weight = lnk.getWeight()
   print "Linked to MCParticle, PDG=" + str(mcp.getPDG()) + "  weight=" + str(weight)

      
