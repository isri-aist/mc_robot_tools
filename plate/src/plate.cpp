#include "plate.h"
#include "config.h"

#include <RBDyn/parsers/urdf.h>

#include <filesystem>
namespace fs = std::filesystem;

namespace mc_robots
{

PlateRobotModule::PlateRobotModule(const std::string & name)
: mc_robot_tools::ConnectableRobotModule(MC_DATA_PATH, name)
{
  bool fixed = false;
  init(rbd::parsers::from_urdf_file(urdf_path, fixed));
  rsdf_dir = (fs::path(MC_RSDF_DIR) / name).string();
}

std::string PlateRobotModule::baseFrame() const
{
  return "plate_base_link";
}

std::vector<std::string> PlateRobotModule::collisionLinks() const
{
  return {"plate_link"};
}

sva::PTransformd PlateRobotModule::defaultMountingTransform() const
{
  return {sva::RotX(M_PI / 2)};
}

} // namespace mc_robots
