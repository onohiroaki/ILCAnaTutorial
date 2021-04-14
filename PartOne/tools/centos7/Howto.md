# For CentOS7 : How to build libraries

## Install root, lcio, and dependant software

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
