set(ROBOTIQ_TEST_MODELS "Robotiq2f85Gripper" "Robotiq2f140Gripper")

if(TARGET robotiq_gripper)
  foreach(MODEL ${ROBOTIQ_TEST_MODELS})
    string(TOLOWER ${MODEL} MODEL_LOWER)
    set(ROBOT_MODULE_PARAMS "\"${MODEL}\"")

    configure_file(
      "${CMAKE_CURRENT_SOURCE_DIR}/loader.in.cpp"
      "${CMAKE_CURRENT_BINARY_DIR}/mc_robotiq_gripper/loader_${MODEL_LOWER}.cpp"
    )
    add_executable(
      loader_${MODEL_LOWER}
      "${CMAKE_CURRENT_BINARY_DIR}/mc_robotiq_gripper/loader_${MODEL_LOWER}.cpp"
    )
    target_link_libraries(loader_${MODEL_LOWER} PUBLIC mc_rtc::mc_rbdyn)
    add_test(NAME loader_${MODEL_LOWER}
             COMMAND loader_${MODEL_LOWER} "$<TARGET_FILE_DIR:robotiq_gripper>")
  endforeach()
endif()
