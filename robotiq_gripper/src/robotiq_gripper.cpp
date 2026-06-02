#include "robotiq_gripper.h"
#include "config.h"

#include <RBDyn/parsers/urdf.h>

#include <boost/filesystem.hpp>
namespace bfs = boost::filesystem;

namespace mc_robots
{

RobotiqGripperRobotModule::RobotiqGripperRobotModule(const std::string & name)
: mc_rbdyn::RobotModule(ROBOTIQ_DESCRIPTION_PATH, name)
{
  bool fixed = false;
  init(rbd::parsers::from_urdf_file(urdf_path, fixed));

  rsdf_dir = MC_ROBOTIQ_GRIPPER_RSDF_DIR;
}

} // namespace mc_robots
