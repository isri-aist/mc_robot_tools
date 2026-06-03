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

find_package(mc_rtc REQUIRED)

find_description_package(robotiq_description OPTIONAL)
if(robotiq_description_FOUND)
  message(STATUS "robotiq_description found, building robotiq_gripper modules")
  add_subdirectory(robotiq_gripper)
else()
  message(WARNING "robotiq_description not found, skipping robotiq_gripper")
endif()

find_description_package(bota_driver OPTIONAL)
if(bota_driver_FOUND)
  message(STATUS "bota_driver found, building bota_sensor modules")
  add_subdirectory(bota_sensor)
else()
  message(WARNING "bota_driver not found, skipping bota_sensor")
endif()
