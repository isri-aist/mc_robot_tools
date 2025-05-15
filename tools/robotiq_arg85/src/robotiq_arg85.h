#pragma once

#include <mc_rbdyn/RobotModuleMacros.h>
#include <mc_rtc/logging.h>
#include <mc_rbdyn/RobotModule.h>
#include <mc_robots/api.h>

#include "config.h"

namespace mc_robots
{

struct MC_ROBOTS_DLLAPI RobotiqArg85RobotModule : public mc_rbdyn::RobotModule
{
  RobotiqArg85RobotModule();
};

} // namespace mc_robots

extern "C"
{
  ROBOT_MODULE_API void MC_RTC_ROBOT_MODULE(std::vector<std::string> & names)
  {
    names = {"robotiq_arg85"};
  }
  ROBOT_MODULE_API void destroy(mc_rbdyn::RobotModule * ptr)
  {
    delete ptr;
  }
  ROBOT_MODULE_API mc_rbdyn::RobotModule * create(const std::string & n)
  {
    ROBOT_MODULE_CHECK_VERSION("robotiq_arg85")
    if(n == "robotiq_arg85")
    {
      return new mc_robots::RobotiqArg85RobotModule();
    }
    else
    {
      mc_rtc::log::error("robotiq_arg85 module Cannot create an object of type {}", n);
      return nullptr;
    }
  }
}
