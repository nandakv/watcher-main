import 'package:get/get.dart';

import 'payment_loans_list_logic.dart';

class PaymentLoansListBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => PaymentLoansListLogic());
  }
}
