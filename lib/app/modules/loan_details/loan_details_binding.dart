import 'package:get/get.dart';
import 'package:get/get_instance/src/bindings_interface.dart';

import 'loan_details_logic.dart';

class LoanDetailsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => LoanDetailsLogic());
  }
}