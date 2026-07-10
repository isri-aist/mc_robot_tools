#pragma once

#include <mc_rbdyn/RobotModuleMacros.h>
#include <mc_robots/api.h>
#include <mc_rtc/logging.h>

namespace mc_robots
{

struct MC_ROBOTS_DLLAPI DS4RobotModule : public mc_rbdyn::RobotModule
{
  DS4RobotModule(const std::string & name);
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
    delete ptr;
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
