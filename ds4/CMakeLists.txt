cmake_minimum_required(VERSION 3.22)

set(ROBOT_NAME ds4)
mc_rtc_setup_package(mc_${ROBOT_NAME} 1.0.0)

mc_rtc_generate_urdf(
  generate-ds4-urdf
  TEMPLATE_DIR
  "${CMAKE_CURRENT_SOURCE_DIR}/urdf"
  MODELS
  ${ROBOT_NAME}
  MESHES
  "${CMAKE_CURRENT_SOURCE_DIR}/meshes")

mc_rtc_finalize_package()
