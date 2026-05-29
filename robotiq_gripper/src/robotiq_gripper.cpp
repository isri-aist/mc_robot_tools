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
  init(rbd::parsers::from_urdf_file(urdf_path, false));
}

} // namespace mc_robots
