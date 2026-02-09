import 'package:get/get.dart';

import 'design_system_components_logic.dart';

class DesignSystemComponentsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => DesignSystemComponentsLogic());
  }
}
