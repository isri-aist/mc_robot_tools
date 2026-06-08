#include "realsense_camera.h"
#include "config.h"

#include <RBDyn/parsers/urdf.h>

#include <boost/filesystem.hpp>
namespace bfs = boost::filesystem;

namespace mc_robots
{

RealSenseCameraRobotModule::RealSenseCameraRobotModule(const std::string & name)
: mc_rbdyn::RobotModule(MC_DATA_PATH, name)
{
  bool fixed = false;
  init(rbd::parsers::from_urdf_file(urdf_path, fixed));
  rsdf_dir = (bfs::path(MC_RSDF_DIR) / name).string();
}

} // namespace mc_robots
