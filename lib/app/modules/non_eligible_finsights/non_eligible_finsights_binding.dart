import 'package:get/get.dart';
import 'package:privo/app/modules/non_eligible_finsights/non_eligible_finsights_logic.dart';

class NonEligibleFinsightBinding extends  Bindings{

  @override
  void dependencies() {
    Get.lazyPut(() => NonEligibleFinsightLogic());
  }
}