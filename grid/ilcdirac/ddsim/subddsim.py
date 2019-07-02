# ##########################################################################
#
# Example to submit DDSim job  to ILCDirac, as an User job.
# 
# To submit, 
#     python subddsim.py 
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
        self.inputFile = "lfn:/ilc/user/a/amiyamot/testjob/2019-07/E500.P2f_bB.GWhizard2.I100000.e0.p0.n001.slcio"
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

    def setInputFile( self, opt ):
        self.inputFile = opt
        gLogger.info("Input file is %s" % self.inputFile)
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
        Script.registerSwitch('n:','number_of_events:', 'Number of events to simulate', self.setNumberOfEvents )
        Script.registerSwitch('i:', 'InputFile:', 'Input file name', self.setInputFile)
        Script.registerSwitch('f:', 'OutputFile:', 'Output file name', self.setOutputFile)
        Script.registerSwitch('w:', 'WriteDir:', 'Output directory. No output, if not given', self.setOutputDir)

        msg = '%s [options]\n' % Script.scriptName
        msg += 'Function: Submit ddsim job'
        Script.setUsageMessage(msg)

# ######################################
# global variables to hold command line parameters
# ######################################
_clip = _Params()
_clip.registerSwitches()
Script.parseCommandLine()

from ILCDIRAC.Interfaces.API.NewInterface.UserJob import UserJob
from ILCDIRAC.Interfaces.API.NewInterface.Applications import DDSim
from ILCDIRAC.Interfaces.API.DiracILC import DiracILC

# ######################################
def subDDSim():

    # Decide parameters for a job
    outputSE = "KEK-SRM"

    isLocal = _clip.isLocal    
    nbevts = 10 if _clip.numberOfEvents == 0 else _clip.numberOfEvents
    outputFile="ddsim_example.slcio" if _clip.outputFile == "" else _clip.outputFile
    outputDir = _clip.outputDir
    inputFile = _clip.inputFile
    if inputFile == "":
        gLogger.error("Input file for ddsim does not given.")
        exit(-1)

    # Create DIRAC objects for job submission

    dIlc = DiracILC()

    job = UserJob()
    job.setJobGroup( "myddsimjob" )
    job.setName( "myddsim" )
    job.setOutputSandbox(['*.log', '*.sh', '*.py', '*.xml'])
    job.setILDConfig("v02-00-02")

    # job.setInputSandbox(["a6-parameters.sin", "P2f_qqbar.sin"])
    # job.setDestination(["LCG.KEK.jp", "LCG.DESY-HH.de"])  # job submission destination
    job.setBannedSites(["LCG.UKI-SOUTHGRID-RALPP.uk"])      # a list of sites not to submit job
    # job.setCPUTime( cputime_limit_in_seconds_by_dirac_units )  
    
    ddsim = DDSim()
    ddsim.setVersion("ILCSoft-02-00-02_gcc49")
    ddsim.setDetectorModel("ILD_l5_v02")
    ddsim.setInputFile(inputFile)
    ddsim.setNumberOfEvents(nbevts)
    extraCLIArguments =  " --steeringFile ddsim_steer.py "
    extraCLIArguments += " --outputFile %s " % outputFile
    extraCLIArguments += " --vertexSigma 0.0 0.0 0.1968 0.0 --vertexOffset 0.0 0.0 0.0 0.0 "
    ddsim.setExtraCLIArguments( extraCLIArguments )

    # ddsim.setRandomSeed(1234565)
    # ddsim.setStartFrom(20)        # Number of events to skip before starting ddsim

    job.append(ddsim)

    if outputDir != "":
        job.setOutputData( [outputFile], OutputPath = outputDir, OutputSE = outputSE )

    if isLocal:
        job.submit(dIlc, mode="local")
    else:
        job.submit(dIlc)

# ######################################
if __name__ == "__main__":

    subDDSim()

