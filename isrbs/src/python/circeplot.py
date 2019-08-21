#!/bin/env python 

from ctypes import *
import argparse
import os

if __name__ == "__main__":

    libcirce2 = "/sw/ilc/gcc493/whizard2/2.6.0/lib/libcirce2.so"

    circe2 = cdll(libcirce2)



