cmake_minimum_required(VERSION 3.10)

set(PROJECT_NAME robotiq_arg85)
set(PROJECT_DESCRIPTION "mc_rtc_tools example")

project(
  ${PROJECT_NAME}
  LANGUAGES CXX
  VERSION 1.0.0)
set(CMAKE_CXX_STANDARD 17)

find_package(mc_robot_tools REQUIRED)

# Install description
generate_robot_description(${PROJECT_NAME})

# Install robot module
add_subdirectory(src)
