# mc_rtc Robot Tools

This repository contains `mc_rtc` robot modules for tools — end-effectors, sensors, and other peripherals — that can be attached to any robot supported by the `mc_rtc` framework.

Each tool lives in its own top-level folder and is built as an independent, opt-in CMake module. A tool is either self-contained (ships its own URDF/meshes) or depends on an official ROS description package for its geometry — see [Available Robot Tools](#available-robot-tools) below.

## Installation

Prerequisite: [mc_rtc](https://jrl-umi3218.github.io/mc_rtc) must already be installed.

```sh
git clone https://github.com/isri-aist/mc_robot_tools.git
cd mc_robot_tools
mkdir -p build && cd build
cmake ..
```

Turn on the tools you want to build, then build and install:

```sh
ccmake ..
# Turn on the WITH_<module_name> option(s) you need
# [c] Configure > [e] Exit > [g] Generate
make
sudo make install
```

## Available Robot Tools

|**Tool Module**|**Dependency**|
|---|---|
|**bota_sensor**|[bota_driver_ros2](https://gitlab.com/botasys/drivers/bota_driver_ros2)|
|**ds4**|None|
|**plate**|None|
|**realsense_camera**|None|
|**robotiq_gripper**|[ros2_robotiq_gripper/robotiq_description](https://github.com/PickNikRobotics/ros2_robotiq_gripper/tree/main/robotiq_description)|
|**screw**|None|

## Usage

On their own, these modules just describe a tool's geometry — they don't do anything. To use one, attach it to a robot module:

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

Note that none of these constraints are added to the solver automatically — you still need to define and add them yourself.

## Development

Every tool module falls into one of two categories (see the [table above](#available-robot-tools) for which is which):
- **Self-contained**: ships its own URDF/meshes, no external dependencies.
- **ROS-dependent**: derives its URDF from an external ROS description package.

### Add a new tool

If you want to add a new tool, use the existing modules as reference:
- Self-contained examples: Check out the [ds4](ds4/), [plate](plate/), or [realsense_camera](realsense_camera/) directories.
- ROS description examples: Check out the [bota_sensor](bota_sensor/) or [robotiq_gripper](robotiq_gripper/) directories.

#### How module generation works

Each tool's top-level `CMakeLists.txt` is a standard CMake project (`cmake_minimum_required()`, `project()`, `find_package(mc_rtc REQUIRED)`, ...) that then calls two macros from [cmake/mc_rtc_macros.cmake](cmake/mc_rtc_macros.cmake):

- `mc_rtc_generate_robot_description(MODELS <model1> [model2 ...])` generates and installs the URDF/RSDF/meshes. It auto-detects `xacro/`, `urdf/`, `rsdf/` and `meshes/` under the module's own directory, so most modules only need to pass `MODELS`. Pass `XACRO_PATH`/`URDF_DIR`/`RSDF_DIR`/`MESHES` explicitly to point a module at a folder outside its own directory (e.g. an upstream ROS description package — see [bota_sensor/CMakeLists.txt](bota_sensor/CMakeLists.txt)). It also defaults the build target name from the folder name (`generate-<new_tool>-urdf`) and exposes `MC_DATA_PATH`/`MC_RSDF_DIR`/etc. for `src/config.in.h`.
- `mc_rtc_generate_robot_module()` auto-discovers and adds the `src/`, `yaml/` and `tests/` subdirectories if they exist.

#### Directory structure

Each tool follows this layout:
```sh
<new_tool>
├── CMakeLists.txt
├── meshes
│   └── <part_name>.stl
├── rsdf
│   └── <new_tool>.rsdf
├── src                       # C++ module (or yaml/, see "Alternative: YAML-based modules")
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
- [ ] Update `<new_tool>/CMakeLists.txt`: set `ROBOT_NAME` and the `MODELS` passed to `mc_rtc_generate_robot_description()`, e.g.:
  ```cmake
  cmake_minimum_required(VERSION 3.22)

  set(ROBOT_NAME <new_tool>)

  project(
    mc_${ROBOT_NAME}
    LANGUAGES CXX
    VERSION 1.0.0)

  set(CXX_DISABLE_WERROR 1)
  set(CMAKE_CXX_STANDARD 17)
  set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

  include(CTest)

  find_package(mc_rtc REQUIRED)

  mc_rtc_generate_robot_description(MODELS ${ROBOT_NAME})

  mc_rtc_generate_robot_module()
  ```
  See [How module generation works](#how-module-generation-works) above for what gets auto-detected vs. needs to be passed explicitly (XACRO_PATH, multiple MODELS, ...).
- [ ] Add the corresponding `WITH_<NEW_TOOL>` option to the top-level `CMakeLists.txt`:
  ```cmake
  option(WITH_<NEW_TOOL> "Build <new_tool> module" OFF)

  # ...

  if(WITH_<NEW_TOOL>)
    add_subdirectory(<new_tool>)
  endif()
  ```
- [ ] Add the corresponding conversion in the top-level `CMakeLists.txt`:
  ```cmake
  foreach(opt ... <NEW_TOOL>)
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

##### 2. Implement the module

- [ ] Update `<new_tool>/src/<new_tool>.h`:
  - [ ] Update structure name to `<NewTool>RobotModule`
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

- [ ] Update `<new_tool>/src/<new_tool>.cpp`:
  - [ ] Initialize the URDF, and set `rsdf_dir`.
  - [ ] Set up `_baseFrame`, `_mountFrame`, `_collisionLinks`, `_defaultMountingTransform` if applicable.

##### 3. Add URDF / RSDF / meshes
- [ ] Add the URDF (or xacro template) to `<new_tool>/urdf/` (or `<new_tool>/xacro/`)
- [ ] Add the RSDF file to `<new_tool>/rsdf/<robot_name>.rsdf` matching the URDF's link names
  - Consider following this [tutorial](https://jrl-umi3218.github.io/mc_rtc/tutorials/advanced/new-environment.html#create-a-planar-surface) or using this [repository](https://github.com/isri-aist/rsdf_surface_exporter) export rsdf files.

##### 4. Update tests
- [ ] Update `TEST_MODELS` in `<new_tool>/tests/CMakeLists.txt` with the exposed robot names
- [ ] Run ctest --verbose locally to verify the module loads without segfaults or unresolved frames

##### 5. Update CI
- [ ] Add `WITH_<NEW_TOOL>` option to step "Build and test" in `.github/workflows/build.yml`.
  - Add ROS dependency to step "Install ROS description packages" if necessary.

##### 6. Documentation
- [ ] Update this README with the new tool name, dependencies, any notable configuration options.

### Alternative: YAML-based modules

Robot modules can also be programmed with `yaml` instead of C++ (check this [repository](https://github.com/mc-rtc/new-robot-module) for the expected layout: a `yaml/` folder with its own `CMakeLists.txt` that `configure_file()`s the robot description onto `${MC_SHARE_DIR}` and installs an alias entry to `${MC_ROBOTS_ALIASES_DIRECTORY}`).
`mc_rtc_generate_robot_module()` auto-discovers a `yaml/CMakeLists.txt` the same way it does `src/CMakeLists.txt`, so a tool can ship a `yaml/` folder instead of (or alongside) `src/`.
However, this is not the preferred method since we cannot expose `baseFrame`, `wrenchFrame`, `collisionLinks`, or the available robot list to other programs using these tools.
