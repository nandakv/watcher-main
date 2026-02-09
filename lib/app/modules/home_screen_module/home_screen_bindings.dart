import 'package:privo/app/modules/home_screen_module/home_screen_card/primary_home_screen_card/primary_home_screen_card_logic.dart';
import 'package:privo/app/modules/servicing_home_screen/servicing_home_screen_logic.dart';
import 'package:get/get.dart';

import '../knowledge_base/knowledge_base_logic.dart';
import 'home_screen_logic.dart';

class HomeScreenBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => HomeScreenLogic());
    Get.lazyPut(() => ServicingHomeScreenLogic());
    Get.lazyPut(() => KnowledgeBaseLogic());


    ///home screen logic handles Withdrawal Bottom Widget Logic
    ///to maintain separation of concern
    // Get.lazyPut(() => HomePageWithdrawalAlertLogic());
    Get.lazyPut(() => PrimaryHomeScreenCardLogic());
  }
}
