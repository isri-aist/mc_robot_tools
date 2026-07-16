# cmake/mc_rtc_macros.cmake
#
# Reusable macros for building mc_rtc tool modules.
#
# Provides: mc_rtc_generate_robot_description(...)
# mc_rtc_generate_robot_module()
#
# Each tool module is a standard CMake project: write cmake_minimum_required(),
# project(), find_package(mc_rtc REQUIRED), etc. directly in the module's
# CMakeLists.txt, then call the macros below.
#

# ─────────────────────────────────────────────────────────────────────────────
# mc_rtc_generate_robot_description(MODELS <model1> [model2 ...] [TARGET_NAME
# <name>] [PARENT_PATH <path>] [XACRO_PATH <path>] [URDF_DIR <path>]
# [XACRO_IN_TEMPLATE <template>] [WRAPPER_TEMPLATE <wrapper.in>] [RSDF_DIR
# <path>] [MESHES <path>] [LOWERCASE] )
#
# PARENT_PATH defaults to CMAKE_CURRENT_SOURCE_DIR. Unless given explicitly,
# XACRO_PATH/URDF_DIR/RSDF_DIR/MESHES default to PARENT_PATH's xacro/, urdf/,
# rsdf/ and meshes/ subfolders (whichever exist), and TARGET_NAME defaults to
# "generate-<name of PARENT_PATH's folder>-urdf", so a module whose layout
# follows the convention can call this with just MODELS. Passing PARENT_PATH
# lets a module describe a robot living in another directory (this also changes
# the default TARGET_NAME); passing any of
# TARGET_NAME/XACRO_PATH/URDF_DIR/RSDF_DIR/MESHES explicitly overrides its
# default (e.g. an XACRO_PATH pointing at an upstream ROS description package).
#
# URDF generation strategies (auto-detected per model, in this order):
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
# 1. URDF_DIR (.in.urdf) Pure CMake configure_file() on
#   "${URDF_DIR}/<model>.in.urdf". No xacro involved.
#
# RSDF_DIR handling: if it contains a "*.rsdf.in" wrapper template, generate a
# per-model rsdf from it (uses @MODEL@, @MODEL_LOWER@), installed to
# ${MC_RSDF_DIR}/<model>/. Otherwise install it as a static directory, as-is, to
# ${MC_RSDF_DIR}.
#
# MESHES           - install meshes from this directory to ${MC_MESH_DIR}
# LOWERCASE        - lowercase the output filenames
#
# Also defines, in the caller's scope: MC_SHARE_DIR =
# ${CMAKE_INSTALL_PREFIX}/share/${PROJECT_NAME} MC_URDF_DIR   =
# ${MC_SHARE_DIR}/urdf MC_RSDF_DIR   = ${MC_SHARE_DIR}/rsdf MC_MESH_DIR   =
# ${MC_SHARE_DIR}/meshes MC_DATA_PATH  = ${MC_SHARE_DIR}  (for config.in.h)
# ─────────────────────────────────────────────────────────────────────────────
function(mc_rtc_generate_robot_description)
  cmake_parse_arguments(
    _arg
    "LOWERCASE"
    "TARGET_NAME;PARENT_PATH;XACRO_PATH;XACRO_IN_TEMPLATE;WRAPPER_TEMPLATE;RSDF_DIR;URDF_DIR;MESHES"
    "MODELS"
    ${ARGN})

  if(NOT _arg_MODELS)
    message(
      FATAL_ERROR "mc_rtc_generate_robot_description(): MODELS is required")
  endif()

  if(NOT _arg_PARENT_PATH)
    set(_arg_PARENT_PATH "${CMAKE_CURRENT_SOURCE_DIR}")
  endif()

  if(NOT _arg_TARGET_NAME)
    get_filename_component(_folder_name "${_arg_PARENT_PATH}" NAME)
    set(_arg_TARGET_NAME "generate-${_folder_name}-urdf")
  endif()
  set(TARGET_NAME "${_arg_TARGET_NAME}")

  # ── Default subfolders, relative to PARENT_PATH ──
  if(NOT _arg_XACRO_PATH AND NOT _arg_URDF_DIR)
    if(EXISTS "${_arg_PARENT_PATH}/xacro")
      set(_arg_XACRO_PATH "${_arg_PARENT_PATH}/xacro")
    elseif(EXISTS "${_arg_PARENT_PATH}/urdf")
      set(_arg_URDF_DIR "${_arg_PARENT_PATH}/urdf")
    endif()
  endif()
  if(NOT _arg_RSDF_DIR AND EXISTS "${_arg_PARENT_PATH}/rsdf")
    set(_arg_RSDF_DIR "${_arg_PARENT_PATH}/rsdf")
  endif()
  if(NOT _arg_MESHES AND EXISTS "${_arg_PARENT_PATH}/meshes")
    set(_arg_MESHES "${_arg_PARENT_PATH}/meshes")
  endif()

  if(NOT _arg_XACRO_PATH AND NOT _arg_URDF_DIR)
    message(
      FATAL_ERROR
        "mc_rtc_generate_robot_description(${TARGET_NAME}): must specify XACRO_PATH or URDF_DIR (or provide a xacro/ or urdf/ folder under PARENT_PATH)"
    )
  endif()

  if(_arg_XACRO_PATH)
    find_program(XACRO xacro REQUIRED)
  endif()

  # RSDF_DIR is either a per-model wrapper template or a static directory
  set(_RSDF_WRAPPER "")
  if(_arg_RSDF_DIR)
    file(GLOB _RSDF_WRAPPER_CANDIDATES "${_arg_RSDF_DIR}/*.rsdf.in")
    if(_RSDF_WRAPPER_CANDIDATES)
      list(GET _RSDF_WRAPPER_CANDIDATES 0 _RSDF_WRAPPER)
    endif()
  endif()

  # Standard install directories, exposed to the caller's scope
  set(MC_SHARE_DIR "${CMAKE_INSTALL_PREFIX}/share/${PROJECT_NAME}")
  set(MC_URDF_DIR "${MC_SHARE_DIR}/urdf")
  set(MC_RSDF_DIR "${MC_SHARE_DIR}/rsdf")
  set(MC_MESH_DIR "${MC_SHARE_DIR}/meshes")
  set(MC_DATA_PATH "${MC_SHARE_DIR}")
  set(MC_SHARE_DIR
      "${MC_SHARE_DIR}"
      PARENT_SCOPE)
  set(MC_URDF_DIR
      "${MC_URDF_DIR}"
      PARENT_SCOPE)
  set(MC_RSDF_DIR
      "${MC_RSDF_DIR}"
      PARENT_SCOPE)
  set(MC_MESH_DIR
      "${MC_MESH_DIR}"
      PARENT_SCOPE)
  set(MC_DATA_PATH
      "${MC_DATA_PATH}"
      PARENT_SCOPE)

  # Collect xacro dependencies for rebuild tracking
  set(_XACRO_DEPS "")
  if(_arg_XACRO_PATH)
    file(GLOB_RECURSE _XACRO_DEPS "${_arg_XACRO_PATH}/*.xacro")
  endif()
  # Also pick up local xacro deps if any
  if(EXISTS "${_arg_PARENT_PATH}/xacro")
    file(GLOB_RECURSE _LOCAL_XACRO_DEPS "${_arg_PARENT_PATH}/xacro/*.xacro")
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

    elseif(_arg_URDF_DIR)
      # Strategy 4: .in.urdf configure_file
      configure_file("${_arg_URDF_DIR}/${MODEL}.in.urdf" "${URDF_OUT}")

    endif()

    list(APPEND _GENERATED_URDFS "${URDF_OUT}")

    # ── RSDF (per-model template, if RSDF_DIR holds a *.rsdf.in wrapper) ──
    if(_RSDF_WRAPPER)
      set(RSDF_OUT
          "${CMAKE_CURRENT_BINARY_DIR}/rsdf/${MODEL_OUT}/${MODEL_OUT}.rsdf")
      configure_file("${_RSDF_WRAPPER}" "${RSDF_OUT}" @ONLY)
      list(APPEND _GENERATED_RSDFS "${RSDF_OUT}")

      install(DIRECTORY "${CMAKE_CURRENT_BINARY_DIR}/rsdf/${MODEL_OUT}/"
              DESTINATION "${MC_RSDF_DIR}/${MODEL_OUT}")
    endif()
  endforeach()

  # ── URDF build target + install ──
  add_custom_target(${TARGET_NAME} ALL DEPENDS ${_GENERATED_URDFS})
  install(FILES ${_GENERATED_URDFS} DESTINATION "${MC_URDF_DIR}")

  # ── RSDF: static directory install (when RSDF_DIR isn't a template) ──
  if(_arg_RSDF_DIR AND NOT _RSDF_WRAPPER)
    install(DIRECTORY "${_arg_RSDF_DIR}/" DESTINATION "${MC_RSDF_DIR}")
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
# mc_rtc_generate_robot_module()
#
# Auto-discovers and adds the src/, yaml/ and tests/ subdirectories if they
# exist.
#
# A robot module can be implemented either as a C++ module (src/, built with
# add_robot()) or as a YAML module (yaml/, no C++ involved — see
# https://github.com/mc-rtc/new-robot-module/ for the expected
# yaml/CMakeLists.txt layout: configure_file() the robot description onto
# ${MC_SHARE_DIR}, then configure_file() + install() an alias entry to
# ${MC_ROBOTS_ALIASES_DIRECTORY}). Both may coexist in the same module.
# ─────────────────────────────────────────────────────────────────────────────
macro(mc_rtc_generate_robot_module)
  if(EXISTS "${CMAKE_CURRENT_SOURCE_DIR}/src/CMakeLists.txt")
    add_subdirectory(src)
  endif()

  if(EXISTS "${CMAKE_CURRENT_SOURCE_DIR}/yaml/CMakeLists.txt")
    add_subdirectory(yaml)
  endif()

  if(BUILD_TESTING AND EXISTS
                       "${CMAKE_CURRENT_SOURCE_DIR}/tests/CMakeLists.txt")
    add_subdirectory(tests)
  endif()
endmacro()
