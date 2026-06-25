#include "screw.h"
#include "config.h"

#include <RBDyn/parsers/urdf.h>

#include <filesystem>
namespace fs = std::filesystem;

namespace mc_robots
{

ScrewRobotModule::ScrewRobotModule(const std::string & name)
: mc_robot_tools::ConnectableRobotModule(MC_DATA_PATH, name)
{
  bool fixed = false;
  init(rbd::parsers::from_urdf_file(urdf_path, fixed));
  rsdf_dir = (fs::path(MC_RSDF_DIR) / name).string();
}

std::string ScrewRobotModule::baseFrame() const
{
  return "screw_base_link";
}

std::vector<std::string> ScrewRobotModule::collisionLinks() const
{
  return {"screw_link"};
}

sva::PTransformd ScrewRobotModule::defaultMountingTransform() const
{
  return sva::PTransformd::Identity();
}

} // namespace mc_robots
