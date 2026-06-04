cmake_minimum_required(VERSION 3.22)
mc_rtc_setup_package(robotiq_gripper 1.0.0)

find_description_package(robotiq_description REQUIRED)

mc_rtc_generate_urdf(
  generate-robotiq-urdf XACRO_PATH "${CMAKE_CURRENT_SOURCE_DIR}/xacro" MODELS
  robotiq_2f_85_gripper robotiq_2f_140_gripper)

mc_rtc_finalize_package()
