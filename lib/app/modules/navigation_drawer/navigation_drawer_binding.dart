import 'package:get/get.dart';

import 'navigation_drawer_logic.dart';

class NavigationDrawerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => NavigationDrawerLogic());
  }
}
