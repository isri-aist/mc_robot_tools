#pragma once

#include <mc_robot_tools/ConnectableRobotModule.h>

#include <mc_rbdyn/RobotModuleMacros.h>
#include <mc_robots/api.h>
#include <mc_rtc/logging.h>

namespace mc_robots
{

struct MC_ROBOTS_DLLAPI DS4RobotModule : public mc_robot_tools::ConnectableRobotModule
{
  DS4RobotModule(const std::string & name);

  std::string baseFrame() const override;
  std::vector<std::string> collisionLinks() const override;
  sva::PTransformd defaultMountingTransform() const override;
};

} // namespace mc_robots

extern "C"
{
  ROBOT_MODULE_API void MC_RTC_ROBOT_MODULE(std::vector<std::string> & names) // NOLINT(readability-identifier-naming)
  {
    names = {"DS4"};
  }

  ROBOT_MODULE_API void destroy(mc_rbdyn::RobotModule * ptr)
  {
    mc_robot_tools::destroyConnectableRobotModule(ptr);
  }

  ROBOT_MODULE_API mc_rbdyn::RobotModule * create(const std::string & n)
  {
    ROBOT_MODULE_CHECK_VERSION("DS4")

    if(n == "DS4")
    {
      return new mc_robots::DS4RobotModule("ds4");
    }

    mc_rtc::log::error("DS4 module cannot create an object of type {}", n);
    return nullptr;
  }
}
