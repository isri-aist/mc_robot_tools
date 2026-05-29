cmake_minimum_required(VERSION 3.10)

set(CXX_DISABLE_WERROR 1)
set(CMAKE_CXX_STANDARD 17)

set(PROJECT_NAME Panda_Prosthesis)
set(PROJECT_DESCRIPTION "Panda prosthesis modules")
set(PROJECT_URL "")

find_package(mc_panda OPTIONAL)

if(mc_panda_FOUND)
  # Install description
  generate_robot_description(bonetag_tibia)
  generate_robot_description(bonetag_femur)

  # Generate Robot Module YAML
  add_yaml_module(bonetag_tibia)
  add_yaml_module(bonetag_femur)

  # Install robot module
  add_subdirectory(src)
endif()
