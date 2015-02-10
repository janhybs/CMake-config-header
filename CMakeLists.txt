cmake_minimum_required(VERSION 2.8)

# Project name and language(s)
project(Flow123d CXX C)
# set modules path
set(CMAKE_MODULE_PATH "${Flow123d_SOURCE_DIR}/CMake/Modules" "${CMAKE_ROOT}/Modules")
# include lib
include (Flow123d_config_header)

set (VARIABLE_1 "VALUE")
set (VARIABLE_2 "")


ADD_DEFINITIONS (-DFlow123dDebug)
RECORD_DEFINITIONS (-DFoo=Bar -DAAA=1234 -stdc++11)
RECORD_DEFINITIONS_BY_NAME ("VARIABLE_1" "VARIABLE_2")


MESSAGE (STATUS "DEFINITIONS_LIST:  ${DEFINITIONS_LIST}")
GENERATE_CONFIG_H ()
MESSAGE (STATUS "DEFINITIONS_LIST:  ${DEFINITIONS_LIST}")