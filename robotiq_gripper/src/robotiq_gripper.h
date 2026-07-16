#pragma once

#include <mc_rbdyn/RobotModuleMacros.h>
#include <mc_robots/api.h>
#include <mc_rtc/logging.h>

namespace mc_robots
{

struct MC_ROBOTS_DLLAPI RobotiqGripperRobotModule : public mc_rbdyn::RobotModule
{
  RobotiqGripperRobotModule(const std::string & name);

private:
  std::string prefix_;
};

} // namespace mc_robots

extern "C"
{
  ROBOT_MODULE_API void MC_RTC_ROBOT_MODULE(std::vector<std::string> & names) // NOLINT(readability-identifier-naming)
  {
    names = {"Robotiq2f85Gripper", "Robotiq2f140Gripper"};
  }

  ROBOT_MODULE_API void destroy(mc_rbdyn::RobotModule * ptr)
  {
    delete ptr;
  }

  ROBOT_MODULE_API mc_rbdyn::RobotModule * create(const std::string & n)
  {
    ROBOT_MODULE_CHECK_VERSION("RobotiqGripper")

    if(n == "Robotiq2f85Gripper")
    {
      return new mc_robots::RobotiqGripperRobotModule("robotiq_2f_85_gripper");
    }
    if(n == "Robotiq2f140Gripper")
    {
      return new mc_robots::RobotiqGripperRobotModule("robotiq_2f_140_gripper");
    }

    mc_rtc::log::error("RobotiqGripper module cannot create an object of type {}", n);
    return nullptr;
  }
}
