set(TEST_MODELS
    "BFT_KG3_IND2_SW"
    "BFT_MEDS_ECAT_M8"
    "BFT_MEGS_SER_M8"
    "BFT_MN2S_SER_UB"
    "BFT_ROKS_SER_M8"
    "BFT_LAXS_ECAT_M8"
    "BFT_MEDS_SER_M8"
    "BFT_MIPS_ECAT_CG"
    "BFT_ROKS_CAT2_B4"
    "BFT_SENS_ECAT_M8"
    "BFT_LAXS_SER_M8"
    "BFT_MEGS_ECAT_M8"
    "BFT_MIPS_SER_CG"
    "BFT_ROKS_ECAT_M8"
    "BFT_SENS_SER_M8")

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
