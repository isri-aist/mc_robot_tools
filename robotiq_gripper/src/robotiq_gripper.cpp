#include "robotiq_gripper.h"
#include "config.h"

#include <RBDyn/parsers/urdf.h>

#include <filesystem>
namespace fs = std::filesystem;

namespace mc_robots
{

RobotiqGripperRobotModule::RobotiqGripperRobotModule(const std::string & name)
: mc_rbdyn::RobotModule(MC_DATA_PATH, name),
  prefix_(name.find("85") != std::string::npos ? "robotiq_85" : "robotiq_140")
{
  bool fixed = false;
  init(rbd::parsers::from_urdf_file(urdf_path, fixed));
  rsdf_dir = (fs::path(MC_RSDF_DIR) / name).string();

  _baseFrame = prefix_ + "_base_link";
  _collisionLinks = {prefix_ + "_base_link",
                     prefix_ + "_left_knuckle_link",
                     prefix_ + "_right_knuckle_link",
                     prefix_ + "_left_finger_link",
                     prefix_ + "_right_finger_link",
                     prefix_ + "_left_finger_tip_link",
                     prefix_ + "_right_finger_tip_link"};
  _defaultMountingTransform = {sva::RotZ(M_PI)};
}

} // namespace mc_robots
