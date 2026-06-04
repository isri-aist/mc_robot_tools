macro(generate_robot_description NAME)
  set(DATA_DIR "${CMAKE_INSTALL_PREFIX}/share/${NAME}")
  set(calib_DIR "${DATA_DIR}/calib")
  set(meshes_DIR "${DATA_DIR}/meshes")
  set(rsdf_DIR "${DATA_DIR}/rsdf")

  # ── URDF generation ── Priority: .in.urdf → .urdf.xacro.in → .urdf.xacro →
  # .urdf (pre-built)
  if(EXISTS "${CMAKE_CURRENT_SOURCE_DIR}/urdf/${NAME}.in.urdf")
    # Template URDF: substitute CMake variables
    configure_file("${CMAKE_CURRENT_SOURCE_DIR}/urdf/${NAME}.in.urdf"
                   "${CMAKE_CURRENT_BINARY_DIR}/urdf/${NAME}.urdf")

  elseif(EXISTS "${CMAKE_CURRENT_SOURCE_DIR}/urdf/${NAME}.urdf.xacro.in")
    # Template xacro: configure_file first, then run xacro
    find_program(XACRO xacro REQUIRED)
    configure_file("${CMAKE_CURRENT_SOURCE_DIR}/urdf/${NAME}.urdf.xacro.in"
                   "${CMAKE_CURRENT_BINARY_DIR}/xacro/${NAME}.urdf.xacro" @ONLY)
    file(GLOB_RECURSE _XACRO_DEPS "${CMAKE_CURRENT_SOURCE_DIR}/xacro/*.xacro")
    add_custom_command(
      OUTPUT "${CMAKE_CURRENT_BINARY_DIR}/urdf/${NAME}.urdf"
      COMMAND ${CMAKE_COMMAND} -E make_directory
              "${CMAKE_CURRENT_BINARY_DIR}/urdf"
      COMMAND ${XACRO} "${CMAKE_CURRENT_BINARY_DIR}/xacro/${NAME}.urdf.xacro" -o
              "${CMAKE_CURRENT_BINARY_DIR}/urdf/${NAME}.urdf"
      DEPENDS "${CMAKE_CURRENT_BINARY_DIR}/xacro/${NAME}.urdf.xacro"
              ${_XACRO_DEPS}
      COMMENT "xacro (from .in) -> ${NAME}.urdf"
      VERBATIM)
    # Custom target so it's always built
    add_custom_target(generate-${NAME}-urdf ALL
                      DEPENDS "${CMAKE_CURRENT_BINARY_DIR}/urdf/${NAME}.urdf")

  elseif(EXISTS "${CMAKE_CURRENT_SOURCE_DIR}/urdf/${NAME}.urdf.xacro")
    # Plain xacro: run xacro directly
    find_program(XACRO xacro REQUIRED)
    file(GLOB_RECURSE _XACRO_DEPS "${CMAKE_CURRENT_SOURCE_DIR}/xacro/*.xacro")
    add_custom_command(
      OUTPUT "${CMAKE_CURRENT_BINARY_DIR}/urdf/${NAME}.urdf"
      COMMAND ${CMAKE_COMMAND} -E make_directory
              "${CMAKE_CURRENT_BINARY_DIR}/urdf"
      COMMAND ${XACRO} "${CMAKE_CURRENT_SOURCE_DIR}/urdf/${NAME}.urdf.xacro" -o
              "${CMAKE_CURRENT_BINARY_DIR}/urdf/${NAME}.urdf"
      DEPENDS "${CMAKE_CURRENT_SOURCE_DIR}/urdf/${NAME}.urdf.xacro"
              ${_XACRO_DEPS}
      COMMENT "xacro -> ${NAME}.urdf"
      VERBATIM)
    add_custom_target(generate-${NAME}-urdf ALL
                      DEPENDS "${CMAKE_CURRENT_BINARY_DIR}/urdf/${NAME}.urdf")

  else()
    message(
      FATAL_ERROR
        "No URDF source found for ${NAME}. Expected one of:\n"
        "  urdf/${NAME}.in.urdf\n" "  urdf/${NAME}.urdf.xacro.in\n"
        "  urdf/${NAME}.urdf.xacro")
  endif()

  install(FILES "${CMAKE_CURRENT_BINARY_DIR}/urdf/${NAME}.urdf"
          DESTINATION "${DATA_DIR}/urdf")

  # ── RSDF ──
  install(
    DIRECTORY "${CMAKE_CURRENT_SOURCE_DIR}/rsdf/${NAME}"
    DESTINATION "${rsdf_DIR}"
    FILES_MATCHING
    PATTERN "*.rsdf")

  # ── Meshes ──
  install(
    DIRECTORY "${CMAKE_CURRENT_SOURCE_DIR}/meshes/${NAME}"
    DESTINATION "${meshes_DIR}"
    FILES_MATCHING
    PATTERN "*.stl"
    PATTERN "*.STL"
    PATTERN "*.dae"
    PATTERN "*.DAE")
endmacro()

macro(add_yaml_module NAME)
  configure_file(${CMAKE_CURRENT_SOURCE_DIR}/yaml/${NAME}.in.yaml
                 "${CMAKE_CURRENT_BINARY_DIR}/yaml/${NAME}.yaml")
  configure_file(${CMAKE_CURRENT_SOURCE_DIR}/alias/${NAME}.in.yaml
                 "${CMAKE_CURRENT_BINARY_DIR}/alias/${NAME}.yaml")
  # Install the alias and yaml
  install(FILES "${CMAKE_CURRENT_BINARY_DIR}/alias/${NAME}.yaml"
          DESTINATION "${MC_ROBOTS_ALIASES_DIRECTORY}")
  install(FILES "${CMAKE_CURRENT_BINARY_DIR}/yaml/${NAME}.yaml"
          DESTINATION "${DATA_DIR}/yaml")
endmacro()
