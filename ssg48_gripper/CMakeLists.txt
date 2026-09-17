cmake_minimum_required(VERSION 3.22)

set(ROBOT_NAME ssg48_gripper)

project(
  mc_${ROBOT_NAME}
  LANGUAGES CXX
  VERSION 1.0.0)

set(CXX_DISABLE_WERROR 1)
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

include(CTest)

find_package(mc_rtc REQUIRED)

find_description_package(ssg48_gripper_description REQUIRED)

mc_rtc_generate_robot_description(MODELS ${ROBOT_NAME})

mc_rtc_generate_robot_module()
