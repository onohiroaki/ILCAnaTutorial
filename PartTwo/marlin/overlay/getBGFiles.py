#!/bin/env python 
# #######################################################
# Function:
#   Print a list of background files.
# Usage:
#   getBGFile <type> <Nsig>
#     <type> : Background file type. Possible values are
#              ww, wb, bw, bb, pairs
#     <Nsig> : Number of signal events. Number of BG files 
#              selected will include at least Nsig*NbgExp events.
# ########################################################       

import os
import sys
import glob
import random

# ########################################################
def getBGFile( bg_type, nsig ):

    bgdata={"ww":["aa_lowpt_WW/ILD_l5_v02/v02-02/00015330",0.1256495436,150],
            "wb":["aa_lowpt_WB/ILD_l5_v02/v02-02/00015325",0.297459204,300],
            "bw":["aa_lowpt_BW/ILD_l5_v02/v02-02/00015324",0.29722665,300],
            "bb":["aa_lowpt_BB/ILD_l5_v02/v02-02/00015323",0.829787685,600],
            "pairs":["seeablepairs/ILD_l5_v02/v02-02/00015322",1.0,600]}
    basedir="/group/ilc/grid/storm/prod/ilc/mc-2020/ild/sim/250-SetA"

    bgfiles = glob.glob("/".join([basedir, bgdata[bg_type][0], "*","*.slcio"]))
    nbg = len(bgfiles)
    nfiles = int((float(nsig)*float(bgdata[bg_type][1])+1.0)/float(bgdata[bg_type][2])+1.0)
    nfiles = nfiles if nfiles > 0 else 1   
    selfiles = []
    npick = 0
    while len(selfiles) < nfiles:
        ip = random.randint(0, nbg-1)
        if not bgfiles[ip] in selfiles:
            selfiles.append(bgfiles[ip])     

    return selfiles

# ########################################################
if __name__ == "__main__":

    bg_type = sys.argv[1]
    nsig = sys.argv[2]
 
    # print("bg_type="+bg_type+" nsig="+nsig)

    print(" ".join(getBGFile(bg_type, nsig)))

