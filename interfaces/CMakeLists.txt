file(GLOB modules "${CMAKE_CURRENT_SOURCE_DIR}/*")

foreach(mod ${modules})
    if(IS_DIRECTORY ${mod})
        add_subdirectory(${mod})
    endif()
endforeach()