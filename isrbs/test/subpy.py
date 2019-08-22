#!/bin/env python 
#

from ctypes import *

if __name__ == "__main__":

    flib = cdll.LoadLibrary("libsubtest.so")

    msg = "called from python"
    flib.subtest_.restype = None 
    flib.subtest_.argtypes = [ c_char_p, c_int ]

    # amsg = bytearray(msg)
    lenmsg = len(msg)

    flib.subtest_( msg, lenmsg )

  
