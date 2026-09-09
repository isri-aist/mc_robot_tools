#include <mc_rbdyn/RobotLoader.h>

int main(int argc, char * argv[])
{
  if(argc < 2)
  {
    return 1;
  }
  mc_rbdyn::RobotLoader::clear();
  mc_rbdyn::RobotLoader::update_robot_module_path({std::string(argv[1])});

  // clang-format off
  auto rm = mc_rbdyn::RobotLoader::get_robot_module(@ROBOT_MODULE_PARAMS@);
  // clang-format on

  return 0;
}
