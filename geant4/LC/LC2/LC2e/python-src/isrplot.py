#!/bin/env python

from ctypes import *
import math
import ROOT


factor = 1.0
sqrts = 1000.0
alphai = 137.03599967994
alpha = 1.0/alphai
pi=3.14159265358979
ame=0.000510998902
LLA_order=3
eps=alpha/pi*2*math.log(sqrts/ame)

x0 = 1.0
x = 0.1
factor = 1.0


tfile = ROOT.TFile("isrplot.root", "RECREATE")
nt = ROOT.TNtuple("nt", "isrfunc", "x:fi:e:pt")
hisr = ROOT.TH1D("hisr", "ISR energy", 200, 0.0, 1.1)

nevents = 10000
x0 = 1.0

isrlib = cdll.LoadLibrary("../lib/libpyISRBS.so")
isrlib.isr_function_.argtypes = [ POINTER(c_double), POINTER(c_double), POINTER(c_double), POINTER(c_int32) ]
isrlib.isr_remnant_.argtypes = [ POINTER(c_double), POINTER(c_double), POINTER(c_double), POINTER(c_double), POINTER(c_double), POINTER(c_double) ]

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
    eisr = pmom[0]
    px = pmom[1]
    py = pmom[2]
    ptisr = math.sqrt(px*px + py*py)
    nt.Fill(ax.value, afactor.value, eisr, ptisr)
    hisr.Fill(ax.value, afactor.value)

tfile.Write()
tfile.Close()


