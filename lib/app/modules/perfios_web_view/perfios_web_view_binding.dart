import 'package:privo/app/modules/on_boarding/on_boarding_logic.dart';
import 'package:get/get.dart';

import 'perfios_web_view_logic.dart';

class PerfiosWebViewBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => PerfiosWebViewLogic());
    Get.lazyPut(() => OnBoardingLogic());
  }
}
