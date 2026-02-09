import 'package:get/get.dart';

import 're_payment_type_selector_logic.dart';

class RePaymentTypeSelectorBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => RePaymentTypeSelectorLogic());
  }
}