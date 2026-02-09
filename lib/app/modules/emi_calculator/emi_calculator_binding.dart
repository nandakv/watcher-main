import 'package:get/get.dart';

import 'emi_calculator_logic.dart';

class EmiCalculatorBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => EmiCalculatorLogic());
  }
}
