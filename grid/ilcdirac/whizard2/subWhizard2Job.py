# ##########################################################################
#
# Example to submit Whizard2 to ILCDirac, as an User job.
# 
# To submit, 
#     python subWhizard2Job.py 
#
# Modify sindarin file and subWhizard2 function below prpperly 
# in order to generate events you want.
#
# A. Miyamoto, 1-July-2019
#
# ###########################################################################

from DIRAC.Core.Base import Script
from DIRAC import gLogger, S_OK, S_ERROR

# ######################################
class _Params():
    def __init__(self):
        self.isLocal = False
        self.numberOfEvents = 0
        self.outputFile = ""
        self.outputDir = ""

    def setLocal( self, opt ):
        self.isLocal = True
        gLogger.info("Script is executed locally")
        return S_OK()

    def setNumberOfEvents( self, opt ):
        self.numberOfEvents = int(opt)
        gLogger.info("Number of events is %d" % self.numberOfEvents)
        return S_OK()

    def setOutputFile( self, opt ):
        self.outputFile = opt
        gLogger.info("Output file is %s" % self.outputFile)
        return S_OK()

    def setOutputDir( self, opt ):
        self.outputDir = opt
        gLogger.info("Output file is written at %s" % self.outputDir)
        return S_OK()

    def registerSwitches(self):
        Script.registerSwitch('l','local', 'If given, execute locally', self.setLocal )
        Script.registerSwitch('n:','number_of_events:', 'Number of events to generate', self.setNumberOfEvents )
        Script.registerSwitch('f:', 'OutputFile:', 'Output file name', self.setOutputFile)
        Script.registerSwitch('w:', 'WriteDir:', 'Output directory. No output, if not given', self.setOutputDir)

        msg = '%s [options]\n' % Script.scriptName
        msg += 'Function: Submit Whizard2 job'
        Script.setUsageMessage(msg)

# ######################################
# global variables to hold command line parameters
# ######################################
_clip = _Params()
_clip.registerSwitches()
Script.parseCommandLine()

# ######################################
def subWhizard2():

    from ILCDIRAC.Interfaces.API.DiracILC import DiracILC
    from ILCDIRAC.Interfaces.API.NewInterface.UserJob import UserJob
    from ILCDIRAC.Interfaces.API.NewInterface.Applications import Marlin, Whizard2

    # Decide parameters for a job
    outputSE = "KEK-SRM"

    isLocal = _clip.isLocal    
    nbevts = 50 if _clip.numberOfEvents == 0 else _clip.numberOfEvents
    outputFile="E500.P2f_bB.GWhizard2.I100000.e0.p0.n001.slcio" if _clip.outputFile == "" else _clip.outputFile
    outputDir = _clip.outputDir

    # Create DIRAC objects for job submission

    dIlc = DiracILC()

    job = UserJob()
    job.setInputSandbox(["pythia6-parameters.sin", "P2f_qqbar.sin"])
    job.setOutputSandbox(['*.log', '*.sh', '*.py', '*.xml'])
    job.setOutputData( [outputFile] )
    job.setJobGroup( "myWhiz2" )
    job.setName( "MyWhizard2" )
    
    whiz = Whizard2()
    whiz.setVersion("2.7.0")
    whiz.setNumberOfEvents(nbevts)
    whiz.setEvtType("P2f_bB")
    whiz.setProcessVariables("P2f_bB")
    # whiz.setRandomSeed(15)
    whiz.setSinFile("P2f_qqbar.sin")
    whiz.setOutputFile(outputFile)
    job.append(whiz)

    if outputDir != "":
        print " outputDir = " + outputDir
        print " outputSE = " + outputSE
        job.setOutputData( [outputFile], OutputPath = outputDir, OutputSE = outputSE )

    if isLocal:
        job.submit(dIlc, mode="local")
    else:
        job.submit(dIlc)

# ######################################
if __name__ == "__main__":

    subWhizard2()
