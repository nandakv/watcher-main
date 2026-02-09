import 'package:get/get.dart';
import 'package:privo/app/modules/profile/profile_logic.dart';

import '../app_permissions/app_permissions_logic.dart';

class ProfileBinding extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut(() => ProfileLogic());
  }
}