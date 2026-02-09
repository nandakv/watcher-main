import 'package:get/get.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:privo/app/api/api_error_mixin.dart';
import 'package:privo/app/firebase/analytics.dart';
import 'package:privo/app/modules/low_and_grow/widgets/low_and_grow_success/low_and_grow_success_navigation.dart';
import 'package:privo/app/modules/on_boarding/mixins/app_form_mixin.dart';
import 'package:privo/app/modules/pdf_document/pdf_document_logic.dart';
import 'package:privo/app/utils/web_engage_constant.dart';
import '../../../../routes/app_pages.dart';

class LowAndGrowSuccessLogic extends GetxController
    with AppFormMixin, ApiErrorMixin {
  LowAndGrowSuccessNavigation? lowAndGrowSuccessNavigation;

  fetchLetter(DocumentType documentType, String fileName) async {
    await Get.toNamed(
      Routes.PDF_DOCUMENT_SCREEN,
      arguments: {
        'documentType': documentType,
        'fileName': fileName,
      },
    );
  }
}
