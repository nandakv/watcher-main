import 'package:get/get.dart';

import 'offer_upgrade_history_logic.dart';

class OfferUpgradeHistoryBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => OfferUpgradeHistoryLogic());
  }
}
