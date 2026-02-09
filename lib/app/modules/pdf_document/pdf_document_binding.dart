import 'package:get/get.dart';

import 'pdf_document_logic.dart';

class PDFDocumentBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => PDFDocumentLogic());
  }
}
