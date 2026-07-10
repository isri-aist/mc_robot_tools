cmake_minimum_required(VERSION 3.22)

set(ROBOT_NAME bota_sensor)

project(
  mc_${ROBOT_NAME}
  LANGUAGES CXX
  VERSION 1.0.0)

set(CXX_DISABLE_WERROR 1)
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

include(CTest)

find_package(mc_rtc REQUIRED)

find_description_package(bota_driver REQUIRED)

if(EXISTS "${BOTA_DRIVER_PATH}/share/bota_driver")
  set(BOTA_DRIVER_SHARE "${BOTA_DRIVER_PATH}/share/bota_driver")
else()
  set(BOTA_DRIVER_SHARE "${BOTA_DRIVER_PATH}")
endif()

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

mc_rtc_generate_robot_description(
  XACRO_PATH
  "${BOTA_DRIVER_SHARE}/urdf"
  MODELS
  ${BOTA_MODELS}
  WRAPPER_TEMPLATE
  "${CMAKE_CURRENT_SOURCE_DIR}/xacro/wrapper.urdf.xacro.in"
  LOWERCASE)

mc_rtc_generate_robot_module()
