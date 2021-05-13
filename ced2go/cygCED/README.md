# glced for Windows ced

CED server, `glced.exe`, was built with cygwin Windows and prepared as 
an standalone application. 

## Use pre-build library

Binaries for cygwin is prepared on github. 
To use them, download it and put files in your command path. 

```
$ wget https://github.com/akiyamiyamoto/CED/releases/download/v01-09-03-cyg/cygCED-bin.tar.gz
# Make sure sha256sum is same shown at https://github.com/akiyamiyamoto/CED/releases/tag/v01-09-03-cyg
$ mkdir CEDbin
$ tar zxf cygCED-bin.tar.gz -C CEDbin
$ export PATH=CEDbin:${PATH}  
```
### Test run 
```
$ glced.exe & 
$ glced_hits.exe
```

`glced.exe` opens a new windows of the glced server.
`glced_hits.exe` is a glced client for test and shows
a figure as shown below.  
 
<img src="glced_mhits.png" width="100pt">

## How to build a standalone CED server

### Build iLCUtil

```
# Build ilcutil
wget -O iLCUtil-01-05.zip https://github.com/iLCSoft/iLCUtil/archive/v01-06-01.tar.gz
tar zxf v01-06-01.tar.gz
mv iLCUtil-01-06-01 v01-06-01
cd v01-06-01

mkdir build
pushd 
  cd build
  cmake ..
  make -j 4
  make install
```
ilcutil is installed in the current directory

### Buuild CED server

```
export ILCUTIL_DIR=<ilcutil_dir>

git clone https://github.com/akiyamiyamoto/CED.git
pushd CED
  tar zxf cygCED-v01-09-03.tar.gz
  mv v01-09-03-cygwin v01-09-03
  pushd v01-09-03
    mkdir build
    pushd build
      cmake -DCMAKE_INSTALL_PREFIX=<install_dir> .. 2>&1 | tee mycmake.log
      make -j 4 2>&1 | tee mymake.log
      make -j 4 install 2>&1 | tee myinstall.log
    popd
  popd

```
Libraries and executables are install in `lib` and `bin` directories.
`dll` in lib should be copied to `bin` directory of `glced`

 
