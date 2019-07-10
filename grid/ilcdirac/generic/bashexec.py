
import pprint

from DIRAC.Core.Base import Script
Script.parseCommandLine()
from ILCDIRAC.Interfaces.API.NewInterface.UserJob import UserJob
from ILCDIRAC.Interfaces.API.NewInterface.Applications import GenericApplication
from ILCDIRAC.Interfaces.API.DiracILC import DiracILC

datadir="/ilc/prod/ilc/mc-opt-3/ild/dst-merged/500-TDR_ws/higgs_ffh/ILD_l5_o1_v02/v02-00-01/"
filepref="rv02-00-01.sv02-00-01.mILD_l5_o1_v02.E500-TDR_ws.I106523.Pnnh.eL.pR.n001.d_dstm_10763_"
indata=[datadir+filepref+"0.slcio", datadir+filepref+"1.slcio"]

d= DiracILC(True,"repo.rep")

################################################
j = UserJob()
j.setJobGroup("Tutorial")
j.setName("GenericExec")
j.setInputSandbox(["mypre.sh", "myanal.sh"])
j.setInputData(indata)

################################################
appre = GenericApplication()
appre.setScript("mypre.sh")
appre.setArguments("This is input arguments")
res=j.append(appre)
if not res['OK']:
  print res['Message']
  exit(1)

################################################
appost = GenericApplication()
appost.setScript("myanal.sh")
appost.setArguments("This is my analysis step")
res=j.append(appost)
if not res['OK']:
  print res['Message']
  exit(1)


# j.setOutputData( [outfile1, outputfile2],"mydir","dest_se_name")
j.setOutputSandbox(["*.log","*.tar.gz","*.sh"])
j.dontPromptMe()
# j.submit(d, mode="local")
res = j.submit(d)
if res['OK']:
    print "Dirac job, "+str(res["Value"])+", was submitted."
else:
    print "Failed to submit Dirac job. return message was as follows."
    pprint.pprint(res)

