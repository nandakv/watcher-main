import 'package:get/get.dart';
import 'package:privo/app/modules/authentication/sign_in_screen/sign_in_screen_logic.dart';

class SignInScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => SignInScreenLogic());
  }
}
