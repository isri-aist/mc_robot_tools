#include "call_m_camera_interface.h"

#include <RBDyn/parsers/urdf.h>

#include <boost/filesystem.hpp>
namespace bfs = boost::filesystem;

namespace
{

// This is set by CMake, see CMakeLists.txt
static const std::string MC_CALL_M_CAMERA_INTERFACE_DESCRIPTION_PATH = "@DATA_DIR@";

} // namespace

namespace mc_robots
{

CallMCameraInterfaceRobotModule::CallMCameraInterfaceRobotModule() : mc_rbdyn::RobotModule(MC_CALL_M_CAMERA_INTERFACE_DESCRIPTION_PATH, "call_m_camera_interface")
{
  // True if the robot has a fixed base, false otherwise
  bool fixed = true;
  // Makes all the basic initialization that can be done from an URDF file
  init(rbd::parsers::from_urdf_file(urdf_path, fixed));

  // Automatically load the convex hulls associated to each body
  std::string convexPath = description_paths::convex_DIR;
  bfs::path p(convexPath);
  if(bfs::exists(p) && bfs::is_directory(p))
  {
    std::vector<bfs::path> files;
    std::copy(bfs::directory_iterator(p), bfs::directory_iterator(), std::back_inserter(files));

    _convexHull["camera_interface_link"] = std::pair<std::string, std::string>("camera_interface_link", files[0].string());

  }
}

} // namespace mc_robots
