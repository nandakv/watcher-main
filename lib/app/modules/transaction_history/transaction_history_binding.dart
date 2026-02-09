import 'package:get/get.dart';

import 'transaction_history_logic.dart';

class TransactionHistoryBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => TransactionHistoryLogic());
  }
}
