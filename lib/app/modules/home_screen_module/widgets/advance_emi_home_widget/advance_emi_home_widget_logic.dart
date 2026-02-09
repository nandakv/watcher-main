// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:privo/app/api/api_error_mixin.dart';
// import 'package:privo/app/mixin/advance_emi_payment_mixin.dart';
// import 'package:privo/app/models/loans_model.dart';
// import 'package:privo/app/modules/home_screen_module/home_screen_analytics.dart';
//
// import '../../../../models/advance_emi_payment_info_model.dart';
// import '../../../../routes/app_pages.dart';
// import '../../../payment_loans_list/payment_loans_list_view.dart';
// import '../alert/home_page_alert_widget_logic.dart';
//
// class AdvanceEMIHomeWidgetLogic extends GetxController
//     with HomeScreenAnalytics, ApiErrorMixin, AdvanceEMIPaymentMixin {
//   final benefitsController = PageController();
//
//   HomePageWithdrawalAlertLogic homePageBottomWidgetLogic =
//       Get.find<HomePageWithdrawalAlertLogic>();
//
//   List<String> benefitsList = [
//     "Increase your chances of a Credit Line upgrade by paying your upcoming EMI before the due date",
//     "Choose from various options to pay your upcoming EMI without worrying about maintaining the EMI amount in your bank.",
//     "Paying your EMI before the due date offers a financial safety net, reducing worries during tight spots or emergencies."
//   ];
//
//   onBenefitIndexChanged(int index) {
//     logAdvanceEMIBenefit(index);
//   }
//
//   onPressAdvanceEMIKnowMore(
//       AdvanceEMIPaymentInfoModel? advanceEMIPaymentInfoModel,
//       List<Loans> loanList) {
//     logAdvanceEMIKnowMoreClick();
//     onAdvanceEMIKnowMorePressed(advanceEMIPaymentInfoModel, showFAQ: true);
//   }
//
//   onPressPayButton(
//     List<Loans> loanList,
//     AdvanceEMIPaymentInfoModel? advanceEMIPaymentInfoModel,
//   ) async {
//     logAdvanceEMIPayCTAClick(
//       noOfEMIs: loanList.length.toString(),
//       amount: advanceEMIPaymentInfoModel?.loanId ?? "",
//       loanId: advanceEMIPaymentInfoModel?.loanId ?? "",
//     );
//     if (advanceEMIPaymentInfoModel == null) {
//       ///Redirect to payment loan list page if more than one loan
//       await Get.toNamed(
//         Routes.PAYMENT_LOAN_LIST,
//         arguments: {
//           'type': PaymentLoanListType.advanceEMI,
//           'loans_list': loanList,
//         },
//       );
//     } else {
//       await PaymentNavigationService().navigate(
//         routeArguments: getAdvanceEMIPaymentArgument(
//           advanceEMIPaymentInfoModel: advanceEMIPaymentInfoModel,
//           dueDate:
//         ),
//       );
//     }
//     // homePageBottomWidgetLogic.getCustomerLoans();
//   }
// }
