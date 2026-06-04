configure_file(config.in.h "${CMAKE_CURRENT_BINARY_DIR}/config.h")

set(DS4_SRC "${CMAKE_CURRENT_SOURCE_DIR}/ds4.cpp")
set(DS4_HDR "${CMAKE_CURRENT_SOURCE_DIR}/ds4.h")

add_robot(ds4 ${DS4_SRC} ${DS4_HDR})

target_include_directories(ds4 PRIVATE "${CMAKE_CURRENT_SOURCE_DIR}"
                                       "${CMAKE_CURRENT_BINARY_DIR}")
