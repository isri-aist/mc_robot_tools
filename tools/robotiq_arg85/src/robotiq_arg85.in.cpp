#include "robotiq_arg85.h"

#include <RBDyn/parsers/urdf.h>

#include <filesystem>
namespace fs = std::filesystem;

namespace
{

// This is set by CMake, see CMakeLists.txt
static const std::string ROBOTIQ_ARG85_DESCRIPTION_PATH = "@DATA_DIR@";

} // namespace

namespace mc_robots
{

RobotiqArg85RobotModule::RobotiqArg85RobotModule()
: mc_rbdyn::RobotModule(ROBOTIQ_ARG85_DESCRIPTION_PATH, "robotiq_arg85")
{
  // True if the robot has a fixed base, false otherwise
  bool fixed = true;
  // Makes all the basic initialization that can be done from an URDF file
  init(rbd::parsers::from_urdf_file(urdf_path, fixed));
}

} // namespace mc_robots
