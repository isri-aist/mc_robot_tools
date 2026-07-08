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
# Turn on necessary WITH_<module_name> options
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

### Add a new tool

If you want to add a new tool, use the existing modules as reference:
- Self-contained examples: Check out the [ds4](ds4/), [plate](plate/), or [realsense_camera](realsense_camera/) directories.
- ROS description examples: Check out the [bota_sensor](bota_sensor/) or [robotiq_gripper](robotiq_gripper/) directories.


#### Directory structure

Each tool follows this layout:
```sh
<new_tool>
├── CMakeLists.txt
├── meshes
│   └── <part_name>.stl
├── rsdf
│   └── <new_tool>.rsdf
├── src
│   ├── CMakeLists.txt
│   ├── config.in.h
│   ├── <new_tool>.cpp
│   └── <new_tool>.h
├── tests
│   ├── CMakeLists.txt
│   └── loader.in.cpp
└── urdf (or xacro)
    └── <new_tool>.in.urdf
```

#### Checklist

##### 1. Bootstrap the new tool

- [ ] Copy one of the reference modules above and rename to `<new_tool>`
- [ ] Update `ROBOT_NAME` in `<new_tool>/CMakeLists.txt`
- [ ] Add the corresponding `WITH_<NEW_TOOL>` option to the top-level `CMakeLists.txt`:
  ```cmake
  option(WITH_<NEW_TOOL> "Build <new_tool> module" OFF)

  # ...

  if(WITH_<NEW_TOOL>)
    add_subdirectory(<new_tool>)
  endif()
  ```
- [ ] Add the tool to the CMake-generated header include/mc_robot_tools/mc_robot_tools.in.h:
  ```cpp
  inline std::vector<std::string> list<NewTool>()
  {
    // clang-format off
    const bool WITH_<NEW_TOOL>_BOOL = @WITH_<NEW_TOOL>_BOOL@;
    // clang-format on
    if(WITH_<NEW_TOOL>_BOOL)
    {
      return {"<Model1>", "<Model2>", ...};
    }
    return {};
  }
  ```
- [ ] Add the corresponding conversion in the top-level CMakeLists' foreach:
  ```cmake
  foreach(opt ... <NEW_TOOL>)
  ```

##### 2. Implement the module

- [ ] Update <new_tool>/src/<new_tool>.h:
  - [ ] Update structure name to <NewTool>RobotModule
  - [ ] Declare the required override methods:
    ```cpp
    std::string baseFrame() const override;
    std::string wrenchFrame() const override; // optional — defaults to baseFrame
    std::vector<std::string> collisionLinks() const override; // optional — defaults to empty
    sva::PTransformd defaultMountingTransform() const override; // optional — defaults to identity
    ```
  - [ ] Update `MC_RTC_ROBOT_MODULE()` with the full list of robot names your module exposes
    - It is possible to conditionally register different subsets of modules by adjusting names dynamically at runtime. However, consider splitting them into multiple tool modules for simplicity if possible.
  - [ ] Update `create()` to return an instance of your new class for each supported name.

- [ ] Update <new_tool>/src/<new_tool>.cpp:
  - [ ] Constructor: call `ConnectableRobotModule(MC_DATA_PATH, name)` and initialize the URDF, and set `rsdf_dir`.
  - [ ] Implement the override methods declared in the header: `baseFrame()`, `wrenchFrame()`, `collisionLinks()`, `defaultMountingTransform()`.

##### 3. Add URDF / RSDF / meshes
- [ ] Add the URDF (or xacro template) to <new_tool>/urdf/ (or <new_tool>/xacro/)
- [ ] Add the RSDF file to <new_tool>/rsdf/<robot_name>.rsdf matching the URDF's link names

##### 4. Update tests
- [ ] Update `TEST_MODELS` in <new_tool>/tests/CMakeLists.txt with the exposed robot names
- [ ] Run ctest --verbose locally to verify the module loads without segfaults or unresolved frames

##### 5. Update CI
- [ ] Add `WITH_<NEW_TOOL>` option to step "Build and test" in `.github/workflows/build.yml`.
  - Add ROS dependency to step "Install ROS description packages" if necessary.

##### 6. Documentation
- [ ] Update this README with the new tool name, dependencies, any notable configuration options.

### Alternative: YAML-based modules

Robot modules can also be programmed with `yaml` (check this [repository](https://github.com/mc-rtc/new-robot-module) for more details).
However, this is not the preferred method since we cannot expose `baseFrame`, `wrenchFrame`, `collisionLinks`, or the available robot list to other programs using these tools.
