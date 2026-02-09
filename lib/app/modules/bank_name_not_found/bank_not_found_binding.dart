import 'package:get/get.dart';

import 'bank_not_found_logic.dart';

class BankNotFoundBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => BankNotFoundLogic());
  }
}
