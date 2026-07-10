#include "plate.h"
#include "config.h"

#include <RBDyn/parsers/urdf.h>

#include <filesystem>
namespace fs = std::filesystem;

namespace mc_robots
{

PlateRobotModule::PlateRobotModule(const std::string & name) : mc_rbdyn::RobotModule(MC_DATA_PATH, name)
{
  bool fixed = false;
  init(rbd::parsers::from_urdf_file(urdf_path, fixed));
  rsdf_dir = (fs::path(MC_RSDF_DIR) / name).string();

  _baseFrame = "plate_base_link";
  _collisionLinks = {"plate_link"};
  _defaultMountingTransform = {sva::RotX(M_PI / 2)};
}

} // namespace mc_robots
