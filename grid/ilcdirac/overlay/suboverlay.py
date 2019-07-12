# ##########################################################################
#
# Example to submit Marlin job  to ILCDirac, as an User job.
# 
# To submit, 
#     python submarlin.py 
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
        self.inputFile = "lfn:/ilc/user/a/amiyamot/testjob/2019-07/ddsim_example.slcio"
        self.outputFilePrefix = ""
        self.outputDir = ""
        self.doOverlay = True

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

    def setOutputFilePrefix( self, opt ):
        self.outputFilePrefix = opt
        gLogger.info("Output file prefix is %s" % self.outputFilePrefix)
        return S_OK()

    def setOutputDir( self, opt ):
        self.outputDir = opt
        gLogger.info("Output file is written at %s" % self.outputDir)
        return S_OK()

    def setDoOverlay( self, opt ):
        self.doOverlay = True
        gLogger.info("Output file is written at %s" % self.outputDir)
        # gLogger.warning("Do overlay background is requested, but this function is not implemente yet.")
        return S_OK()

    def registerSwitches(self):
        Script.registerSwitch('l','local', 'If given, execute locally', self.setLocal )
        # Script.registerSwitch('n:','number_of_events:', 'Number of events to simulate', self.setNumberOfEvents )
        Script.registerSwitch('i:', 'InputFile:', 'Input file name', self.setInputFile)
        Script.registerSwitch('f:', 'OutputFilePrefix:', 'Output file prefix', self.setOutputFilePrefix)
        Script.registerSwitch('w:', 'WriteDir:', 'Output directory. No output, if not given', self.setOutputDir)
        # Script.registerSwitch('O', 'Overlay', 'Overlay background data ', self.setDoOverlay)

        msg = '%s [options]\n' % Script.scriptName
        msg += 'Function: Submit a job for overlay reconstruction'
        Script.setUsageMessage(msg)

# ######################################
# global variables to hold command line parameters
# ######################################
_clip = _Params()
_clip.registerSwitches()
Script.parseCommandLine()

from ILCDIRAC.Interfaces.API.NewInterface.UserJob import UserJob
from ILCDIRAC.Interfaces.API.NewInterface.Applications import Marlin, OverlayInput
from ILCDIRAC.Interfaces.API.DiracILC import DiracILC

# ######################################
def subOverlay():

    # Decide parameters for a job
    outputSE = "KEK-SRM"

    isLocal = _clip.isLocal    
    nbevts = 50 if _clip.numberOfEvents == 0 else _clip.numberOfEvents
    outputFilePrefix="overlay_example" if _clip.outputFilePrefix == "" else _clip.outputFilePrefix
    outputDir = _clip.outputDir
    inputFile = _clip.inputFile
    if inputFile == "":
        gLogger.error("Input file for ddsim does not given.")
        exit(-1)

    recfile = outputFilePrefix + ".rec.slcio"
    dstfile = outputFilePrefix + ".dst.slcio"
    detector_model = "ILD_l5_o1_v02"
    key = detector_model.split('_')
    sim_detectorModel = "_".join([key[0], key[1], key[3]])

    # Create DIRAC objects for job submission

    dIlc = DiracILC()

    job = UserJob()
    job.setJobGroup( "myoverlayjob" )
    job.setName( "myoverlay" )
    job.setOutputSandbox(['*.log', '*.sh', '*.py', '*.xml'])
    job.setILDConfig("v02-00-02")

    # job.setInputSandbox(["a6-parameters.sin", "P2f_qqbar.sin"])
    # job.setDestination(["LCG.KEK.jp", "LCG.DESY-HH.de"])  # job submission destination
    # job.setBannedSites([])         # a list of sites not to submit job
    # job.setCPUTime( cputime_limit_in_seconds_by_dirac_units )  
    
    # Create Overlay application
    ovldata = [
    {"ProcessorName":"BgOverlayWW", "evttype":"aa_lowpt_WW", "ProdID":10237, "expBG":0.211, "subdir":"000"},
    {"ProcessorName":"BgOverlayWB", "evttype":"aa_lowpt_WB", "ProdID":10241, "expBG":0.24605, "subdir":"000"}, 
    {"ProcessorName":"BgOverlayBW", "evttype":"aa_lowpt_BW", "ProdID":10239, "expBG":0.243873, "subdir":"000"}, 
    {"ProcessorName":"BgOverlayBB", "evttype":"aa_lowpt_BB", "ProdID":10235, "expBG":0.35063, "subdir":"000"},
    {"ProcessorName":"PairBgOverlay", "evttype":"seeablepairs", "ProdID":10233, "expBG":1.0, "subdir":"100"}
     ]
    
    BXOverlay = 1
    NbSigEvtsPerJob = 100
    numberOfSignalEvents = NbSigEvtsPerJob
    basebkgpath = "/ilc/prod/ilc/mc-opt-3/ild/sim/500-TDR_ws"
    energy = "500"
    
    for ovl in ovldata:
        print "### OverlayInput ... "+ovl["ProcessorName"]
        ovlapp = OverlayInput()
        ovlpath = "%s/%s/%s/v02-00-01/%8.8d/%s" % \
      	( basebkgpath, ovl["evttype"], sim_detectorModel, ovl["ProdID"] , ovl["subdir"] ) 
        print "    OverlayPath ... " + ovlpath
        ovlapp.setMachine("ilc_dbd")
        # ovlapp.setEnergy(energy)
        # ovlapp.setDetectorModel(sim_detectorModel)
        ovlapp.setProcessorName(ovl["ProcessorName"])  
        ovlapp.setBkgEvtType(ovl["evttype"])
        ovlapp.setPathToFiles(ovlpath)
        ovlapp.setGGToHadInt(ovl["expBG"])
        ovlapp.setBXOverlay(BXOverlay)
        ovlapp.setNbSigEvtsPerJob(NbSigEvtsPerJob)
        ovlapp.setNumberOfSignalEventsPerJob(numberOfSignalEvents)
        res = job.append(ovlapp)
        if not res['OK']:
          print res['Message']
          exit(1)


    # Create Marlin application
    marlin = Marlin()
    marlin.setVersion("ILCSoft-02-00-02_gcc49")
    marlin.setDetectorModel(detector_model)
    marlin.setSteeringFile("MarlinStdReco.xml")
    marlin.setInputFile(inputFile)
    marlin.setNumberOfEvents(nbevts)
    marlin.setOutputDstFile(dstfile)
    marlin.setOutputRecFile(recfile)
    extraCLIArguments =  " --constant.DetectorModel=%s " % detector_model
    extraCLIArguments += " --constant.RunOverlay=true --constant.CMSEnergy=%s " % str(energy)
    marlin.setExtraCLIArguments( extraCLIArguments )

    job.append(marlin)

    if outputDir != "":
        job.setOutputData( [dstfile, recfile], OutputPath = outputDir, OutputSE = outputSE )

    if isLocal:
        job.submit(dIlc, mode="local")
    else:
        job.submit(dIlc)

# ######################################
if __name__ == "__main__":

    subOverlay()

