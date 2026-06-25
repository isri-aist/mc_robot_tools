#include "realsense_camera.h"
#include "config.h"

#include <RBDyn/parsers/urdf.h>

#include <filesystem>
namespace fs = std::filesystem;

namespace mc_robots
{

RealSenseCameraRobotModule::RealSenseCameraRobotModule(const std::string & name)
: mc_robot_tools::ConnectableRobotModule(MC_DATA_PATH, name)
{
  bool fixed = false;
  init(rbd::parsers::from_urdf_file(urdf_path, fixed));
  rsdf_dir = (fs::path(MC_RSDF_DIR) / name).string();
}

std::string RealSenseCameraRobotModule::baseFrame() const
{
  return "realsense_d435_base_link";
}

std::string RealSenseCameraRobotModule::wrenchFrame() const
{
  return "realsense_d435_wrench_link";
}

std::vector<std::string> RealSenseCameraRobotModule::collisionLinks() const
{
  return {"realsense_d435_bracket_link", "realsense_d435_camera_link"};
}

sva::PTransformd RealSenseCameraRobotModule::defaultMountingTransform() const
{
  return sva::PTransformd::Identity(); // no rotation needed for camera
}

} // namespace mc_robots
