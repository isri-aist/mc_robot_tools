#include "bota_sensor.h"
#include "config.h"

#include <RBDyn/parsers/urdf.h>

namespace fs = std::filesystem;

namespace mc_robots
{

BotaSensorRobotModule::BotaSensorRobotModule(const std::string & name) : mc_rbdyn::RobotModule(MC_DATA_PATH, name)
{
  bool fixed = false;
  init(rbd::parsers::from_urdf_file(urdf_path, fixed));
  rsdf_dir = (fs::path(MC_RSDF_DIR) / name).string();

  _forceSensors.emplace_back() =
      mc_rbdyn::ForceSensor("BotaForceSensor", name + "_wrench", sva::PTransformd::Identity());
  _bodySensors.emplace_back() = mc_rbdyn::BodySensor("BotaAccelerometer", name + "_imu", sva::PTransformd::Identity());
}

} // namespace mc_robots
