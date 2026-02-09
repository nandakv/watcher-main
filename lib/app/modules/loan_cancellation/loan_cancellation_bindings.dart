import 'package:get/get.dart';
import 'package:privo/app/modules/loan_cancellation/loan_cancellation_logic.dart';

class LoanCancellationBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => LoanCancellationLogic());
  }
}
