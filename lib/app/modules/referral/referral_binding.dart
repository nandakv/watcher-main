import 'package:get/get.dart';

import 'referral_logic.dart';

class ReferralBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ReferralLogic());
  }
}
