cmake_minimum_required(VERSION 3.10)

set(CXX_DISABLE_WERROR 1)
set(CMAKE_CXX_STANDARD 17)

set(PROJECT_NAME Panda_Prosthesis)
set(PROJECT_DESCRIPTION "Panda prosthesis modules")
set(PROJECT_URL "")

find_package(mc_panda REQUIRED)

### Install description
generate_urdf_description(bonetag_tibia)
generate_urdf_description(bonetag_femur)

macro(add_yaml_module NAME)
  configure_file(${CMAKE_CURRENT_SOURCE_DIR}/yaml/${NAME}.in.yaml "${CMAKE_CURRENT_BINARY_DIR}/yaml/${NAME}.yaml")
  configure_file(${CMAKE_CURRENT_SOURCE_DIR}/alias/${NAME}.in.yaml "${CMAKE_CURRENT_BINARY_DIR}/alias/${NAME}.yaml")
  # Install the alias and yaml
  install(FILES "${CMAKE_CURRENT_BINARY_DIR}/alias/${NAME}.yaml" DESTINATION "${MC_ROBOTS_ALIASES_DIRECTORY}")
  install(FILES "${CMAKE_CURRENT_BINARY_DIR}/yaml/${NAME}.yaml" DESTINATION "${DATA_DIR}/yaml")
endmacro()

add_yaml_module(bonetag_tibia)
add_yaml_module(bonetag_femur)

### Install robot module
add_subdirectory(src)



