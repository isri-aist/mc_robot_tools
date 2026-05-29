cmake_minimum_required(VERSION 3.10)

set(PROJECT_NAME mc_robot_tools)
set(PROJECT_DESCRIPTION "Robot tools for mc_rtc")

project(
  ${PROJECT_NAME}
  LANGUAGES CXX
  VERSION 1.0.0)
set(CMAKE_CXX_STANDARD 17)

set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

include(CMakeDependentOption) # Needs to be called once

option("WITH_INTERFACES" "Build interfaces" ON)
option("WITH_TOOLS" "Build tools" ON)
option("INSTALL_3rd_PARTY" "Install 3rd party" ON)
# cmake_dependent_option(<variable> "<help_text>" <default> <conditions>
# <fallback>)

if(INSTALL_3rd_PARTY)
  include(cmake/install-3rd-party.cmake)
endif()

include(cmake/RobotModule.cmake)

find_package(mc_rtc REQUIRED)

if(WITH_INTERFACES)
  add_subdirectory(interfaces)
endif()
if(WITH_TOOLS)
  add_subdirectory(tools)
endif()

# Generate package file
include(CMakePackageConfigHelpers)

configure_package_config_file(
  ${CMAKE_CURRENT_SOURCE_DIR}/cmake/${PROJECT_NAME}Config.cmake.in
  ${CMAKE_CURRENT_BINARY_DIR}/${PROJECT_NAME}Config.cmake
  INSTALL_DESTINATION lib/cmake/${PROJECT_NAME})

write_basic_package_version_file(
  ${CMAKE_CURRENT_BINARY_DIR}/${PROJECT_NAME}ConfigVersion.cmake
  VERSION ${PROJECT_VERSION}
  COMPATIBILITY AnyNewerVersion)

install(FILES ${CMAKE_CURRENT_SOURCE_DIR}/cmake/install-3rd-party.cmake
              ${CMAKE_CURRENT_SOURCE_DIR}/cmake/RobotModule.cmake
        DESTINATION lib/cmake/${PROJECT_NAME})

install(FILES ${CMAKE_CURRENT_BINARY_DIR}/${PROJECT_NAME}Config.cmake
              ${CMAKE_CURRENT_BINARY_DIR}/${PROJECT_NAME}ConfigVersion.cmake
        DESTINATION lib/cmake/${PROJECT_NAME})
