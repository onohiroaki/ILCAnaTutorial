
# set( CMAKE_INSTALL_PREFIX ".." CACHE STRING "install prefix" FORCE)

set( CMAKE_CXX_FLAGS "-g -Wall -D__USEISOCXX__ "  CACHE STRING "cxx options")

message("CMAKE_CXX_FLAGS is ${CMAKE_CXX_FLAGS}")

set( CMAKE_CXX_COMPILER $ENV{CXX} ) # Set environ parameter
set( CMAKE_C_COMPILER $ENV{CC} )
set( CMAKE_Fortran_COMPILER "gfortran" )
set( CMAKE_Fortran_FLAGS "-g -fpic " )

# set( CMAKE_VERBOSE_MAKEFILE TRUE CACHE BOOL "makefile verbose" )
# set( CMAKE_COLOR_MAKEFILE FALSE CACHE BOOL "makefile color" )

message("CMAKE_CXX_COMPILER is ${CMAKE_CXX_COMPILER}")
message("CMAKE_C_COMPILER is ${CMAKE_C_COMPILER}")
message("CMAKE_FORTRAN_COMPILER is ${CMAKE_Fortran_COMPILER}")


# execute_process(COMMAND root-config --incdir OUTPUT_VARIABLE ROOT_INCLUDE)

#----------------------------------------------------------------------------
# Setup the project
#
cmake_minimum_required(VERSION 2.6 FATAL_ERROR)
project(bases)

set( CMAKE_INSTALL_PREFIX ${PROJECT_SOURCE_DIR} CACHE STRING "insall prefix" FORCE )

message("PROJECT_SOURCE_DIR is ${PROJECT_SOURCE_DIR}")
message("CMAKE_INSTALL_PREFIX is ${CMAKE_INSTALL_PREFIX}")

#----------------------------------------------------------------------------
# message("########### Start building src directory ")
# add_subdirectory(src)
# message("########### End build src directory")


#----------------------------------------------------------------------------
# Setup include directory for this project
#
include_directories(${PROJECT_SOURCE_DIR}/include )

#----------------------------------------------------------------------------
# Locate sources and headers for this project
# NB: headers are included so they will show up in IDEs
#
file(GLOB sources src/*.cxx )
file(GLOB headers include/*.h )
# file(GLOB scripts ${PROJECT_SOURCE_DIR}/src/python/*.py )

#----------------------------------------------------------------------------
# Copy all scripts to the build directory, i.e. the directory in which we
# build B2b. This is so that we can run the executable directly because it
# relies on these scripts being in the current working directory.
#
add_library( bases SHARED ${sources} )
# target_link_libraries( pyISRBS ${ROOT_LIBRARIES} )


# cmake_policy(SET CMP0015 NEW)
#----------------------------------------------------------------------------
# Install the executable to 'bin' directory under CMAKE_INSTALL_PREFIX
#

#----------------------------------------------------------------------------
# Add executables
# 

# link_directories(lib)
# add_executable(nunugam.cxx ${PROJECT_SOURCE_DIR}/src/examples/circe2_print_spectrum_f77.F ${headers})
# target_link_libraries(circe2_print_spectrum_f77.exe pyISRBS circe2 taorng taorng_objs )

# add_executable(circe2_print_spectrum_f90.exe ${PROJECT_SOURCE_DIR}/src/examples/circe2_print_spectrum_f90.f90 ${headers})
# target_link_libraries(circe2_print_spectrum_f90.exe pyISRBS circe2 taorng taorng_objs )

#----------------------------------------------------------------------------
# Install the executable to 'bin' directory under CMAKE_INSTALL_PREFIX
#

install(TARGETS bases LIBRARY DESTINATION lib)

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

add_subdirectory(example)
