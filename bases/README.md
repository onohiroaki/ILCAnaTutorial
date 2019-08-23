# bases 

Library for multi-variable monte calro integration C++ version.

To install 
```
mkdir build
cd build
make 
make install
```
Example source files will be found in `example/numnumgam`.
It is e<sup>+</sup> e<sup>-</sup> &rarr; &nu;&nu;&gamma; process
at center of mass energy of 105 GeV, which is defined by 
the variable `W` in `example/nunugam/nunugam.cxx`. 

Following executables are created in `bin` directory.

- `nng_int.exe` : Integration. Integration result is created in `bases.data`. 

- `nng_gen.exe` : Generate events, reading `bases.data`. A histogram to compare integration step 
distribution and generation step distribution is printed.

- `nng_intgen.exe` : Do integration and generation in one executable.

