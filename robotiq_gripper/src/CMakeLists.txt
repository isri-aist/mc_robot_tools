configure_file(config.in.h "${CMAKE_CURRENT_BINARY_DIR}/config.h")

set(ROBOTIQ_GRIPPER_SRC "${CMAKE_CURRENT_SOURCE_DIR}/robotiq_gripper.cpp")
set(ROBOTIQ_GRIPPER_HDR "${CMAKE_CURRENT_SOURCE_DIR}/robotiq_gripper.h")

add_robot(robotiq_gripper ${ROBOTIQ_GRIPPER_SRC} ${ROBOTIQ_GRIPPER_HDR})

target_include_directories(
  robotiq_gripper PRIVATE "${CMAKE_CURRENT_SOURCE_DIR}"
                          "${CMAKE_CURRENT_BINARY_DIR}")
