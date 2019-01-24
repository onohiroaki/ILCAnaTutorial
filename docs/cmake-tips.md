# CMake tips

## Execute commands

### Set a variable when running cmake
```
cmake -D<cmake_variable>=<value> <path_to_CMakeLists.txt>
```

### Browse/Modify cmake variables configured
```
ccmake <path_to_CMakeLists.txt>
```

### CMake steps
cmake command consistes of two steps, configure and generate makefile.
In configure step, the variables required to generate makefile is stored in CMakeCache.txt.


## Writing CMakeLists.txt

### Variables
Three types of variables are used.  Cache variable, non-chache variable, environment variable.

### Execute bash command 
```
execute_process( COMMAND <command> <argument1>   OUTPUT_VARIABLE <variable_name> )
```
Other options will be found in CMake document, 
https://cmake.org/cmake/help/v3.12/command/execute_process.html

## cmakemodule for ilcsoft
cmakemodule for ILCSoft is provided in ilcutil.


