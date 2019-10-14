# glced for Windows ced

CED server, `glced.exe`, was built with cygwin Windows and prepared as 
an standalone application. 

## How to download and unpack
 
### Donwload [cygced-v01-09-02.tar.xz](cygCED-v01-09-02.tar.xz) 
sha256sum and md5sum of the file is as follows.
```
$ sha256sum cygCED-v01-09-02.tar.xz
15de73b469e4ccf63eb6ee8334be54298e9b23cf793fb472c09ab6be081eecd8  cygCED-v01-09-02.tar.xz

$ md5sum cygCED-v01-09-02.tar.xz
2c4dc6aaa15f3e4bc031da981765e98e  cygCED-v01-09-02.tar.xz
```
### Unpack it and add the directory to your command path.
```
$ tar Jxf cygCED-v01-09-02.tar.xz
```

### Test run 
```
$ export PATH=${PWD}/cygced-v01-09-02:${PATH}
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
$ wget -O iLCUtil-01-05.zip https://github.com/iLCSoft/iLCUtil/archive/v01-05.zip
$ unzip iLCUtil-01-05.zip 
$ mv iLCUtil-01-05 ilcutil-01-05
$ cd ilcutil-01-05 && mkdir build && cd build 
$ cmake ..
$ make && make install
$ cd ..
```
ilcutil is installed in the current directory

### Buuild CED server

```
$ wget -O CED-01-09.zip https://github.com/iLCSoft/CED/archive/master.zip
$ unzip CED-01-09.zip
$ cd CED-01-09
$ export ilcutil="`pwd`/ilcutil-01-05"
$ export LD_LIBRARY_PATH="${ilcutil}/lib:${LD_LIBRARY_PATH}"
$ export CMAKE_PREFIX_PATH="${ilcutil}"
$ mkdir build && cd build && cmake ..
$ make && make install
```
Libraries and executables are install in `lib` and `bin` directories.


 
