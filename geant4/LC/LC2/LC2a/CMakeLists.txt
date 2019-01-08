
cmake_minimum_required(VERSION 2.8)

set( CMAKE_INSTALL_PREFIX ".." CACHE STRING "insall prefix" )
set( CMAKE_CXX_FLAGS "-g -std=c++11 "  CACHE STRING "cxx options")


project(exampleLC2a CXX)

find_package(LCIO REQUIRED PATHS $ENV{LCIO})

include_directories( $ENV{LCIO}/include )

add_executable(exampleLC2a ${PROJECT_SOURCE_DIR}/src/exampleLC2a.cc)

target_link_libraries(exampleLC2a ${LCIO_LIBRARIES})

install(TARGETS exampleLC2a DESTINATION bin)

