import 'package:get/get.dart';
import 'package:privo/app/modules/topup_know_more/topup_know_more_logic.dart';

class TopUpKnowMoreBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => TopUpKnowMoreLogic());
  }
}
