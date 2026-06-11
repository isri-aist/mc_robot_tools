cmake_minimum_required(VERSION 3.22)

set(ROBOT_NAME realsense_camera)
mc_rtc_setup_package(mc_${ROBOT_NAME} 1.0.0)

set(REALSENSE_MODELS realsense_d435)

mc_rtc_generate_urdf(
  generate-${PROJECT_NAME}-urdf
  TEMPLATE_DIR
  "${CMAKE_CURRENT_SOURCE_DIR}/urdf"
  MODELS
  ${REALSENSE_MODELS}
  MESHES
  "${CMAKE_CURRENT_SOURCE_DIR}/meshes")

mc_rtc_finalize_package()
