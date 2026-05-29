# MC_ROBOT_TOOLS

This repo contains all the robot tools available with mc_rtc and allows you to integrate your tool easily to mc_rtc.

## Compile and launch

### Build

Using superbuild


* From source

```bash
git clone ...
cd ..
mkdir build ; cd build
cmake .. -DCMAKE_INSTALL_PREFIX={your prefix}
make
make install
```

### mc_rtc config example

```yaml
#MainRobot: CallMCameraInterface
MainRobot: PandaProsthesis::PandaDefault::BoneTag::Femur
Enabled: Posture
```

## Add new robot

In order to add a new tool or interface, you need to create a new folder with the given architecture :

TODO add architecture

You can also check the example given here :
TODO add link
