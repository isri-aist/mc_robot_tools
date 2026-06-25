#pragma once

#include <mc_rbdyn/RobotModuleMacros.h>
#include <mc_robots/api.h>
#include <mc_rtc/logging.h>
#include <mc_robot_tools/ConnectableRobotModule.h>

#include <algorithm>

static const std::vector<std::string> BOTA_MODELS = {
    "BFT_KG3_IND2_SW",  "BFT_MEDS_ECAT_M8", "BFT_MEGS_SER_M8",  "BFT_MN2S_SER_UB",  "BFT_ROKS_SER_M8",
    "BFT_LAXS_ECAT_M8", "BFT_MEDS_SER_M8",  "BFT_MIPS_ECAT_CG", "BFT_ROKS_CAT2_B4", "BFT_SENS_ECAT_M8",
    "BFT_LAXS_SER_M8",  "BFT_MEGS_ECAT_M8", "BFT_MIPS_SER_CG",  "BFT_ROKS_ECAT_M8", "BFT_SENS_SER_M8"};

static std::string toLower(std::string s)
{
  std::transform(s.begin(), s.end(), s.begin(), ::tolower);
  return s;
}

namespace mc_robots
{

struct MC_ROBOTS_DLLAPI BotaSensorRobotModule : public mc_robot_tools::ConnectableRobotModule
{
  BotaSensorRobotModule(const std::string & name);

  std::string baseFrame() const override;
  std::string wrenchFrame() const override;
  std::vector<std::string> collisionLinks() const override;
  sva::PTransformd defaultMountingTransform() const override;
};

} // namespace mc_robots

extern "C"
{
  ROBOT_MODULE_API void MC_RTC_ROBOT_MODULE(std::vector<std::string> & names) // NOLINT(readability-identifier-naming)
  {
    names = BOTA_MODELS;
  }

  ROBOT_MODULE_API void destroy(mc_rbdyn::RobotModule * ptr)
  {
    mc_robot_tools::destroyConnectableRobotModule(ptr);
  }

  ROBOT_MODULE_API mc_rbdyn::RobotModule * create(const std::string & n)
  {
    ROBOT_MODULE_CHECK_VERSION("BotaSensor")

    for(const auto & model : BOTA_MODELS)
    {
      if(n == model)
      {
        return new mc_robots::BotaSensorRobotModule(toLower(model));
      }
    }

    mc_rtc::log::error("BotaSensor module cannot create an object of type {}", n);
    return nullptr;
  }
}
