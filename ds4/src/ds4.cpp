#include "ds4.h"
#include "config.h"

#include <RBDyn/parsers/urdf.h>

#include <filesystem>
namespace fs = std::filesystem;

namespace mc_robots
{

DS4RobotModule::DS4RobotModule(const std::string & name) : mc_robot_tools::ConnectableRobotModule(MC_DATA_PATH, name)
{
  bool fixed = false;
  init(rbd::parsers::from_urdf_file(urdf_path, fixed));
  rsdf_dir = (fs::path(MC_RSDF_DIR) / name).string();
}

std::string DS4RobotModule::baseFrame() const
{
  return "ds4_base_link";
}

std::vector<std::string> DS4RobotModule::collisionLinks() const
{
  return {"ds4_adapter_link", "ds4_actual_controller_link"};
}

sva::PTransformd DS4RobotModule::defaultMountingTransform() const
{
  return {sva::RotZ(M_PI)};
}

} // namespace mc_robots
