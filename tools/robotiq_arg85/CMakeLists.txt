cmake_minimum_required(VERSION 3.10)

set(CXX_DISABLE_WERROR 1)
set(CMAKE_CXX_STANDARD 17)

set(PROJECT_NAME robotiq_arg85)
set(PROJECT_DESCRIPTION "robotiq_arg85 robot module")
set(PROJECT_URL "")

project(
  ${PROJECT_NAME}
  LANGUAGES CXX
  VERSION 1.0.0)

find_package(mc_rtc REQUIRED)

# Install description
generate_robot_description(${PROJECT_NAME})

# Install robot module
add_subdirectory(src)
