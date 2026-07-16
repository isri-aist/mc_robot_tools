configure_file(config.in.h "${CMAKE_CURRENT_BINARY_DIR}/config.h")

set(SRC "${CMAKE_CURRENT_SOURCE_DIR}/${ROBOT_NAME}.cpp")
set(HDR "${CMAKE_CURRENT_SOURCE_DIR}/${ROBOT_NAME}.h")

add_robot(${PROJECT_NAME} ${SRC} ${HDR})

target_include_directories(
  ${PROJECT_NAME} PRIVATE "${CMAKE_CURRENT_SOURCE_DIR}"
                          "${CMAKE_CURRENT_BINARY_DIR}")
