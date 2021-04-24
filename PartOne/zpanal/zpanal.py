'''
Analize e1 E1 --> e2 E2 zprime sample
Reusing mcanal/e2e2anal.py 

'''

from __future__ import print_function
import sys, os, json

# Put PartOne/mcanal/e2e2anal.py to PYTHONPATH environment parameter
sys.path.append(os.environ["HOME"]+"/Tutorial/PartOne/mcanal")
from e2e2anal import *

#======================================================
def getDatalist(tutorial=True):  
    '''
    Get the list of input files.
    : params logical tutorial : True to get from ~/Tutorial/data. False to get from KEK group disk
    '''

    if ( tutorial ):
        basepath = os.environ["HOME"] + "/Tutorial/PartOne/whizard2/zprime/run"
        datalist = [{"alias":"zprime", 
                    "cross_section":10258.906,  # Provide cross section data, which is not in genmeta json
                    "files":[basepath+"/E250-SetA.P2f_zp180_mumu.Gwhizard-2_8_5.eL.pR.slcio"]}]

    return datalist 

#======================================================#
if __name__ == '__main__':
 

    ##### Get list of files to analize.
    datalist = getDatalist()    

    ##### Excersize 1.
    # printData(datalist[0])

    ##### Excersize 2
    for ip  in range(0, len(datalist)):
        ret = makeNtuple( datalist[ip], maxread=0)    # maxread = 0 to read all events in file.
        datalist[ip].update(ret)     
    json.dump(datalist, open("zpanal.json","w"))  # Write analysis parameter as json file.

    #####Excersize 3
    # datalist = json.load(open("zpanal.json"))
    # makePlot( datalist )   # makePlot for e2e2anal doesn't work for zprime data    

