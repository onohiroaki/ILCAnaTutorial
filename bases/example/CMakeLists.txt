# $Id: CMakeLists.txt 100813 2016-11-02 15:09:50Z gcosmo $

# set( CMAKE_INSTALL_PREFIX ".." CACHE STRING "install prefix" FORCE)

set( CMAKE_CXX_FLAGS "-g -Wall -D__USEISOCXX__ "  CACHE STRING "cxx options")

message("CMAKE_CXX_FLAGS is ${CMAKE_CXX_FLAGS}")

set( CMAKE_CXX_COMPILER $ENV{CXX} ) # Set environ parameter
set( CMAKE_C_COMPILER $ENV{CC} )

# --------------------------------------------------------------------------
# Do not remove RPATH, when installing executables

set( CMAKE_INSTALL_RPATH "${CMAKE_INSTALL_PREFIX}/lib" )
set( CMAKE_INSTALL_RPATH_USE_LINK_PATH TRUE)

# set( CMAKE_VERBOSE_MAKEFILE TRUE CACHE BOOL "makefile verbose" )
# set( CMAKE_COLOR_MAKEFILE FALSE CACHE BOOL "makefile color" )

message("CMAKE_CXX_COMPILER is ${CMAKE_CXX_COMPILER}")
message("CMAKE_C_COMPILER is ${CMAKE_C_COMPILER}")


#----------------------------------------------------------------------------
# Setup the project
#
# message("PROJECT_SOURCE_DIR is ${PROJECT_SOURCE_DIR}")
# message("CMAKE_INSTALL_PREFIX is ${CMAKE_INSTALL_PREFIX}")


#----------------------------------------------------------------------------
# Setup include directory for this project
#
include_directories(include )


#----------------------------------------------------------------------------
# Locate sources and headers for this project
# NB: headers are included so they will show up in IDEs
#
file(GLOB headers nunugam/*.h )
# file(GLOB scripts ${PROJECT_SOURCE_DIR}/src/python/*.py )

#----------------------------------------------------------------------------
# Copy all scripts to the build directory, i.e. the directory in which we
# build B2b. This is so that we can run the executable directly because it
# relies on these scripts being in the current working directory.
#

cmake_policy(SET CMP0015 NEW)
#----------------------------------------------------------------------------
# Install the executable to 'bin' directory under CMAKE_INSTALL_PREFIX
#

#----------------------------------------------------------------------------
# Add executables
# 

add_executable(nng_int.exe nunugam/testint.cxx nunugam/nunugam.cxx ${headers})
target_link_libraries(nng_int.exe bases)

add_executable(nng_gen.exe nunugam/testgen.cxx nunugam/nunugam.cxx ${headers})
target_link_libraries(nng_gen.exe bases)

add_executable(nng_intgen.exe nunugam/intgen.cxx nunugam/nunugam.cxx ${headers})
target_link_libraries(nng_intgen.exe bases)

#----------------------------------------------------------------------------
# Install the executable to 'bin' directory under CMAKE_INSTALL_PREFIX
#

install(TARGETS nng_int.exe nng_gen.exe nng_intgen.exe DESTINATION bin)

# install(
#   FILES ${pyISRBS_SCRIPTS} 
#   PERMISSIONS OWNER_EXECUTE OWNER_WRITE OWNER_READ
#   DESTINATION bin 
#)

#----------------------------------------------------------------------------
# Create demo_circe2 directory and install demo files there
#
# file(MAKE_DIRECTORY demo_circe2)
# install( TARGETS circe2_print_spectrum_f77.exe DESTINATION bin)
# install( TARGETS circe2_print_spectrum_f90.exe DESTINATION bin)

