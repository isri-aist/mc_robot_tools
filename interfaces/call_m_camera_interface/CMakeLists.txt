cmake_minimum_required(VERSION 3.10)

set(CXX_DISABLE_WERROR 1)
set(CMAKE_CXX_STANDARD 17)

set(PROJECT_NAME call_m_camera_interface)
set(PROJECT_DESCRIPTION "Call-M camera interface")
set(PROJECT_URL "")

project(
  ${PROJECT_NAME}
  LANGUAGES CXX
  VERSION 1.0.0)


find_package(mc_rtc REQUIRED)

### Install description
generate_urdf_description(${PROJECT_NAME})

### Install robot module
add_subdirectory(src)

