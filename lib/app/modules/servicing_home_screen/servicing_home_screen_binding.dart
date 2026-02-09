import 'package:get/get.dart';

import 'servicing_home_screen_logic.dart';

class ServicingHomeScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ServicingHomeScreenLogic());
  }
}
