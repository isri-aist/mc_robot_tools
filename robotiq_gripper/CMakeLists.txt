cmake_minimum_required(VERSION 3.22)

set(ROBOT_NAME robotiq_gripper)

project(
  mc_${ROBOT_NAME}
  LANGUAGES CXX
  VERSION 1.0.0)

set(CXX_DISABLE_WERROR 1)
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

include(CTest)

find_package(mc_rtc REQUIRED)

find_description_package(robotiq_description REQUIRED)

set(ROBOTIQ_GRIPPER_MODELS robotiq_2f_85_gripper robotiq_2f_140_gripper)

mc_rtc_generate_robot_description(MODELS ${ROBOTIQ_GRIPPER_MODELS})

mc_rtc_generate_robot_module()
