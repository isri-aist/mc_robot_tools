file(GLOB tools "${CMAKE_CURRENT_SOURCE_DIR}/*")

foreach(tool ${tools})
    if(IS_DIRECTORY ${tool})
        add_subdirectory(${tool})
    endif()
endforeach()