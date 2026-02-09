import 'package:get/get.dart';
import 'package:privo/app/modules/low_and_grow/widgets/low_and_grow_waiting/low_and_grow_wait_logic.dart';
import 'package:privo/app/modules/on_boarding/widgets/pdf_letter/pdf_letter_logic.dart';

import 'low_and_grow_logic.dart';
import 'widgets/low_and_grow_agreement/low_and_grow_agreement_logic.dart';
import 'widgets/low_and_grow_offer/low_and_grow_offer_logic.dart';
import 'widgets/low_and_grow_success/low_and_grow_success_logic.dart';

class LowAndGrowBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => LowAndGrowLogic());
    Get.lazyPut(() => LowAndGrowAgreementLogic());
    Get.lazyPut(() => LowAndGrowOfferLogic());
    Get.lazyPut(() => LowAndGrowWaitLogic());
    Get.lazyPut(() => LowAndGrowSuccessLogic());
    Get.lazyPut(() => PDFLetterLogic());
  }
}
