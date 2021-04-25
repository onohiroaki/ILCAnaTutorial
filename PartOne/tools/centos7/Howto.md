# For CentOS7 : How to build libraries

## Install base and ilcsoft all of ILCSoft-v02-02-01

WARNING: Do not install both "build-base.sh" and "build-all-ilcsoft.sh"
Library versions are slightly different from those available in /cvmfs

```
mkdir -p build
( cd build && ../build-all-ilcsoft.sh > build-all-ilcsoft.log 2>&1 )
```

## Install root, lcio, and dependant software of ILCSoft-v02-02-01

WARNING: Do not install both "build-base.sh" and "build-all-ilcsoft.sh"
Library versions are slightly different from those available in /cvmfs

```
mkdir -p build
( cd build && ../build-base.sh > build-base.log 2>&1 )
```

## Install ocaml for whizard2

```
mkdir -p build
( cd build && ../build-ocaml.sh > build-ocaml.log 2>&1 )

( cd build && ../build-whizard2.sh > build-whizard2.log 2>&1 )

```
