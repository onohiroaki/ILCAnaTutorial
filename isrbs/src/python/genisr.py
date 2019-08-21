#!/bin/env python 

# Basic example to call fortran subroutine, using cpython interface.
# See further comments below.


from ctypes import *
import math

import argparse
import os

if __name__ == "__main__":

    parser = argparse.ArgumentParser(description="Calculate weight and energy of ISR spectrum. Just a single point")
    parser.add_argument("-L",help="Directory of libpyISRBS.so. default=../lib/",dest="libdir", default="../lib/")
    parser.add_argument("-e",help="Center of mass energy (GeV) of generated spectrum. Default=500 GeV",
                        dest="roots", default="500.0")

    args = parser.parse_args()

    sqrts = float(args.roots)
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
    
    libfile = libdir + "libpyISRBS.so"
    if not os.path.exists(libfile):
        print "Fatal error: " + libfile + " does not exist."
        exit()
    
    isrlib = cdll.LoadLibrary(libfile)
    
    # Declare argument type of fortran subroutine.
    
    isrlib.isr_function_.argtypes = [ POINTER(c_double), POINTER(c_double), POINTER(c_double), POINTER(c_int32) ]
    isrlib.isr_remnant_.argtypes = [ POINTER(c_double), POINTER(c_double), POINTER(c_double), 
                                     POINTER(c_double), POINTER(c_double), POINTER(c_double) ]
    
    # Prepare from python variables C/Fortran type variables.
    
    afactor = c_double(factor)
    ax = c_double(x)
    ax0 = c_double(x0)
    aeps = c_double(eps)
    asqrts = c_double(sqrts)
    aLLA_order = c_int32(LLA_order)
    pmom_shape = c_double*4  # Declare array size
    pmom = pmom_shape()   # Create array
    pmom_pointer = cast(pmom, POINTER(c_double))  # Get pointer to array
    
    # Pass variables by reference.
    # In the case of array, it's pointer is given.
    
    isrlib.isr_function_(byref(afactor), byref(ax), byref(aeps), byref(aLLA_order))
    isrlib.isr_remnant_(byref(ax), byref(ax0), byref(ax), byref(ax0), byref(asqrts), pmom_pointer )
    
    # After a call, generated spectrum weight(factor), 
    
    print "Factor=" + str(afactor.value)
    print "x=" + str(ax.value)
    print "%20.15g,%20.15g,%20.15g,%20.15g" % (pmom[0], pmom[1], pmom[2], pmom[3])
    
