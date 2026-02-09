import 'package:get/get.dart';
import 'package:privo/app/modules/payment/payment_logic.dart';

class PaymentBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => PaymentLogic());
  }
}
