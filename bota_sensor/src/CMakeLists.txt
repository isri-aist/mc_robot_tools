configure_file(config.in.h "${CMAKE_CURRENT_BINARY_DIR}/config.h")

set(BOTA_SENSOR_SRC "${CMAKE_CURRENT_SOURCE_DIR}/bota_sensor.cpp")
set(BOTA_SENSOR_HDR "${CMAKE_CURRENT_SOURCE_DIR}/bota_sensor.h")

add_robot(bota_sensor ${BOTA_SENSOR_SRC} ${BOTA_SENSOR_HDR})

target_include_directories(bota_sensor PRIVATE "${CMAKE_CURRENT_SOURCE_DIR}"
                                               "${CMAKE_CURRENT_BINARY_DIR}")
