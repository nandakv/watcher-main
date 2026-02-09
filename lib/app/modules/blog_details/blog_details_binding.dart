import 'package:get/get.dart';

import 'blog_details_logic.dart';

class BlogDetailsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => BlogDetailsLogic());
  }
}
