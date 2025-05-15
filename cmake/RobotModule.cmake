    function(generate_convex MESH_INPUT_FOLDER CONVEX_OUTPUT_FOLDER)
        file(GLOB_RECURSE MESH_FILES
            ${MESH_INPUT_FOLDER}/*.obj
            ${MESH_INPUT_FOLDER}/*.ply
            ${MESH_INPUT_FOLDER}/*.stl
            ${MESH_INPUT_FOLDER}/*.STL
        )

        if(NOT MESH_FILES)
            message(WARNING "No mesh files (obj, ply, stl, STL) found in folder: ${MESH_INPUT_FOLDER}")
            return()
        endif()

        set(SAMPLED_OUTPUT_FOLDER ${CMAKE_CURRENT_BINARY_DIR}/mesh_outputs)
        file(MAKE_DIRECTORY ${SAMPLED_OUTPUT_FOLDER})
        file(MAKE_DIRECTORY ${CONVEX_OUTPUT_FOLDER})

        set(ALL_QHULL_OUTPUTS "")

        foreach(MESH_FILE ${MESH_FILES})
            get_filename_component(FILENAME_WE ${MESH_FILE} NAME_WE)

            set(SAMPLED_OUTPUT ${SAMPLED_OUTPUT_FOLDER}/${FILENAME_WE}.qc)
            set(QHULL_OUTPUT ${CONVEX_OUTPUT_FOLDER}/${FILENAME_WE}-ch.txt)

            add_custom_command(
                OUTPUT ${SAMPLED_OUTPUT}
                COMMAND ${CMAKE_INSTALL_PREFIX}/bin/mesh_sampling ${MESH_FILE} ${SAMPLED_OUTPUT} --type xyz --samples 4000
                COMMENT "Sampling mesh: ${MESH_FILE}"
            )

            set(QCONVEX_PROGRAM)
            if(INSTALL_3rd_PARTY)
                set(QCONVEX_PROGRAM ${CMAKE_INSTALL_PREFIX}/bin/qconvex)
            else()
                find_program(QCONVEX_PROGRAM qconvex REQUIRED)
            endif()

            add_custom_command(
                OUTPUT ${QHULL_OUTPUT}
                COMMAND ${QCONVEX_PROGRAM} TI ${SAMPLED_OUTPUT} TO ${QHULL_OUTPUT} Qt o f
                COMMAND ${CMAKE_COMMAND} -E rm -f ${SAMPLED_OUTPUT}
                DEPENDS ${SAMPLED_OUTPUT}
                COMMENT "Computing convex hull: ${QHULL_OUTPUT}"
            )

            list(APPEND ALL_QHULL_OUTPUTS ${QHULL_OUTPUT})
        endforeach()

    string(REPLACE "/" "_" TARGET_SUFFIX ${MESH_INPUT_FOLDER})
    string(REPLACE "\\" "_" TARGET_SUFFIX ${TARGET_SUFFIX}) 

    add_custom_target(generate_convex_${TARGET_SUFFIX} ALL
        DEPENDS ${ALL_QHULL_OUTPUTS}
    )
endfunction()

macro(generate_robot_description NAME)
  set(DATA_DIR "${CMAKE_INSTALL_PREFIX}/share/${NAME}")
  set(calib_DIR "${DATA_DIR}/calib")
  set(meshes_DIR "${DATA_DIR}/meshes")
  set(convex_DIR "${DATA_DIR}/convex")
  set(rsdf_DIR "${DATA_DIR}/rsdf")

  generate_convex(${CMAKE_CURRENT_SOURCE_DIR}/meshes/${NAME} ${convex_DIR})

  configure_file(${CMAKE_CURRENT_SOURCE_DIR}/urdf/${NAME}.in.urdf "${CMAKE_CURRENT_BINARY_DIR}/urdf/${NAME}.urdf")
  install(FILES "${CMAKE_CURRENT_BINARY_DIR}/urdf/${NAME}.urdf" DESTINATION "${DATA_DIR}/urdf")
  install(DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}/rsdf/${NAME} DESTINATION "${rsdf_DIR}" FILES_MATCHING PATTERN "*.rsdf")
  install(DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}/meshes/${NAME} DESTINATION "${meshes_DIR}" FILES_MATCHING PATTERN "*.stl" PATTERN "*.STL" PATTERN "*.dae" PATTERN "*.DAE")
endmacro(generate_robot_description)

macro(add_yaml_module NAME)
  configure_file(${CMAKE_CURRENT_SOURCE_DIR}/yaml/${NAME}.in.yaml "${CMAKE_CURRENT_BINARY_DIR}/yaml/${NAME}.yaml")
  configure_file(${CMAKE_CURRENT_SOURCE_DIR}/alias/${NAME}.in.yaml "${CMAKE_CURRENT_BINARY_DIR}/alias/${NAME}.yaml")
  # Install the alias and yaml
  install(FILES "${CMAKE_CURRENT_BINARY_DIR}/alias/${NAME}.yaml" DESTINATION "${MC_ROBOTS_ALIASES_DIRECTORY}")
  install(FILES "${CMAKE_CURRENT_BINARY_DIR}/yaml/${NAME}.yaml" DESTINATION "${DATA_DIR}/yaml")
endmacro()
