import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:privo/app/api/response_model.dart';
import 'package:privo/app/data/repository/emi_repository.dart';
import 'package:privo/app/firebase/analytics.dart';
import 'package:privo/app/models/advance_emi_payment_info_model.dart';
import 'package:privo/app/models/loan_details_model.dart';
import 'package:privo/app/models/rich_text_model.dart';
import 'package:privo/app/utils/app_text_styles.dart';
import 'package:privo/res.dart';

import '../modules/faq/faq_page.dart';
import '../modules/faq/widget/faq_tile.dart';
import '../modules/faq/faq_utility.dart';
import '../modules/payment/model/loan_breakdown_model.dart';
import '../modules/payment/model/payment_view_model.dart';
import '../modules/payment/payment_view.dart';
import '../modules/payment/widgets/payment_know_more_bottom_sheet.dart';
import '../theme/app_colors.dart';
import '../utils/app_functions.dart';
import '../utils/web_engage_constant.dart';

mixin AdvanceEMIPaymentMixin {
  Future getAdvanceEMIPaymentInfoFromAPI(
      {required String loanId,
      required String loanStartDate,
      required String nextDueDate,
      required Function(AdvanceEMIPaymentInfoModel) onSuccess,
      required Function(ApiResponse) onFailure}) async {
    AdvanceEMIPaymentInfoModel model = await EmiRepository()
        .getAdvanceEMIPaymentInfo(
            loanId: loanId,
            loanStartDate: loanStartDate,
            nextDueDate: nextDueDate,
            paymentType: 'advance');
    if (model.apiResponse.state == ResponseState.success) {
      onSuccess(model);
    } else {
      onFailure(model.apiResponse);
    }
  }

  Future onAdvanceEMIKnowMorePressed(
      AdvanceEMIPaymentInfoModel? advanceEMIPaymentInfoModel,
      {bool showFAQ = false,
        PaymentTypeDetails? advanceEmi}) async {
    await Get.bottomSheet(
      PaymentKnowMoreBottomSheet(
        body:
        "The 'EMI Fast-track' feature allows you to pay a single EMI before the due date, removing the need to maintain the EMI amount in your bank account. Payments can be made up to 7 days before the due date.",
        faqTile: const FAQTile(
          question: "How long does the payment process take?",
          answer: "Process takes about 2-3 minutes",
          isExpandEnabled: false,
        ),
        image: Res.informationOutlined,
        paymentNotEnabledTitles: [
          RichTextModel(text: "This feature allows you to pay the upcoming EMI in advance. Please note, that only a single EMI can be paid in advance which will be applied to your upcoming EMI. It won't be considered as a part-prepayment or a foreclosure of your loan, and therefore, no interest benefit will be provided. Learn more with",textStyle:  AppTextStyles.bodySRegular(color: AppTextColors.neutralBody)),
          RichTextModel(text: " FAQs",textStyle: AppTextStyles.bodySRegular(color: AppTextColors.primaryInverseTitle),onTap: () async {
            AppAnalytics.trackWebEngageEventWithAttribute(
              eventName: WebEngageConstants.seeMoreFAQ,
              attributeName: {
                "faq_upcoming_dues": true,
              },
            );
            await Get.to(
                  () => FAQPage(
                faqModel: FAQUtility().emiFastTrackFAQs,
              ),
            );
            AppAnalytics.trackWebEngageEventWithAttribute(
              eventName: WebEngageConstants.closeScreen,
              attributeName: {
                "close_faq_upcoming_dues": true,
              },
            );
          })
        ],
        paymentNotEnabledString: "${advanceEmi?.startDate} to ${advanceEmi?.endDate}.",
        paymentNotEnabledTexts:[
          RichTextModel(text: "You can pay your next EMI between",textStyle: AppTextStyles.bodySMedium(color: AppTextColors.neutralBody)),
          RichTextModel(text: "\n${advanceEmi?.startDate} to ${advanceEmi?.endDate}",textStyle: AppTextStyles.bodyLSemiBold(color: AppTextColors.brandBlueTitle))
        ],
        onPressMoreFAQ: () async {
          AppAnalytics.trackWebEngageEventWithAttribute(
            eventName: WebEngageConstants.seeMoreFAQ,
            attributeName: {
              "faq_upcoming_dues": true,
            },
          );
          await Get.to(
                () => FAQPage(
              faqModel: FAQUtility().emiFastTrackFAQs,
            ),
          );
          AppAnalytics.trackWebEngageEventWithAttribute(
            eventName: WebEngageConstants.closeScreen,
            attributeName: {
              "close_faq_upcoming_dues": true,
            },
          );
        },
      ),
    );
  }

  LoanBreakdownModel _knowMoreLoanBreakDownModel(
    AdvanceEMIPaymentInfoModel advanceEMIPaymentInfoModel,
  ) {
    return LoanBreakdownModel(
      padding: EdgeInsets.zero,
      title: "Breakdown (Reference ID: #${advanceEMIPaymentInfoModel.loanId})",
      titleTextStyle: const TextStyle(
        fontSize: 10,
        fontWeight: FontWeight.w600,
        color: accountSummaryTitleColor,
      ),
      breakdownRowData: [
        LoanBreakdownRowData(
          key: "Principal amount (A)",
          keyTextStyle:
              AppTextStyles.bodySRegular(color: AppTextColors.neutralBody),
          valueTextStyle:
              AppTextStyles.bodySMedium(color: AppTextColors.neutralDarkBody),
          value: AppFunctions.getIOFOAmount(
            double.parse(advanceEMIPaymentInfoModel.emiPrincipal.toString()),
          ),
        ),
        LoanBreakdownRowData(
          key: "Monthly interest amount (B)",
          value: AppFunctions.getIOFOAmount(
            double.parse(advanceEMIPaymentInfoModel.emiInterest.toString()),
          ),
        ),
      ],
      showDivider: true,
      backgroundColor: Colors.white,
      bottomBarColor: Colors.white,
      bottomWidget: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          Expanded(
            flex: 6,
            child: Text(
              "Total EMI amount (A+B)",
              style: AppTextStyles.bodySMedium(
                  color: AppTextColors.neutralDarkBody),
            ),
          ),
          Expanded(
            flex: 4,
            child: Text(
              AppFunctions.getIOFOAmount(
                double.parse(advanceEMIPaymentInfoModel.emiAmount.toString()),
              ),
              textAlign: TextAlign.end,
              style: AppTextStyles.bodySMedium(
                  color: AppTextColors.neutralDarkBody),
            ),
          ),
        ],
      ),
    );
  }

  PaymentViewArgumentModel getAdvanceEMIPaymentArgument(
      {required AdvanceEMIPaymentInfoModel advanceEMIPaymentInfoModel,
        required LoanDetailsModel loanDetailModel}) {
    return PaymentViewArgumentModel(
        loanId: advanceEMIPaymentInfoModel.loanId,
        appFormID: loanDetailModel.appFormId,
        paymentType: PaymentType.advanceEmi,
        loanDetailsModel: loanDetailModel,
        breakdownRowData: [
          _getBreakdownRowData(
              "Principal Amount(A)", advanceEMIPaymentInfoModel.emiPrincipal),
          _getBreakdownRowData("Monthly Interest Amount (B)",
              advanceEMIPaymentInfoModel.emiInterest),
        ],
        totalAmoutKey: "Total EMI amount (A+B)",
        totalAmountValue:
            _parseIntToString(advanceEMIPaymentInfoModel.emiAmount),
        finalPayableAmount: advanceEMIPaymentInfoModel.emiAmount);
  }

  LoanBreakdownRowData _getBreakdownRowData(String key, num value) {
    return LoanBreakdownRowData(
      key: key,
      value: _parseIntToString(value),
      valueTextStyle: _tableValueTextStyle,
    );
  }

  TextStyle get _tableValueTextStyle {
    return GoogleFonts.poppins(
      fontSize: 14,
      color: primaryDarkColor,
      fontWeight: FontWeight.w600,
    );
  }

  String _parseIntToString(num num) {
    return '₹${AppFunctions().parseIntoCommaFormat(num.toString())}';
  }
}
