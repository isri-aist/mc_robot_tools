set(TEST_MODELS "Robotiq2f85Gripper" "Robotiq2f140Gripper")

if(TARGET ${PROJECT_NAME})
  foreach(MODEL ${TEST_MODELS})
    string(TOLOWER ${MODEL} MODEL_LOWER)
    set(ROBOT_MODULE_PARAMS "\"${MODEL}\"")

    configure_file(
      "${CMAKE_CURRENT_SOURCE_DIR}/loader.in.cpp"
      "${CMAKE_CURRENT_BINARY_DIR}/${PROJECT_NAME}/loader_${MODEL_LOWER}.cpp")
    add_executable(
      loader_${MODEL_LOWER}
      "${CMAKE_CURRENT_BINARY_DIR}/${PROJECT_NAME}/loader_${MODEL_LOWER}.cpp")
    target_link_libraries(loader_${MODEL_LOWER} PUBLIC mc_rtc::mc_rbdyn)
    add_test(NAME loader_${MODEL_LOWER}
             COMMAND loader_${MODEL_LOWER} "$<TARGET_FILE_DIR:${PROJECT_NAME}>")
  endforeach()
endif()
