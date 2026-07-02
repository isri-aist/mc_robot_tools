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

option(WITH_BOTA_SENSOR "Build bota_sensor module" OFF)
option(WITH_DS4 "Build ds4 module" OFF)
option(WITH_PLATE "Build plate module" OFF)
option(WITH_REALSENSE_CAMERA "Build realsense_camera module" OFF)
option(WITH_ROBOTIQ_GRIPPER "Build robotiq_gripper" OFF)
option(WITH_SCREW "Build screw module" OFF)

find_package(mc_rtc REQUIRED)

include(${CMAKE_CURRENT_SOURCE_DIR}/cmake/mc_rtc_macros.cmake)

# ══════════════════════════════════════════════════════════════
# Generate mc_robot_tools.h from template
# ══════════════════════════════════════════════════════════════
foreach(opt BOTA_SENSOR DS4 PLATE REALSENSE_CAMERA ROBOTIQ_GRIPPER SCREW)
  if(WITH_${opt})
    set(WITH_${opt}_BOOL "true")
  else()
    set(WITH_${opt}_BOOL "false")
  endif()
endforeach()

configure_file(
  ${CMAKE_CURRENT_SOURCE_DIR}/include/${PROJECT_NAME}/mc_robot_tools.in.h
  ${CMAKE_CURRENT_BINARY_DIR}/include/${PROJECT_NAME}/mc_robot_tools.h @ONLY)

# ══════════════════════════════════════════════════════════════
# Library for ConnectableRobotModule
# ══════════════════════════════════════════════════════════════
add_library(${PROJECT_NAME} INTERFACE)

target_include_directories(
  ${PROJECT_NAME}
  INTERFACE $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/include>
            $<BUILD_INTERFACE:${CMAKE_CURRENT_BINARY_DIR}/include>
            $<INSTALL_INTERFACE:${CMAKE_INSTALL_INCLUDEDIR}>)

target_link_libraries(${PROJECT_NAME} INTERFACE mc_rtc::mc_rbdyn)

# Install source headers (from include/mc_robot_tools/)
install(DIRECTORY include/${PROJECT_NAME}
        DESTINATION ${CMAKE_INSTALL_INCLUDEDIR})

# ⭐ ADDED: install the generated header separately
install(
  FILES ${CMAKE_CURRENT_BINARY_DIR}/include/${PROJECT_NAME}/mc_robot_tools.h
  DESTINATION ${CMAKE_INSTALL_INCLUDEDIR}/${PROJECT_NAME})

install(TARGETS ${PROJECT_NAME} EXPORT ${PROJECT_NAME}Targets)

install(
  EXPORT ${PROJECT_NAME}Targets
  FILE ${PROJECT_NAME}Targets.cmake
  DESTINATION ${CMAKE_INSTALL_LIBDIR}/cmake/${PROJECT_NAME})

include(CMakePackageConfigHelpers)

file(
  WRITE "${CMAKE_CURRENT_BINARY_DIR}/${PROJECT_NAME}Config.cmake.in"
  "@PACKAGE_INIT@
include(\"\${CMAKE_CURRENT_LIST_DIR}/${PROJECT_NAME}Targets.cmake\")
")

configure_package_config_file(
  "${CMAKE_CURRENT_BINARY_DIR}/${PROJECT_NAME}Config.cmake.in"
  "${CMAKE_CURRENT_BINARY_DIR}/${PROJECT_NAME}Config.cmake"
  INSTALL_DESTINATION ${CMAKE_INSTALL_LIBDIR}/cmake/${PROJECT_NAME})

install(FILES "${CMAKE_CURRENT_BINARY_DIR}/${PROJECT_NAME}Config.cmake"
        DESTINATION ${CMAKE_INSTALL_LIBDIR}/cmake/${PROJECT_NAME})

# Subdirectory modules
if(WITH_BOTA_SENSOR)
  add_subdirectory(bota_sensor)
endif()

if(WITH_DS4)
  add_subdirectory(ds4)
endif()

if(WITH_PLATE)
  add_subdirectory(plate)
endif()

if(WITH_REALSENSE_CAMERA)
  add_subdirectory(realsense_camera)
endif()

if(WITH_ROBOTIQ_GRIPPER)
  add_subdirectory(robotiq_gripper)
endif()

if(WITH_SCREW)
  add_subdirectory(screw)
endif()
