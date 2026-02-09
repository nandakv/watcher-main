import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:privo/app/modules/re_payment_result/re_payment_result_model.dart';
import 'package:privo/app/modules/re_payment_type_selector/re_payment_type_selector_analytics.dart';

class RePaymentResultLogic extends GetxController
    with RePaymentTypeSelectorAnalytics {
  RePaymentResultModel resultModel = Get.arguments;

  void onTryAgainClicked() {
    logPaymentFailureRetryClicked();
    Get.back(result: false);
  }
}
