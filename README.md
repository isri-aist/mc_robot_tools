# All Robot Tools for mc_rtc

This repository contains `mc_rtc` modules for various robot tools, enabling seamless integration of end-effectors, sensors, and peripherals with all robots supported by the `mc_rtc` framework.

Each tool type is organized within its own dedicated folder. Depending on the tool, the implementation is either entirely self-contained or dependent on an official ROS package.

## Installation

Build and install the modules by running the following commands in your terminal:

```sh
git clone https://github.com/isri-aist/mc_robot_tools.git
cd mc_robot_tools
mkdir -p build && cd build
cmake ..
```
Turn on appropriate options for your tool module.

```sh
ccmake ..
# Turn on neccessary WITH_<module_name> options
# [c] Configure > [e] Exit > [g] Generate
make
sudo make install
```

## Available Robots Tools

|**Tool Module**|**Dependency**|
|---|---|
|**bota_sensor**|[bota_driver_ros2](https://gitlab.com/botasys/drivers/bota_driver_ros2)|
|**ds4**|None|
|**plate**|None|
|**realsense_camera**|None|
|**robotiq_gripper**|[ros2_robotiq_gripper/robotiq_description](https://github.com/PickNikRobotics/ros2_robotiq_gripper/tree/main/robotiq_description)|
|**screw**|None|

## Usage

By themselves, there won't be much you can do with these sensors. To attach them to another robots, consider the following method:

```cpp
auto robot = mc_rbdyn::RobotLoader::get_robot_module("<robot_name>");
auto tool = mc_rbdyn::RobotLoader::get_robot_module("<tool_name>");
auto robot_tool = robot.connect(*tool, "<robot_frame>", "<tool_frame>", "",
                                mc_rbdyn::RobotModule::ConnectionParameters{}.X_other_connection(sva::RotZ(0.0)));

// Add links for self collisions
const double COL_I = 0.03;
const double COL_S = 0.015;
const double COL_D = 0.0;
auto addToolCollisions = [COL_I, COL_S, COL_D](mc_rbdyn::RobotModule &module,
                                                const std::vector<std::string> &robot_collision_links,
                                                const std::vector<std::string> &tool_collision_links) {
  for (const auto &robot_link : robot_collision_links)
  {
    for (const auto &tool_link : tool_collision_links)
    {
      module._minimalSelfCollisions.push_back({robot_link, tool_link, COL_I, COL_S, COL_D});
    }
  }
  module._commonSelfCollisions = module._minimalSelfCollisions;
};

addToolCollisions(robot_tool, {"<robot_link_1>", "<robot_link_2>", "<robot_link_3>"},
                  {"<tool_link_1>", "<tool_link_2>", "<tool_link_3>"});
```

Noted that none of the constraints are attached to the new loaded robot, you need to manually define and add them to the solver.

## Development

Tool modules generally fall into one of two implementation categories:
- Self-contained: Modules that have no external dependencies.
- ROS-dependent: Modules that rely on external ROS description packages for geometry and kinematics.

If you want to add a new tool, use the existing modules as reference:
- Self-contained examples: Check out the [ds4](ds4/), [plate](plate/), or [realsense_camera](realsense_camera/) directories.
- ROS description examples: Check out the [bota_sensor](bota_sensor/) or [robotiq_gripper](robotiq_gripper/) directories.

Robot modules can also be programmed with yaml. Check this [repository](https://github.com/mc-rtc/new-robot-module) for more details.
