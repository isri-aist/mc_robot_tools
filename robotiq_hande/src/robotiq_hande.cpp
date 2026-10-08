#include "robotiq_hande.h"
#include "config.h"

#include <RBDyn/parsers/urdf.h>

#include <filesystem>
namespace fs = std::filesystem;

namespace mc_robots
{

RobotiqHandERobotModule::RobotiqHandERobotModule(const std::string & name)
: mc_robot_tools::ConnectableRobotModule(MC_DATA_PATH, name)
{
  bool fixed = false;
  init(rbd::parsers::from_urdf_file(urdf_path, fixed));
  rsdf_dir = (fs::path(MC_RSDF_DIR) / name).string();
}

std::string RobotiqHandERobotModule::baseFrame() const
{
  return "robotiq_hande_origin";
}

std::vector<std::string> RobotiqHandERobotModule::collisionLinks() const
{
  return {"robotiq_hande_coupler", "robotiq_hande_left_finger", "robotiq_hande_link", "robotiq_hande_right_finger"};
}

sva::PTransformd RobotiqHandERobotModule::defaultMountingTransform() const
{
  return {sva::RotZ(M_PI)};
}

} // namespace mc_robots
