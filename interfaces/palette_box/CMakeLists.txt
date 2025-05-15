cmake_minimum_required(VERSION 3.10)

set(CXX_DISABLE_WERROR 1)
set(CMAKE_CXX_STANDARD 17)

set(PROJECT_NAME palette_box)
set(PROJECT_DESCRIPTION "Palette_box modules")
set(PROJECT_URL "")

### Install description
generate_robot_description(${PROJECT_NAME})

### Generate Robot Module
add_yaml_module(${PROJECT_NAME})



