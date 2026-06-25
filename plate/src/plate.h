#pragma once

#include <mc_robot_tools/ConnectableRobotModule.h>

#include <mc_rbdyn/RobotModuleMacros.h>
#include <mc_robots/api.h>
#include <mc_rtc/logging.h>

namespace mc_robots
{

struct MC_ROBOTS_DLLAPI PlateRobotModule : public mc_robot_tools::ConnectableRobotModule
{
  PlateRobotModule(const std::string & name);

  std::string baseFrame() const override;
  std::vector<std::string> collisionLinks() const override;
  sva::PTransformd defaultMountingTransform() const override;
};

} // namespace mc_robots

extern "C"
{
  ROBOT_MODULE_API void MC_RTC_ROBOT_MODULE(std::vector<std::string> & names) // NOLINT(readability-identifier-naming)
  {
    names = {"Plate"};
  }

  ROBOT_MODULE_API void destroy(mc_rbdyn::RobotModule * ptr)
  {
    mc_robot_tools::destroyConnectableRobotModule(ptr);
  }

  ROBOT_MODULE_API mc_rbdyn::RobotModule * create(const std::string & n)
  {
    ROBOT_MODULE_CHECK_VERSION("Plate")

    if(n == "Plate")
    {
      return new mc_robots::PlateRobotModule("plate");
    }

    mc_rtc::log::error("Plate module cannot create an object of type {}", n);
    return nullptr;
  }
}
