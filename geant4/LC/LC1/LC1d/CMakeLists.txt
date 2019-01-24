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
project(B2b)


# set ( CMAKE_INSTALL_PREFIX "..")
#----------------------------------------------------------------------------
# Find Geant4 package, activating all available UI and Vis drivers by default
# You can set WITH_GEANT4_UIVIS to OFF via the command line or ccmake/cmake-gui
# to build a batch mode only executable
#
option(WITH_GEANT4_UIVIS "Build example with Geant4 UI and Vis drivers" ON)
if(WITH_GEANT4_UIVIS)
  find_package(Geant4 REQUIRED ui_all vis_all)
else()
  find_package(Geant4 REQUIRED)
endif()

find_package(ROOT REQUIRED)

#----------------------------------------------------------------------------
# Setup Geant4 include directories and compile definitions
# Setup include directory for this project
#
include(${Geant4_USE_FILE})
include_directories(${PROJECT_SOURCE_DIR}/include $ENV{ROOTSYS}/include )


message(" ROOT_USE_FILE is ${ROOT_USE_FILE} ")
# include(${ROOT_USE_FILE})

#----------------------------------------------------------------------------
# Locate sources and headers for this project
# NB: headers are included so they will show up in IDEs
#
file(GLOB sources ${PROJECT_SOURCE_DIR}/src/*.cc)
file(GLOB headers ${PROJECT_SOURCE_DIR}/include/*.hh)

#----------------------------------------------------------------------------
# Add the executable, and link it to the Geant4 libraries
#
add_executable(exampleB2b exampleB2b.cc ${sources} ${headers})
# target_link_libraries(exampleB2b ${Geant4_LIBRARIES})
target_link_libraries(exampleB2b ${Geant4_LIBRARIES} ${ROOT_LIBRARIES})

#----------------------------------------------------------------------------
# Copy all scripts to the build directory, i.e. the directory in which we
# build B2b. This is so that we can run the executable directly because it
# relies on these scripts being in the current working directory.
#
set(EXAMPLEB2B_SCRIPTS
  exampleB2b.out
  exampleB2.in
  gui.mac
  init_vis.mac
  run1.mac
  run2.mac
  vis.mac
  )


foreach(_script ${EXAMPLEB2B_SCRIPTS})
  configure_file(
    ${PROJECT_SOURCE_DIR}/${_script}
    ${PROJECT_BINARY_DIR}/${_script}
    COPYONLY
    )
endforeach()

#----------------------------------------------------------------------------
# Install the executable to 'bin' directory under CMAKE_INSTALL_PREFIX
#
install(TARGETS exampleB2b DESTINATION bin)

