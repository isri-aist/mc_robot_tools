#include "screw.h"
#include "config.h"

#include <RBDyn/parsers/urdf.h>

namespace fs = std::filesystem;

namespace mc_robots
{

ScrewRobotModule::ScrewRobotModule(const std::string & name) : mc_rbdyn::RobotModule(MC_DATA_PATH, name)
{
  bool fixed = false;
  init(rbd::parsers::from_urdf_file(urdf_path, fixed));
  rsdf_dir = (fs::path(MC_RSDF_DIR) / name).string();
}

} // namespace mc_robots
