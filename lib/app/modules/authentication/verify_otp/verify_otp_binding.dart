import 'package:get/get.dart';

import 'verify_otp_logic.dart';

class VerifyOTPBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => VerifyOTPLogic());
  }
}
