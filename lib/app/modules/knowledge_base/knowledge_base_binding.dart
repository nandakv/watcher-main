import 'package:get/get.dart';

import 'knowledge_base_logic.dart';

class KnowledgeBaseBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => KnowledgeBaseLogic());
  }
}
