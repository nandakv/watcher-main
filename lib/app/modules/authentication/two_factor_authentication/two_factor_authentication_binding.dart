import 'package:get/get.dart';

import 'two_factor_authentication_logic.dart';

class TwoFactorAuthenticationBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => TwoFactorAuthenticationLogic());
  }
}
