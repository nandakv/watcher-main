import 'package:get/get.dart';

import 'mobile_screen_logic.dart';

class MobileScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => MobileScreenLogic());
  }
}
