#pragma once
#include <mc_panda/panda.h>
#include <mc_rbdyn/RobotModuleMacros.h>
#include "config_panda_brace.h"

namespace mc_robots
{

/**
 * Robot module for the Panda femur with the top brace (brace_top_setup)
 * attached
 **/
template<bool DebugLog = false>
struct ROBOT_MODULE_API PandaBraceCommonRobotModule : public mc_robots::PandaRobotModule
{
public:
  PandaBraceCommonRobotModule(const std::string & robot_description_path_, const std::string & brace_urdf_name);

protected:
  std::string robot_description_path_;
  std::string brace_urdf_name_;

protected:
  template<typename... Args>
  inline void log_info(Args &&... args)
  {
    if constexpr(DebugLog)
    {
      mc_rtc::log::info(std::forward<Args>(args)...);
    }
  }

  template<typename... Args>
  inline void log_success(Args &&... args)
  {
    if constexpr(DebugLog)
    {
      mc_rtc::log::success(std::forward<Args>(args)...);
    }
  }
};

template<bool DebugLog = false>
struct ROBOT_MODULE_API PandaFemurRobotModule : public mc_robots::PandaBraceCommonRobotModule<DebugLog>
{
  PandaFemurRobotModule();
};

template<bool DebugLog = false>
struct ROBOT_MODULE_API PandaFemurWithBraceRobotModule : public mc_robots::PandaBraceCommonRobotModule<DebugLog>
{
  PandaFemurWithBraceRobotModule();
};

} // namespace mc_robots
