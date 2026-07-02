#pragma once

#include <string>
#include <unordered_map>
#include <vector>

namespace mc_robot_tools
{

/** Bota sensor module names (empty if not installed). */
inline std::vector<std::string> listBotaSensor()
{
  // clang-format off
  const bool WITH_BOTA_SENSOR_BOOL = @WITH_BOTA_SENSOR_BOOL@;
  // clang-format on
  if(WITH_BOTA_SENSOR_BOOL)
  {
    return {"BFT_KG3_IND2_SW",  "BFT_MEDS_ECAT_M8", "BFT_MEGS_SER_M8",  "BFT_MN2S_SER_UB",  "BFT_ROKS_SER_M8",
            "BFT_LAXS_ECAT_M8", "BFT_MEDS_SER_M8",  "BFT_MIPS_ECAT_CG", "BFT_ROKS_CAT2_B4", "BFT_SENS_ECAT_M8",
            "BFT_LAXS_SER_M8",  "BFT_MEGS_ECAT_M8", "BFT_MIPS_SER_CG",  "BFT_ROKS_ECAT_M8", "BFT_SENS_SER_M8"};
  }
  return {};
}

inline std::vector<std::string> listDS4()
{
  // clang-format off
  const bool WITH_DS4_BOOL = @WITH_DS4_BOOL@;
  // clang-format on
  if(WITH_DS4_BOOL) return {"DS4"};
  return {};
}

inline std::vector<std::string> listPlate()
{
  // clang-format off
  const bool WITH_PLATE_BOOL = @WITH_PLATE_BOOL@;
  // clang-format on
  if(WITH_PLATE_BOOL) return {"Plate"};
  return {};
}

inline std::vector<std::string> listRealSense()
{
  // clang-format off
  const bool WITH_REALSENSE_CAMERA_BOOL = @WITH_REALSENSE_CAMERA_BOOL@;
  // clang-format on
  if(WITH_REALSENSE_CAMERA_BOOL) return {"RealSenseD435"};
  return {};
}

inline std::vector<std::string> listRobotiqGripper()
{
  // clang-format off
  const bool WITH_ROBOTIQ_GRIPPER_BOOL = @WITH_ROBOTIQ_GRIPPER_BOOL@;
  // clang-format on
  if(WITH_ROBOTIQ_GRIPPER_BOOL) return {"Robotiq2f85Gripper", "Robotiq2f140Gripper"};
  return {};
}

inline std::vector<std::string> listScrew()
{
  // clang-format off
  const bool WITH_SCREW_BOOL = @WITH_SCREW_BOOL@;
  // clang-format on
  if(WITH_SCREW_BOOL) return {"Screw"};
  return {};
}

} // namespace mc_robot_tools
