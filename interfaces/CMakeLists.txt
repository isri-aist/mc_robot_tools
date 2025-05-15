file(GLOB interfaces "${CMAKE_CURRENT_SOURCE_DIR}/*")

foreach(interface ${interfaces})
    if(IS_DIRECTORY ${interface})
        add_subdirectory(${interface})
    endif()
endforeach()