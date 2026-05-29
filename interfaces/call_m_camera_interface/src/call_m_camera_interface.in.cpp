#include "call_m_camera_interface.h"

#include <RBDyn/parsers/urdf.h>

#include <filesystem>
namespace fs = std::filesystem;

namespace
{

// This is set by CMake, see CMakeLists.txt
static const std::string MC_CALL_M_CAMERA_INTERFACE_DESCRIPTION_PATH = "@DATA_DIR@";

} // namespace

namespace mc_robots
{

CallMCameraInterfaceRobotModule::CallMCameraInterfaceRobotModule()
: mc_rbdyn::RobotModule(MC_CALL_M_CAMERA_INTERFACE_DESCRIPTION_PATH, "call_m_camera_interface")
{
  // True if the robot has a fixed base, false otherwise
  bool fixed = true;
  // Makes all the basic initialization that can be done from an URDF file
  init(rbd::parsers::from_urdf_file(urdf_path, fixed));
}

} // namespace mc_robots
