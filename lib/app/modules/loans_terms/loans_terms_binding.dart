import 'package:get/get.dart';

import 'loans_terms_logic.dart';

class LoansTermsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => LoansTermsLogic());
  }
}
