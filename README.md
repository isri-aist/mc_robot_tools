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
make && sudo make install
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

## Development

Tool modules generally fall into one of two implementation categories:
- Self-contained: Modules that have no external dependencies.
- ROS-dependent: Modules that rely on external ROS description packages for geometry and kinematics.

If you want to add a new tool, use the existing modules as blueprints:
- Self-contained examples: Check out the [ds4](ds4/), [plate](plate/), or [realsense_camera](realsense_camera/) directories.
- ROS description examples: Check out the [bota_sensor](bota_sensor/) or [robotiq_gripper](robotiq_gripper/) directories.
