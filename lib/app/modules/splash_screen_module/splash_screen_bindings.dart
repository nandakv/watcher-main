import '../splash_screen_module/splash_screen_controller.dart';
import 'package:get/get.dart';


class SplashScreenBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => SplashScreenController());
  }
}