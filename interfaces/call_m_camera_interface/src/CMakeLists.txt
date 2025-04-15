
configure_file(${PROJECT_NAME}.in.cpp "${CMAKE_CURRENT_BINARY_DIR}/${PROJECT_NAME}.cpp")
configure_file(config.h.in "${CMAKE_CURRENT_BINARY_DIR}/include/config.h")


add_robot(${PROJECT_NAME} "${CMAKE_CURRENT_BINARY_DIR}/${PROJECT_NAME}.cpp" "${PROJECT_NAME}.h")
# [optinal] add linkage and include dependencies here 
target_include_directories(${PROJECT_NAME} PRIVATE $<BUILD_INTERFACE:${CMAKE_CURRENT_BINARY_DIR}/include>)

target_include_directories(${PROJECT_NAME} PRIVATE "${CMAKE_CURRENT_SOURCE_DIR}")