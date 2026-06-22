cmake_minimum_required(VERSION 3.22)

set(CXX_DISABLE_WERROR 1)
set(CMAKE_CXX_STANDARD 17)

set(PROJECT_NAME mc_tools)
set(PROJECT_DESCRIPTION "Tools for mc_rtc robots")

project(
  ${PROJECT_NAME}
  LANGUAGES CXX
  VERSION 1.0.0)

set(CMAKE_EXPORT_COMPILE_COMMANDS ON)
include(CTest)

option(WITH_BOTA "Build bota_sensor module" OFF)
option(WITH_DS4 "Build ds4 module" OFF)
option(WITH_PLATE "Build plate module" OFF)
option(WITH_REALSENSE "Build realsense_camera module" OFF)
option(WITH_ROBOTIQ "Build robotiq_gripper" OFF)
option(WITH_SCREW "Build screw module" OFF)

find_package(mc_rtc REQUIRED)

include(${CMAKE_CURRENT_SOURCE_DIR}/cmake/mc_rtc_macros.cmake)

if(WITH_BOTA)
  add_subdirectory(bota_sensor)
endif()

if(WITH_DS4)
  add_subdirectory(ds4)
endif()

if(WITH_PLATE)
  add_subdirectory(plate)
endif()

if(WITH_REALSENSE)
  add_subdirectory(realsense_camera)
endif()

if(WITH_ROBOTIQ)
  add_subdirectory(robotiq_gripper)
endif()

if(WITH_SCREW)
  add_subdirectory(screw)
endif()
