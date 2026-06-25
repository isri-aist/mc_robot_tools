cmake_minimum_required(VERSION 3.22)

set(CXX_DISABLE_WERROR 1)
set(CMAKE_CXX_STANDARD 17)

set(PROJECT_NAME mc_robot_tools)
set(PROJECT_DESCRIPTION "Tools for mc_rtc robots")

project(
  ${PROJECT_NAME}
  LANGUAGES CXX
  VERSION 1.0.0)

set(CMAKE_EXPORT_COMPILE_COMMANDS ON)
include(CTest)
include(GNUInstallDirs)

option(WITH_BOTA "Build bota_sensor module" OFF)
option(WITH_DS4 "Build ds4 module" OFF)
option(WITH_PLATE "Build plate module" OFF)
option(WITH_REALSENSE "Build realsense_camera module" OFF)
option(WITH_ROBOTIQ "Build robotiq_gripper" OFF)
option(WITH_SCREW "Build screw module" OFF)

find_package(mc_rtc REQUIRED)

include(${CMAKE_CURRENT_SOURCE_DIR}/cmake/mc_rtc_macros.cmake)

# Library for ConnectableRobotModule
add_library(${PROJECT_NAME} INTERFACE)

target_include_directories(
  ${PROJECT_NAME}
  INTERFACE $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/include>
            $<INSTALL_INTERFACE:${CMAKE_INSTALL_INCLUDEDIR}>)

target_link_libraries(${PROJECT_NAME} INTERFACE mc_rtc::mc_rbdyn)

install(DIRECTORY include/${PROJECT_NAME}
        DESTINATION ${CMAKE_INSTALL_INCLUDEDIR})

install(TARGETS ${PROJECT_NAME} EXPORT ${PROJECT_NAME}Targets)

install(
  EXPORT ${PROJECT_NAME}Targets
  FILE ${PROJECT_NAME}Targets.cmake
  DESTINATION ${CMAKE_INSTALL_LIBDIR}/cmake/${PROJECT_NAME})

include(CMakePackageConfigHelpers)

file(
  WRITE "${CMAKE_CURRENT_BINARY_DIR}/mc_robot_toolsConfig.cmake.in"
  "@PACKAGE_INIT@
include(\"\${CMAKE_CURRENT_LIST_DIR}/mc_robot_toolsTargets.cmake\")
")

configure_package_config_file(
  "${CMAKE_CURRENT_BINARY_DIR}/mc_robot_toolsConfig.cmake.in"
  "${CMAKE_CURRENT_BINARY_DIR}/mc_robot_toolsConfig.cmake"
  INSTALL_DESTINATION ${CMAKE_INSTALL_LIBDIR}/cmake/mc_robot_tools)

install(FILES "${CMAKE_CURRENT_BINARY_DIR}/mc_robot_toolsConfig.cmake"
        DESTINATION ${CMAKE_INSTALL_LIBDIR}/cmake/mc_robot_tools)

# Subdirectory modules
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
