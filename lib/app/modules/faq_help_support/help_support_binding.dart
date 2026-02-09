import 'package:get/get.dart';
import 'faq_help_support_logic.dart';

class FAQHelpSupportBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => FAQHelpSupportLogic());
  }
}
