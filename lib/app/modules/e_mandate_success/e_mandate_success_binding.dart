import 'package:get/get.dart';

import 'e_mandate_success_logic.dart';

class EMandateSuccessBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => EMandateSuccessLogic());
  }
}
