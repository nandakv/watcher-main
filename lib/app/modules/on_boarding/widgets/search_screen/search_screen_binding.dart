import 'package:get/get.dart';

import 'search_screen_logic.dart';

class SearchScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => SearchScreenLogic());
  }
}
