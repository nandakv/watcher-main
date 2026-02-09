import 'package:get/get.dart';

import 'app_rating_logic.dart';

class AppRatingBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => AppRatingLogic());
  }
}
