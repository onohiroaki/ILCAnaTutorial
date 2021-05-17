########################################################
# cmake file for building Marlin example Package
# @author Jan Engels, Desy IT
CMAKE_MINIMUM_REQUIRED(VERSION 2.6 FATAL_ERROR)
########################################################


# project name
PROJECT( mydstanal )


# project version
SET( ${PROJECT_NAME}_VERSION_MAJOR 0 )
SET( ${PROJECT_NAME}_VERSION_MINOR 1 )
SET( ${PROJECT_NAME}_VERSION_PATCH 0 )

# C17 as the standard
SET( CMAKE_CXX_STANDARD 17 )
SET( CMAKE_CXX_STANDARD_REQUIRED ON )

# Set value to a cache variable. Cache variable is a variable used internally. 
# Format is
#    set( <variable> <value> CACHE <type> <docstring> [FORCE] )
#      <type> : Variable type. 
#      <docstring> : Description text.
#      FORCE  : Over-write value even if it is protected

set( CMAKE_INSTALL_PREFIX ".." CACHE STRING "Directory where package is installed." FORCE )

set( CMAKE_CXX_FLAGS "-g -Wall"  CACHE STRING "cxx options" FORCE)

message("CMAKE_INSTALL_PREFIX is ${CMAKE_INSTALL_PREFIX}")


### DEPENDENCIES ############################################################

FIND_PACKAGE( ILCUTIL REQUIRED COMPONENTS ILCSOFT_CMAKE_MODULES )


# load default settings from ILCSOFT_CMAKE_MODULES
INCLUDE( ilcsoft_default_settings )


FIND_PACKAGE( Marlin 1.0 REQUIRED ) # minimum required Marlin version
INCLUDE_DIRECTORIES( ${Marlin_INCLUDE_DIRS} )
LINK_LIBRARIES( ${Marlin_LIBRARIES} )
ADD_DEFINITIONS( ${Marlin_DEFINITIONS} )

# optional package
FIND_PACKAGE( ROOT REQUIRED )
INCLUDE_DIRECTORIES( ${ROOT_INCLUDE_DIRS} )
LINK_LIBRARIES( ${ROOT_LIBRARIES} )
ADD_DEFINITIONS( ${ROOT_DEFINITIONS} )

#FIND_PACKAGE( AIDA )
#IF( AIDA_FOUND )
#    INCLUDE_DIRECTORIES( ${AIDA_INCLUDE_DIRS} )
#    LINK_LIBRARIES( ${AIDA_LIBRARIES} )
#    ADD_DEFINITIONS( "-DMARLIN_USE_AIDA" )
#    MESSAGE( STATUS "AIDA -- found" )
#ELSE()
#    MESSAGE( STATUS "AIDA -- not found" )
#ENDIF()



### DOCUMENTATION ###########################################################

OPTION( INSTALL_DOC "Set to OFF to skip build/install Documentation" ON )

IF( INSTALL_DOC AND EXISTS "${PROJECT_SOURCE_DIR}/doc/CMakeLists.txt" )
    ADD_SUBDIRECTORY( ./doc )
ENDIF()



### LIBRARY #################################################################

# definitions to pass to the compiler
# ADD_DEFINITIONS( "-g -Wall -ansi -pedantic" )
# ADD_DEFINITIONS( "-Wno-long-long" )
ADD_DEFINITIONS( "-Weffc++" )

# include directories
INCLUDE_DIRECTORIES( ./include )
#INSTALL_DIRECTORY( ./include DESTINATION . FILES_MATCHING PATTERN "*.h" )

# add library
AUX_SOURCE_DIRECTORY( ./src library_sources )
ADD_SHARED_LIBRARY( ${PROJECT_NAME} ${library_sources} )
INSTALL_SHARED_LIBRARY( ${PROJECT_NAME} DESTINATION lib )

# display some variables and write them to cache
DISPLAY_STD_VARIABLES()

