#pragma once

#include <mc_rbdyn/RobotModuleMacros.h>
#include <mc_robots/api.h>

namespace mc_robots
{

struct ConnectRobot
{
  std::string module;
  std::string name;
  std::string connection_link;
};

struct ConnectTool
{
  std::string module;
  std::string name;
  std::string connection_link;
  double rotate = 0;
};

template<typename Callback>
static void ForAllVariants(Callback cb)
{
  for(auto & robot :
      std::vector<ConnectRobot>{{"PandaDefault", "panda", "panda_link8"}, {"UR10", "panda", "wrist_3_link"}})
  {
    for(auto & tool : std::vector<ConnectTool>{{"BoneTag::Femur", "femur", "femur_base_link", mc_rtc::constants::PI},
                                               {"BoneTag::Tibia", "tibia", "tibia_base_link"}})
    {
      cb("PandaProsthesis", robot, tool);
    }
  }
}

} // namespace mc_robots
