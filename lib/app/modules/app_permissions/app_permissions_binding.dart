import 'package:get/get.dart';

import 'app_permissions_logic.dart';

class AppPermissionsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => AppPermissionsLogic());
  }
}
