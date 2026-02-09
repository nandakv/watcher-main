import 'package:get/get.dart';

import 're_payment_result_logic.dart';

class RePaymentResultBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => RePaymentResultLogic());
  }
}