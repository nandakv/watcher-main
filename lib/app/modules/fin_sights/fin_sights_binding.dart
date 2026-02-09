import 'package:get/get.dart';

import 'fin_sights_logic.dart';

class FinSightsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => FinSightsLogic());
  }
}
