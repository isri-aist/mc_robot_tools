# cmake/mc_rtc_macros.cmake
#
# Reusable macros for building mc_rtc tool modules.
#
# Provides: mc_rtc_setup_package(PROJECT_NAME VERSION)
# mc_rtc_generate_urdf(TARGET_NAME ...) mc_rtc_finalize_package()
#

# ─────────────────────────────────────────────────────────────────────────────
# mc_rtc_setup_package(PROJECT_NAME VERSION)
#
# Call after cmake_minimum_required(). Sets up project, finds mc_rtc, xacro, and
# defines standard install directories.
#
# Provides: MC_SHARE_DIR  = ${CMAKE_INSTALL_PREFIX}/share/${PROJECT_NAME}
# MC_URDF_DIR   = ${MC_SHARE_DIR}/urdf MC_RSDF_DIR   = ${MC_SHARE_DIR}/rsdf
# MC_MESH_DIR   = ${MC_SHARE_DIR}/meshes MC_DATA_PATH  = ${MC_SHARE_DIR}  (for
# config.in.h)
# ─────────────────────────────────────────────────────────────────────────────
macro(mc_rtc_setup_package PROJECT_NAME VERSION)
  set(CXX_DISABLE_WERROR 1)
  set(CMAKE_CXX_STANDARD 17)
  set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

  project(
    ${PROJECT_NAME}
    LANGUAGES CXX
    VERSION ${VERSION})

  include(CTest)

  find_package(mc_rtc REQUIRED)
  find_program(XACRO xacro REQUIRED)

  # Standard directories
  set(MC_SHARE_DIR "${CMAKE_INSTALL_PREFIX}/share/${PROJECT_NAME}")
  set(MC_URDF_DIR "${MC_SHARE_DIR}/urdf")
  set(MC_RSDF_DIR "${MC_SHARE_DIR}/rsdf")
  set(MC_MESH_DIR "${MC_SHARE_DIR}/meshes")
  set(MC_DATA_PATH "${MC_SHARE_DIR}")
endmacro()

# ─────────────────────────────────────────────────────────────────────────────
# mc_rtc_generate_urdf(TARGET_NAME MODELS <model1> [model2 ...] { XACRO_PATH
# <path> | TEMPLATE_DIR <path> } [XACRO_IN_TEMPLATE <template>]
# [WRAPPER_TEMPLATE <wrapper.in>] [RSDF_TEMPLATE <rsdf.in>] [RSDF_DIR <path>]
# [MESHES <path>] [LOWERCASE] )
#
# URDF generation strategies (auto-detected per model):
#
# 1. WRAPPER_TEMPLATE + XACRO_PATH For upstream xacro files that define macros
#   (e.g. bota_driver). configure_file() on the wrapper, then run xacro. The
#   wrapper template can use @MODEL@, @MODEL_LOWER@, @XACRO_IN@.
#
# 1. XACRO_IN_TEMPLATE + XACRO_PATH For xacro files that need CMake variable
#   substitution before xacro. Pattern: "${XACRO_PATH}/@MODEL@.urdf.xacro.in"
#   (or custom template). configure_file(@ONLY), then run xacro.
#
# 1. XACRO_PATH (plain xacro) Run xacro directly on
#   "${XACRO_PATH}/<model>.urdf.xacro". Used for local or upstream xacro files
#   that work standalone.
#
# 1. TEMPLATE_DIR (.in.urdf) Pure CMake configure_file() on
#   "${TEMPLATE_DIR}/<model>.in.urdf". No xacro involved.
#
# RSDF handling: RSDF_TEMPLATE  - generate per-model rsdf from template (uses
# @MODEL@, @MODEL_LOWER@). Installed to ${MC_RSDF_DIR}/<model>/ RSDF_DIR       -
# install static rsdf directory as-is to ${MC_RSDF_DIR} (neither)      - if
# rsdf/ exists in source dir, install it flat
#
# MESHES           - install meshes from this directory to ${MC_MESH_DIR}
# LOWERCASE        - lowercase the output filenames
# ─────────────────────────────────────────────────────────────────────────────
function(mc_rtc_generate_urdf TARGET_NAME)
  cmake_parse_arguments(
    _arg
    "LOWERCASE"
    "XACRO_PATH;XACRO_IN_TEMPLATE;WRAPPER_TEMPLATE;RSDF_TEMPLATE;RSDF_DIR;TEMPLATE_DIR;MESHES"
    "MODELS"
    ${ARGN})

  if(NOT _arg_MODELS)
    message(
      FATAL_ERROR "mc_rtc_generate_urdf(${TARGET_NAME}): MODELS is required")
  endif()

  if(NOT _arg_XACRO_PATH AND NOT _arg_TEMPLATE_DIR)
    message(
      FATAL_ERROR
        "mc_rtc_generate_urdf(${TARGET_NAME}): must specify XACRO_PATH or TEMPLATE_DIR"
    )
  endif()

  # Collect xacro dependencies for rebuild tracking
  set(_XACRO_DEPS "")
  if(_arg_XACRO_PATH)
    file(GLOB_RECURSE _XACRO_DEPS "${_arg_XACRO_PATH}/*.xacro")
  endif()
  # Also pick up local xacro deps if any
  if(EXISTS "${CMAKE_CURRENT_SOURCE_DIR}/xacro")
    file(GLOB_RECURSE _LOCAL_XACRO_DEPS
         "${CMAKE_CURRENT_SOURCE_DIR}/xacro/*.xacro")
    list(APPEND _XACRO_DEPS ${_LOCAL_XACRO_DEPS})
  endif()

  set(_GENERATED_URDFS "")
  set(_GENERATED_RSDFS "")

  foreach(MODEL ${_arg_MODELS})
    # ── Output name ──
    if(_arg_LOWERCASE)
      string(TOLOWER "${MODEL}" MODEL_LOWER)
    else()
      set(MODEL_LOWER "${MODEL}")
    endif()
    set(MODEL_OUT "${MODEL_LOWER}")

    set(URDF_OUT "${CMAKE_CURRENT_BINARY_DIR}/urdf/${MODEL_OUT}.urdf")

    # ── URDF strategy selection ──
    if(_arg_WRAPPER_TEMPLATE AND _arg_XACRO_PATH)
      # Strategy 1: wrapper template + xacro
      set(XACRO_IN "${_arg_XACRO_PATH}/${MODEL}.urdf.xacro")
      set(WRAPPER_XACRO
          "${CMAKE_CURRENT_BINARY_DIR}/xacro/${MODEL_OUT}.urdf.xacro")
      configure_file("${_arg_WRAPPER_TEMPLATE}" "${WRAPPER_XACRO}" @ONLY)

      add_custom_command(
        OUTPUT "${URDF_OUT}"
        COMMAND ${CMAKE_COMMAND} -E make_directory
                "${CMAKE_CURRENT_BINARY_DIR}/urdf"
        COMMAND
          ${CMAKE_COMMAND} -E env
          "AMENT_PREFIX_PATH=/usr/local:$ENV{AMENT_PREFIX_PATH}" ${XACRO}
          "${WRAPPER_XACRO}" -o "${URDF_OUT}"
        DEPENDS "${WRAPPER_XACRO}" ${_XACRO_DEPS}
        COMMENT "xacro (wrapper) -> ${MODEL_OUT}.urdf"
        VERBATIM)

    elseif(_arg_XACRO_IN_TEMPLATE AND _arg_XACRO_PATH)
      # Strategy 2: configure_file on xacro template, then run xacro
      set(XACRO_IN "${_arg_XACRO_PATH}/${MODEL}.urdf.xacro")
      string(REPLACE "@MODEL@" "${MODEL}" _RESOLVED "${_arg_XACRO_IN_TEMPLATE}")
      string(REPLACE "@MODEL_LOWER@" "${MODEL_OUT}" _RESOLVED "${_RESOLVED}")

      set(_CONFIGURED_XACRO
          "${CMAKE_CURRENT_BINARY_DIR}/xacro/${MODEL_OUT}.urdf.xacro")
      configure_file("${_RESOLVED}" "${_CONFIGURED_XACRO}" @ONLY)

      add_custom_command(
        OUTPUT "${URDF_OUT}"
        COMMAND ${CMAKE_COMMAND} -E make_directory
                "${CMAKE_CURRENT_BINARY_DIR}/urdf"
        COMMAND
          ${CMAKE_COMMAND} -E env
          "AMENT_PREFIX_PATH=/usr/local:$ENV{AMENT_PREFIX_PATH}" ${XACRO}
          "${_CONFIGURED_XACRO}" -o "${URDF_OUT}"
        DEPENDS "${_CONFIGURED_XACRO}" ${_XACRO_DEPS}
        COMMENT "xacro (configured) -> ${MODEL_OUT}.urdf"
        VERBATIM)

    elseif(_arg_XACRO_PATH)
      # Strategy 3: plain xacro
      set(_XACRO_FILE "${_arg_XACRO_PATH}/${MODEL}.urdf.xacro")

      add_custom_command(
        OUTPUT "${URDF_OUT}"
        COMMAND ${CMAKE_COMMAND} -E make_directory
                "${CMAKE_CURRENT_BINARY_DIR}/urdf"
        COMMAND
          ${CMAKE_COMMAND} -E env
          "AMENT_PREFIX_PATH=/usr/local:$ENV{AMENT_PREFIX_PATH}" ${XACRO}
          "${_XACRO_FILE}" -o "${URDF_OUT}"
        DEPENDS "${_XACRO_FILE}" ${_XACRO_DEPS}
        COMMENT "xacro -> ${MODEL_OUT}.urdf"
        VERBATIM)

    elseif(_arg_TEMPLATE_DIR)
      # Strategy 4: .in.urdf configure_file
      configure_file("${_arg_TEMPLATE_DIR}/${MODEL}.in.urdf" "${URDF_OUT}")

    endif()

    list(APPEND _GENERATED_URDFS "${URDF_OUT}")

    # ── RSDF (per-model template) ──
    if(_arg_RSDF_TEMPLATE)
      set(RSDF_OUT
          "${CMAKE_CURRENT_BINARY_DIR}/rsdf/${MODEL_OUT}/${MODEL_OUT}.rsdf")
      configure_file("${_arg_RSDF_TEMPLATE}" "${RSDF_OUT}" @ONLY)
      list(APPEND _GENERATED_RSDFS "${RSDF_OUT}")

      install(DIRECTORY "${CMAKE_CURRENT_BINARY_DIR}/rsdf/${MODEL_OUT}/"
              DESTINATION "${MC_RSDF_DIR}/${MODEL_OUT}")
    endif()
  endforeach()

  # ── URDF build target + install ──
  add_custom_target(${TARGET_NAME} ALL DEPENDS ${_GENERATED_URDFS})
  install(FILES ${_GENERATED_URDFS} DESTINATION "${MC_URDF_DIR}")

  # ── RSDF: static directory install (fallback) ──
  if(NOT _arg_RSDF_TEMPLATE)
    if(_arg_RSDF_DIR)
      install(DIRECTORY "${_arg_RSDF_DIR}/" DESTINATION "${MC_RSDF_DIR}")
    elseif(EXISTS "${CMAKE_CURRENT_SOURCE_DIR}/rsdf")
      install(DIRECTORY "${CMAKE_CURRENT_SOURCE_DIR}/rsdf/"
              DESTINATION "${MC_RSDF_DIR}")
    endif()
  endif()

  # ── RSDF build target (for generated rsdfs) ──
  if(_GENERATED_RSDFS)
    add_custom_target(${TARGET_NAME}-rsdf ALL DEPENDS ${_GENERATED_RSDFS})
  endif()

  # ── Meshes ──
  if(_arg_MESHES)
    install(
      DIRECTORY "${_arg_MESHES}/"
      DESTINATION "${MC_MESH_DIR}"
      FILES_MATCHING
      PATTERN "*.stl"
      PATTERN "*.STL"
      PATTERN "*.dae"
      PATTERN "*.DAE")
  endif()

endfunction()

# ─────────────────────────────────────────────────────────────────────────────
# mc_rtc_finalize_package()
#
# Auto-discovers and adds src/ and tests/ subdirectories if they exist.
# ─────────────────────────────────────────────────────────────────────────────
macro(mc_rtc_finalize_package)
  if(EXISTS "${CMAKE_CURRENT_SOURCE_DIR}/src/CMakeLists.txt")
    add_subdirectory(src)
  endif()

  if(BUILD_TESTING AND EXISTS
                       "${CMAKE_CURRENT_SOURCE_DIR}/tests/CMakeLists.txt")
    add_subdirectory(tests)
  endif()
endmacro()

# ─────────────────────────────────────────────────────────────────────────────
# add_connectable_robot(TARGET SRC HDR)
#
# Wraps mc_rtc's add_robot() and automatically links
# mc_robot_tools::mc_robot_tools so the module can inherit from
# ConnectableRobotModule.
# ─────────────────────────────────────────────────────────────────────────────
macro(add_connectable_robot TARGET SRC HDR)
  add_robot(${TARGET} ${SRC} ${HDR})
  target_link_libraries(${TARGET} PUBLIC mc_robot_tools)
endmacro()
