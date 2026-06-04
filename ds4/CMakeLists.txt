cmake_minimum_required(VERSION 3.22)
mc_rtc_setup_package(ds4 1.0.0)

mc_rtc_generate_urdf(
  generate-ds4-urdf
  TEMPLATE_DIR
  "${CMAKE_CURRENT_SOURCE_DIR}/urdf"
  MODELS
  ds4
  MESHES
  "${CMAKE_CURRENT_SOURCE_DIR}/meshes")

mc_rtc_finalize_package()
