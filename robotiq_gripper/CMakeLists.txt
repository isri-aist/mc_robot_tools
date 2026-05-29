cmake_minimum_required(VERSION 3.22)

set(CXX_DISABLE_WERROR 1)
set(CMAKE_CXX_STANDARD 17)

set(PROJECT_NAME mc_robotiq_gripper)
set(PROJECT_VERSION 1.0.0)
project(
  ${PROJECT_NAME}
  LANGUAGES CXX
  VERSION ${PROJECT_VERSION})

set(CMAKE_EXPORT_COMPILE_COMMANDS ON)
include(CTest)

find_package(mc_rtc REQUIRED)
find_program(XACRO xacro REQUIRED)

find_description_package(robotiq_description REQUIRED)

# Resolve the actual share path
if(EXISTS "${ROBOTIQ_DESCRIPTION_PATH}/share/robotiq_description")
  set(ROBOTIQ_DESCRIPTION_SHARE
      "${ROBOTIQ_DESCRIPTION_PATH}/share/robotiq_description")
else()
  set(ROBOTIQ_DESCRIPTION_SHARE "${ROBOTIQ_DESCRIPTION_PATH}")
endif()

set(MC_ROBOTIQ_GRIPPER_SHARE_DIR
    "${CMAKE_INSTALL_PREFIX}/share/mc_robotiq_gripper")
set(MC_ROBOTIQ_GRIPPER_URDF_DIR "${MC_ROBOTIQ_GRIPPER_SHARE_DIR}/urdf")

set(ROBOTIQ_DESCRIPTION_PATH "${MC_ROBOTIQ_GRIPPER_SHARE_DIR}")

# Glob all xacro files for dependency tracking
file(GLOB_RECURSE ROBOTIQ_XACRO_FILES "${ROBOTIQ_DESCRIPTION_SHARE}/*.xacro")

# Models to generate
set(ROBOTIQ_MODELS "robotiq_2f_85_gripper" "robotiq_2f_140_gripper")

set(GENERATED_URDF_FILES "")

foreach(MODEL ${ROBOTIQ_MODELS})
  set(XACRO_IN "${ROBOTIQ_DESCRIPTION_SHARE}/urdf/${MODEL}.urdf.xacro")
  set(URDF_OUT "${CMAKE_CURRENT_BINARY_DIR}/urdf/${MODEL}.urdf")

  message(STATUS "URDF generation: ${XACRO_IN} -> ${URDF_OUT}")

  add_custom_command(
    OUTPUT ${URDF_OUT}
    COMMAND ${CMAKE_COMMAND} -E make_directory ${CMAKE_CURRENT_BINARY_DIR}/urdf
    COMMAND
      ${CMAKE_COMMAND} -E env
      "AMENT_PREFIX_PATH=/usr/local:$ENV{AMENT_PREFIX_PATH}" ${XACRO}
      ${XACRO_IN} -o ${URDF_OUT}
    DEPENDS ${XACRO_IN} ${ROBOTIQ_XACRO_FILES}
    COMMENT "Generating URDF for ${MODEL}"
    VERBATIM)

  list(APPEND GENERATED_URDF_FILES ${URDF_OUT})

endforeach()

add_custom_target(generate-robotiq-urdf ALL DEPENDS ${GENERATED_URDF_FILES})

add_subdirectory(src)

if(BUILD_TESTING)
  add_subdirectory(tests)
endif()

install(FILES ${GENERATED_URDF_FILES}
        DESTINATION ${MC_ROBOTIQ_GRIPPER_URDF_DIR})
