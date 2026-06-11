cmake_minimum_required(VERSION 3.22)

set(ROBOT_NAME robotiq_gripper)
mc_rtc_setup_package(mc_${ROBOT_NAME} 1.0.0)

find_description_package(robotiq_description REQUIRED)

set(ROBOTIQ_GRIPPER_MODELS robotiq_2f_85_gripper robotiq_2f_140_gripper)

mc_rtc_generate_urdf(
  generate-robotiq-urdf XACRO_PATH "${CMAKE_CURRENT_SOURCE_DIR}/xacro" MODELS
  ${ROBOTIQ_GRIPPER_MODELS})

mc_rtc_finalize_package()
