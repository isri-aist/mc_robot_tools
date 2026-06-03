cmake_minimum_required(VERSION 3.22)

set(CXX_DISABLE_WERROR 1)
set(CMAKE_CXX_STANDARD 17)

set(PROJECT_NAME mc_bota_sensor)
set(PROJECT_VERSION 1.0.0)
project(
  ${PROJECT_NAME}
  LANGUAGES CXX
  VERSION ${PROJECT_VERSION})

set(CMAKE_EXPORT_COMPILE_COMMANDS ON)
include(CTest)

find_package(mc_rtc REQUIRED)
find_program(XACRO xacro REQUIRED)

find_description_package(bota_driver REQUIRED)

# Resolve the actual share path
if(EXISTS "${BOTA_DRIVER_PATH}/share/bota_driver")
  set(BOTA_DRIVER_SHARE "${BOTA_DRIVER_PATH}/share/bota_driver")
else()
  set(BOTA_DRIVER_SHARE "${BOTA_DRIVER_PATH}")
endif()

set(MC_BOTA_SENSOR_SHARE_DIR "${CMAKE_INSTALL_PREFIX}/share/${PROJECT_NAME}")
set(MC_BOTA_SENSOR_URDF_DIR "${MC_BOTA_SENSOR_SHARE_DIR}/urdf")
set(MC_BOTA_SENSOR_RSDF_DIR "${MC_BOTA_SENSOR_SHARE_DIR}/rsdf")

set(BOTA_DRIVER_PATH "${MC_BOTA_SENSOR_SHARE_DIR}")

file(GLOB_RECURSE BOTA_XACRO_FILES "${BOTA_DRIVER_SHARE}/urdf/*.xacro")

set(BOTA_MODELS
    BFT_KG3_IND2_SW
    BFT_MEDS_ECAT_M8
    BFT_MEGS_SER_M8
    BFT_MN2S_SER_UB
    BFT_ROKS_SER_M8
    BFT_LAXS_ECAT_M8
    BFT_MEDS_SER_M8
    BFT_MIPS_ECAT_CG
    BFT_ROKS_CAT2_B4
    BFT_SENS_ECAT_M8
    BFT_LAXS_SER_M8
    BFT_MEGS_ECAT_M8
    BFT_MIPS_SER_CG
    BFT_ROKS_ECAT_M8
    BFT_SENS_SER_M8)

set(GENERATED_URDF_FILES "")
set(GENERATED_RSDF_FILES "")

foreach(MODEL ${BOTA_MODELS})
  string(TOLOWER ${MODEL} MODEL_LOWER)

  # ── URDF (existing) ──
  set(XACRO_IN "${BOTA_DRIVER_SHARE}/urdf/${MODEL}.urdf.xacro")
  set(WRAPPER_XACRO
      "${CMAKE_CURRENT_BINARY_DIR}/xacro/${MODEL_LOWER}.urdf.xacro")
  configure_file("${CMAKE_CURRENT_SOURCE_DIR}/xacro/wrapper.urdf.xacro.in"
                 "${WRAPPER_XACRO}" @ONLY)

  set(URDF_OUT "${CMAKE_CURRENT_BINARY_DIR}/urdf/${MODEL_LOWER}.urdf")
  add_custom_command(
    OUTPUT ${URDF_OUT}
    COMMAND ${CMAKE_COMMAND} -E make_directory ${CMAKE_CURRENT_BINARY_DIR}/urdf
    COMMAND
      ${CMAKE_COMMAND} -E env
      "AMENT_PREFIX_PATH=/usr/local:$ENV{AMENT_PREFIX_PATH}" ${XACRO}
      ${WRAPPER_XACRO} -o ${URDF_OUT}
    DEPENDS ${WRAPPER_XACRO} ${BOTA_XACRO_FILES}
    COMMENT "Generating URDF for ${MODEL_LOWER}"
    VERBATIM)
  list(APPEND GENERATED_URDF_FILES ${URDF_OUT})

  # ── RSDF ──
  set(RSDF_OUT
      "${CMAKE_CURRENT_BINARY_DIR}/rsdf/${MODEL_LOWER}/${MODEL_LOWER}.rsdf")
  configure_file("${CMAKE_CURRENT_SOURCE_DIR}/rsdf/wrapper.rsdf.in"
                 "${RSDF_OUT}" @ONLY)
  list(APPEND GENERATED_RSDF_FILES ${RSDF_OUT})

endforeach()

add_custom_target(generate-bota-urdf ALL DEPENDS ${GENERATED_URDF_FILES})
add_custom_target(generate-bota-rsdf ALL DEPENDS ${GENERATED_RSDF_FILES})

add_subdirectory(src)

install(FILES ${GENERATED_URDF_FILES} DESTINATION ${MC_BOTA_SENSOR_URDF_DIR})

# Each model gets its own rsdf subdirectory
foreach(MODEL ${BOTA_MODELS})
  string(TOLOWER ${MODEL} MODEL_LOWER)
  install(DIRECTORY "${CMAKE_CURRENT_BINARY_DIR}/rsdf/${MODEL_LOWER}/"
          DESTINATION "${MC_BOTA_SENSOR_RSDF_DIR}/${MODEL_LOWER}")
endforeach()

# install(DIRECTORY "${BOTA_DRIVER_SHARE}/meshes/" DESTINATION
# "${MC_BOTA_SENSOR_SHARE_DIR}/meshes")

if(BUILD_TESTING)
  add_subdirectory(tests)
endif()
