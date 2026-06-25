#pragma once

#include <mc_rbdyn/RobotModule.h>
#include <SpaceVecAlg/SpaceVecAlg>

namespace mc_robot_tools
{

/** Standard interface for robot modules that can be attached as tools.
 *
 *  Defines a uniform way to expose connection frames and metadata
 *  so robots like Kinova can attach any compatible tool without
 *  hardcoding frame names.
 */
struct ConnectableRobotModule : public mc_rbdyn::RobotModule
{
  using mc_rbdyn::RobotModule::RobotModule;

  ConnectableRobotModule(const ConnectableRobotModule &) = default;
  ConnectableRobotModule(ConnectableRobotModule &&) noexcept = default;
  ConnectableRobotModule & operator=(const ConnectableRobotModule &) = default;
  ConnectableRobotModule & operator=(ConnectableRobotModule &&) noexcept = default;
  virtual ~ConnectableRobotModule() = default;

  /** Frame on this module to be connected to the parent robot */
  virtual std::string baseFrame() const = 0;

  /** Frame on this module to be used for further attachments (downstream tools) */
  virtual std::string wrenchFrame() const
  {
    return baseFrame();
  }

  /** List of links that should be added to collision pairs with the parent */
  virtual std::vector<std::string> collisionLinks() const
  {
    return {};
  }

  /** Default mounting transform when attached to a parent robot */
  virtual sva::PTransformd defaultMountingTransform() const
  {
    return sva::PTransformd::Identity();
  }
};

/** Helper for robot module .so destroy() functions.
 *  Ensures the correct address is freed when the static type is RobotModule*. */
inline void destroyConnectableRobotModule(mc_rbdyn::RobotModule * ptr)
{
  // NOLINTNEXTLINE(cppcoreguidelines-pro-type-static-cast-downcast,cppcoreguidelines-owning-memory)
  delete static_cast<ConnectableRobotModule *>(ptr);
}

} // namespace mc_robot_tools
