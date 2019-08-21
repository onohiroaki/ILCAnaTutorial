#!/bin/env python

from ctypes import *
import math
import ROOT
import argparse
import os

if __name__ == "__main__":

    parser = argparse.ArgumentParser(description="Create a root file for ISR spectrum")
    parser.add_argument("-L",help="Directory of libpyISRBS.so. default=../lib/",dest="libdir", default="../lib/")
    parser.add_argument("-n",help="Number of events to generate. Default=10000 events", dest="nevents", default="10000")
    parser.add_argument("-e",help="Center of mass energy (GeV) of generated spectrum. Default=500 GeV", 
                        dest="roots", default="500.0")
    parser.add_argument("-f",help="Output root file name. Default=isrplot.root.", dest="rootfile", default="isrplot.root")

    args = parser.parse_args()

    sqrts = float(args.roots)
    nevents = int(args.nevents)
    rootfile = args.rootfile
    libdir = args.libdir

    factor = 1.0
    alphai = 137.03599967994
    alpha = 1.0/alphai
    pi=3.14159265358979
    ame=0.000510998902
    LLA_order=3
    eps=alpha/pi*2*math.log(sqrts/ame)
    
    x0 = 1.0
    x = 0.1
    factor = 1.0
    
    tfile = ROOT.TFile(rootfile, "RECREATE")
    nt = ROOT.TNtuple("nt", "isrfunc", "roots_wo_weight:weight:isrEnergy:isrPt")
    hisr = ROOT.TH1D("roots_after_ISR", "Collision energy after ISR photon emission", 200, 0.0, 1.1)
    
    x0 = 1.0
    
    # Add 
    libfile = libdir + "libpyISRBS.so"
    if not os.path.exists(libfile):
        print "Fatal error: " + libfile + " does not exist."
        exit()
    isrlib = cdll.LoadLibrary(libfile)


    isrlib.isr_function_.argtypes = [ POINTER(c_double), POINTER(c_double), POINTER(c_double), POINTER(c_int32) ]
    isrlib.isr_remnant_.argtypes = [ POINTER(c_double), POINTER(c_double), 
	POINTER(c_double), POINTER(c_double), POINTER(c_double), POINTER(c_double) ]
    
    aeps = c_double(eps)
    aLLA_order = c_int32(LLA_order)
    ax0 = c_double(x0)
    asqrts = c_double(sqrts)
    pmom_shape = c_double*4  # Declare array size
    pmom = pmom_shape()   # Create array
    pmom_pointer = cast(pmom, POINTER(c_double))  # Get pointer to array
    
    
    for iev in range(0, nevents):
        x = ROOT.gRandom.Rndm()
        factor = 1.0
        afactor = c_double(factor)
        ax = c_double(x)
        isrlib.isr_function_(byref(afactor), byref(ax), byref(aeps), byref(aLLA_order))
        isrlib.isr_remnant_(byref(ax), byref(ax0), byref(ax), byref(ax0), byref(asqrts), pmom_pointer )
        eisr = pmom[0] # Generated ISR photon energy
        px = pmom[1]
        py = pmom[2]
        ptisr = math.sqrt(px*px + py*py)
        nt.Fill(sqrts*ax.value, afactor.value, eisr, ptisr)
        hisr.Fill(ax.value, afactor.value) # afactor is the weight of this point.
    
    tfile.Write()
    tfile.Close()
    
    print "ISR spectrum was created in " + rootfile
