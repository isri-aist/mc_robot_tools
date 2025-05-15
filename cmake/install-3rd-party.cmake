include(ExternalProject)

ExternalProject_Add(mesh_sampling
    GIT_REPOSITORY    https://github.com/jrl-umi3218/mesh_sampling.git
    GIT_TAG           master
    SOURCE_DIR        ${PROJECT_SOURCE_DIR}/3rd-party/mesh_sampling
    UPDATE_DISCONNECTED TRUE
    GIT_SHALLOW       TRUE
    CMAKE_ARGS        -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE} -DCMAKE_INSTALL_PREFIX=${CMAKE_INSTALL_PREFIX}
)

ExternalProject_Get_Property(mesh_sampling BINARY_DIR)
set(MESH_SAMPLING_BINARY ${BINARY_DIR})

ExternalProject_Add(qhull
    GIT_REPOSITORY    https://github.com/qhull/qhull.git
    GIT_TAG           master
    SOURCE_DIR        ${PROJECT_SOURCE_DIR}/3rd-party/qhull
    UPDATE_DISCONNECTED TRUE
    GIT_SHALLOW       TRUE
    CMAKE_ARGS        -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE} -DCMAKE_INSTALL_PREFIX=${CMAKE_INSTALL_PREFIX}
)

ExternalProject_Get_Property(qhull BINARY_DIR)
set(QHULL_BINARY ${BINARY_DIR})