#!/bin/bash

rm -rf build lib 
(cd doc && rm -rf html )
(cd run && ./clean.sh )

