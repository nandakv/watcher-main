import 'package:get/get.dart';

import 'credit_report_logic.dart';

class CreditReportBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => CreditReportLogic());
  }
}
