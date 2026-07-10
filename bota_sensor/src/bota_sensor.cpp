#include "bota_sensor.h"
#include "config.h"

#include <RBDyn/parsers/urdf.h>

#include <filesystem>
namespace fs = std::filesystem;

namespace mc_robots
{

BotaSensorRobotModule::BotaSensorRobotModule(const std::string & name) : mc_rbdyn::RobotModule(MC_DATA_PATH, name)
{
  bool fixed = false;
  init(rbd::parsers::from_urdf_file(urdf_path, fixed));
  rsdf_dir = (fs::path(MC_RSDF_DIR) / name).string();

  _baseFrame = name + "_mounting";
  _mountFrame = name + "_wrench";
  _collisionLinks = {name + "_mounting_0", name + "_mounting_1", name + "_mounting_2"};
  _defaultMountingTransform = {sva::RotZ(M_PI)};

  _forceSensors.emplace_back() =
      mc_rbdyn::ForceSensor("BotaForceSensor", name + "_wrench", sva::PTransformd::Identity());
  _bodySensors.emplace_back() = mc_rbdyn::BodySensor("BotaAccelerometer", name + "_imu", sva::PTransformd::Identity());
}

} // namespace mc_robots
