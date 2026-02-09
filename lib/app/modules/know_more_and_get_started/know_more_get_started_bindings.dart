import 'package:get/get.dart';
import 'package:privo/app/modules/know_more_and_get_started/know_more_get_started_logic.dart';

class KnowMoreGetStartedBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => KnowMoreGetStartedLogic());
  }
}
