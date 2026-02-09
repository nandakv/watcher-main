import 'package:get/get.dart';
import 'help_support_logic.dart';

class HelpAndSupportBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => HelpAndSupportLogic());
  }
}
