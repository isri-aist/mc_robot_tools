cmake_minimum_required(VERSION 3.10)


set(PROJECT_NAME mc_robot_tools)
set(PROJECT_DESCRIPTION "Robot tools for mc_rtc")

project(${PROJECT_NAME} LANGUAGES CXX VERSION 1.0.0)
set(CMAKE_CXX_STANDARD 17)

include(cmake/RobotModule.cmake)

find_package(mc_rtc REQUIRED)

add_subdirectory(interfaces)
add_subdirectory(tools)

if(BUILD_TESTING)
  add_subdirectory(tests)
endif()
