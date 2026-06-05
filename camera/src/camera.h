#pragma once

#include <mc_rbdyn/RobotModule.h>
#include <mc_rbdyn/RobotModuleMacros.h>
#include <mc_robots/api.h>
#include <mc_rtc/logging.h>

namespace mc_robots
{

struct MC_ROBOTS_DLLAPI CameraRobotModule : public mc_rbdyn::RobotModule
{
  CameraRobotModule(const std::string & name);
};

} // namespace mc_robots

extern "C"
{
  ROBOT_MODULE_API void MC_RTC_ROBOT_MODULE(std::vector<std::string> & names) // NOLINT(readability-identifier-naming)
  {
    names = {"Camera"};
  }

  ROBOT_MODULE_API void destroy(mc_rbdyn::RobotModule * ptr)
  {
    delete ptr; // NOLINT(cppcoreguidelines-owning-memory)
  }

  ROBOT_MODULE_API mc_rbdyn::RobotModule * create(const std::string & n)
  {
    ROBOT_MODULE_CHECK_VERSION("Camera")

    if(n == "Camera")
    {
      return new mc_robots::CameraRobotModule("camera");
    }

    mc_rtc::log::error("Camera module cannot create an object of type {}", n);
    return nullptr;
  }
}
