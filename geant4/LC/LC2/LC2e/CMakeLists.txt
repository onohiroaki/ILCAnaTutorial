# $Id: CMakeLists.txt 100813 2016-11-02 15:09:50Z gcosmo $

# set( CMAKE_INSTALL_PREFIX ".." CACHE STRING "install prefix" FORCE)

set( CMAKE_INSTALL_PREFIX ".." CACHE STRING "insall prefix" )
set( CMAKE_CXX_FLAGS "-g -Wall"  CACHE STRING "cxx options")

message("CMAKE_INSTALL_PREFIX is ${CMAKE_INSTALL_PREFIX}")
message("CMAKE_CXX_FLAGS is ${CMAKE_CXX_FLAGS}")

set( CMAKE_CXX_COMPILER $ENV{CXX} ) # Set environ parameter
set( CMAKE_C_COMPILER $ENV{CC} )

message("CMAKE_CXX_COMPILER is ${CMAKE_CXX_COMPILER}")
message("CMAKE_C_COMPILER is ${CMAKE_C_COMPILER}")

# execute_process(COMMAND root-config --incdir OUTPUT_VARIABLE ROOT_INCLUDE)

#----------------------------------------------------------------------------
# Setup the project
#
cmake_minimum_required(VERSION 2.6 FATAL_ERROR)
project(pyISRBS Fortran)

message("PROJECT_SOURCE_DIR is ${PROJECT_SOURCE_DIR}")

find_package(ROOT REQUIRED)

#----------------------------------------------------------------------------
# Setup Geant4 include directories and compile definitions
# Setup include directory for this project
#
# include(${Geant4_USE_FILE})
include_directories(${PROJECT_SOURCE_DIR}/include $ENV{ROOTSYS}/include )


#----------------------------------------------------------------------------
# Locate sources and headers for this project
# NB: headers are included so they will show up in IDEs
#
file(GLOB sources ${PROJECT_SOURCE_DIR}/src/fortran/*.F)
file(GLOB headers ${PROJECT_SOURCE_DIR}/include/*.inc)
file(GLOB scripts ${PROJECT_SOURCE_DIR}/src/python/*.py )

#----------------------------------------------------------------------------
# Copy all scripts to the build directory, i.e. the directory in which we
# build B2b. This is so that we can run the executable directly because it
# relies on these scripts being in the current working directory.
#
add_library( pyISRBS SHARED ${sources} )
target_link_libraries( pyISRBS ${ROOT_LIBRARIES} )

set(pyISRBS_SCRIPTS ${scripts})

#----------------------------------------------------------------------------
# Install the executable to 'bin' directory under CMAKE_INSTALL_PREFIX
#
install(TARGETS pyISRBS DESTINATION lib)

install(
   FILES ${pyISRBS_SCRIPTS} 
   PERMISSIONS OWNER_EXECUTE OWNER_WRITE OWNER_READ
   DESTINATION bin 
)


