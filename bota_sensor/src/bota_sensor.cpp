#include "bota_sensor.h"
#include "config.h"

#include <RBDyn/parsers/urdf.h>

#include <boost/filesystem.hpp>
namespace bfs = boost::filesystem;

namespace mc_robots
{

BotaSensorRobotModule::BotaSensorRobotModule(const std::string & name) : mc_rbdyn::RobotModule(BOTA_DRIVER_PATH, name)
{
  bool fixed = false;
  init(rbd::parsers::from_urdf_file(urdf_path, fixed));

  rsdf_dir = (bfs::path(MC_BOTA_SENSOR_RSDF_DIR) / name).string();
}

} // namespace mc_robots
