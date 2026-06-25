#include "bota_sensor.h"
#include "config.h"

#include <RBDyn/parsers/urdf.h>

#include <filesystem>
namespace fs = std::filesystem;

namespace mc_robots
{

BotaSensorRobotModule::BotaSensorRobotModule(const std::string & name)
: mc_robot_tools::ConnectableRobotModule(MC_DATA_PATH, name)
{
  bool fixed = false;
  init(rbd::parsers::from_urdf_file(urdf_path, fixed));
  rsdf_dir = (fs::path(MC_RSDF_DIR) / name).string();

  _forceSensors.emplace_back() =
      mc_rbdyn::ForceSensor("BotaForceSensor", name + "_wrench", sva::PTransformd::Identity());
  _bodySensors.emplace_back() = mc_rbdyn::BodySensor("BotaAccelerometer", name + "_imu", sva::PTransformd::Identity());
}

std::string BotaSensorRobotModule::baseFrame() const
{
  return name + "_mounting";
}

std::string BotaSensorRobotModule::wrenchFrame() const
{
  return name + "_wrench";
}

std::vector<std::string> BotaSensorRobotModule::collisionLinks() const
{
  return {name + "_mounting_0", name + "_mounting_1", name + "_mounting_2"};
}

sva::PTransformd BotaSensorRobotModule::defaultMountingTransform() const
{
  return {sva::RotZ(M_PI)};
}

} // namespace mc_robots
