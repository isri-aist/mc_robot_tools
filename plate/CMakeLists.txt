cmake_minimum_required(VERSION 3.22)
mc_rtc_setup_package(plate 1.0.0)

mc_rtc_generate_urdf(
  generate-${PROJECT_NAME}-urdf
  TEMPLATE_DIR
  "${CMAKE_CURRENT_SOURCE_DIR}/urdf"
  MODELS
  ${PROJECT_NAME}
  MESHES
  "${CMAKE_CURRENT_SOURCE_DIR}/meshes")

mc_rtc_finalize_package()
