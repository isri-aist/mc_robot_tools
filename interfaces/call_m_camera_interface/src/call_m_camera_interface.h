#pragma once

#include <mc_rbdyn/RobotModuleMacros.h>
#include <mc_rtc/logging.h>
#include <mc_rbdyn/RobotModule.h>
#include <mc_robots/api.h>

#include "config.h"

namespace mc_robots
{

struct MC_ROBOTS_DLLAPI CallMCameraInterfaceRobotModule : public mc_rbdyn::RobotModule
{
  CallMCameraInterfaceRobotModule();
};

} // namespace mc_robots

extern "C"
{
  ROBOT_MODULE_API void MC_RTC_ROBOT_MODULE(std::vector<std::string> & names)
  {
    names = {"CallMCameraInterface"};
  }
  ROBOT_MODULE_API void destroy(mc_rbdyn::RobotModule * ptr)
  {
    delete ptr;
  }
  ROBOT_MODULE_API mc_rbdyn::RobotModule * create(const std::string & n)
  {
    ROBOT_MODULE_CHECK_VERSION("CallMCameraInterace")
    if(n == "CallMCameraInterface")
    {
      return new mc_robots::CallMCameraInterfaceRobotModule();
    }
    else
    {
      mc_rtc::log::error("CallMCameraInterface module Cannot create an object of type {}", n);
      return nullptr;
    }
  }
}
