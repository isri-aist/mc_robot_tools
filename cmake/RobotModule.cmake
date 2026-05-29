macro(generate_robot_description NAME)
  set(DATA_DIR "${CMAKE_INSTALL_PREFIX}/share/${NAME}")
  set(calib_DIR "${DATA_DIR}/calib")
  set(meshes_DIR "${DATA_DIR}/meshes")
  set(rsdf_DIR "${DATA_DIR}/rsdf")

  configure_file(${CMAKE_CURRENT_SOURCE_DIR}/urdf/${NAME}.in.urdf
                 "${CMAKE_CURRENT_BINARY_DIR}/urdf/${NAME}.urdf")
  install(FILES "${CMAKE_CURRENT_BINARY_DIR}/urdf/${NAME}.urdf"
          DESTINATION "${DATA_DIR}/urdf")
  install(
    DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}/rsdf/${NAME}
    DESTINATION "${rsdf_DIR}"
    FILES_MATCHING
    PATTERN "*.rsdf")
  install(
    DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}/meshes/${NAME}
    DESTINATION "${meshes_DIR}"
    FILES_MATCHING
    PATTERN "*.stl"
    PATTERN "*.STL"
    PATTERN "*.dae"
    PATTERN "*.DAE")
endmacro(generate_robot_description)

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
