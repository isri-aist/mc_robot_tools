#include "realsense_camera.h"
#include "config.h"

#include <RBDyn/parsers/urdf.h>

#include <filesystem>
namespace fs = std::filesystem;

namespace mc_robots
{

RealSenseCameraRobotModule::RealSenseCameraRobotModule(const std::string & name)
: mc_rbdyn::RobotModule(MC_DATA_PATH, name)
{
  bool fixed = false;
  init(rbd::parsers::from_urdf_file(urdf_path, fixed));
  rsdf_dir = (fs::path(MC_RSDF_DIR) / name).string();

  _baseFrame = "realsense_d435_base_link";
  _mountFrame = "realsense_d435_wrench_link";
  _collisionLinks = {"realsense_d435_bracket_link", "realsense_d435_camera_link"};
  _defaultMountingTransform = sva::PTransformd::Identity();
}

} // namespace mc_robots
