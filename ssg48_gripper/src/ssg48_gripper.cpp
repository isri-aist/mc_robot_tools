#include "ssg48_gripper.h"
#include "config.h"

#include <RBDyn/parsers/urdf.h>

#include <filesystem>
namespace fs = std::filesystem;

namespace mc_robots
{

SSG48GripperRobotModule::SSG48GripperRobotModule(const std::string & name)
: mc_robot_tools::ConnectableRobotModule(MC_DATA_PATH, name)
{
  bool fixed = false;
  init(rbd::parsers::from_urdf_file(urdf_path, fixed));
  rsdf_dir = (fs::path(MC_RSDF_DIR) / name).string();
}

std::string SSG48GripperRobotModule::baseFrame() const
{
  return "gripper_base_link";
}

std::vector<std::string> SSG48GripperRobotModule::collisionLinks() const
{
  return {"gripper_base_link", "left_gripper_finger", "right_gripper_finger"};
}

sva::PTransformd SSG48GripperRobotModule::defaultMountingTransform() const
{
  return sva::PTransformd::Identity();
}

} // namespace mc_robots
