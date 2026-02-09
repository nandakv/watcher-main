import 'package:after_layout/after_layout.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:privo/app/common_widgets/vertical_spacer.dart';
import 'package:privo/app/modules/payment/widgets/advance_emi_breakdown_widget.dart';
import 'package:privo/app/modules/payment/widgets/part_pay_top_widget.dart';
import 'package:privo/app/modules/payment/model/loan_breakdown_model.dart';
import 'package:privo/app/modules/payment/payment_logic.dart';
import 'package:privo/app/modules/payment/widgets/final_payment_screen.dart';
import 'package:privo/app/modules/payment/widgets/reason_widget.dart';
import 'package:privo/app/utils/app_text_styles.dart';
import 'package:privo/app/utils/no_leading_space_formatter.dart';

import '../../../res.dart';
import '../../common_widgets/gradient_button.dart';
import '../../theme/app_colors.dart';
import '../../utils/app_functions.dart';
import '../loan_details/widgets/card_title_and_value_widget.dart';
import '../loan_details/widgets/loan_details_item_widget.dart';

enum PaymentType {
  advanceEmi,
  foreclosure,
  overdue,
  loanCancellation,
  partPay,
  none
}

class PaymentView extends StatefulWidget {
  const PaymentView({Key? key}) : super(key: key);

  @override
  State<PaymentView> createState() => _PaymentViewState();
}

class _PaymentViewState extends State<PaymentView> with AfterLayoutMixin {
  final logic = Get.find<PaymentLogic>();

  TextStyle get _resultTableTextStyle {
    return const TextStyle(
      fontFamily: 'Figtree',
      fontSize: 14,
      color: Colors.white,
      fontWeight: FontWeight.w600,
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: logic.onWillPop,
      child: GetBuilder<PaymentLogic>(
        id: logic.PAYMENT_PAGE_ID,
        builder: (logic) {
          return logic.isPageLoading
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : _finalPaymentWidget(logic);
        },
      ),
    );
  }

  FinalPaymentWidget _finalPaymentWidget(PaymentLogic logic) {
    return FinalPaymentWidget(
      onClosePressed: logic.onClosePressed,
      appbarTitle: logic.getAppbarTitle(),
      showLPCinAppBar:
          logic.paymentViewModel.paymentType == PaymentType.overdue,
      consentWidget: _computeConsentWidget(),
      ctaWidget: _ctaButton(),
      breakdownWidget: _computeBreakDownWidget(),
      topWidget: _computeTopWidget(),
      tableData: _breakDownModel(),
      body: _computeBodyWidget(logic),
      infoMessage: logic.computeInfoMessage(),
    );
  }

  LoanBreakdownModel _breakDownModel() {
    return LoanBreakdownModel(
      backgroundColor: Colors.white,
      breakdownRowData: logic.paymentViewModel.breakdownRowData,
      bottomWidgetPadding: logic.paymentViewModel.bottomWidgetPadding,
      bottomWidget: logic.paymentViewModel.paymentType != PaymentType.partPay
          ? _breakdownBottomWidget()
          : _partpayBottomWidget(),
    );
  }

  Widget _computeBodyWidget(PaymentLogic logic) {
    switch (logic.paymentViewModel.paymentType) {
      case PaymentType.overdue:
        return Container(
          decoration: BoxDecoration(
            color: Colors.red,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
            child: Row(
              children: [
                SvgPicture.asset(
                  Res.red_info_icon,
                ),
                const SizedBox(
                  width: 5,
                ),
                Flexible(
                  child: Text(
                    "Pay now to stop accruing late fees and protect your credit profile.",
                    style: GoogleFonts.poppins(
                      color: const Color(0xFFFFF3EB),
                      fontWeight: FontWeight.w500,
                      fontSize: 8,
                    ),
                  ),
                )
              ],
            ),
          ),
        );
      default:
        return logic.showReason() ? ReasonWidget() : const SizedBox();
    }
  }

  Widget _partpayBottomWidget() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SvgPicture.asset(Res.white_info),
        Flexible(
          child: Text(
            "You need to keep a minimum of ₹${AppFunctions().parseIntoCommaFormat(logic.partPaymentInfoModel.minPartPayAmount.toString())} to keep the account active.",
            style: const TextStyle(
                fontSize: 8,
                fontWeight: FontWeight.w700,
                color: Color(0xFFFFF3EB)),
          ),
        )
      ],
    );
  }

  Widget? _computeTopWidget() {
    switch (logic.paymentViewModel.paymentType) {
      case PaymentType.loanCancellation:
        return _loanCancellationTopWidget();
      case PaymentType.partPay:
        return PartPayTopWidget();
      case PaymentType.overdue:
        return _overduePartPayWidget();
      default:
        return null;
    }
  }

  Column _overduePartPayWidget() {
    return Column(
      children: [
        Text(
          "Overdue charges",
          style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w500),
        ),
        const SizedBox(
          height: 10,
        ),
      ],
    );
  }

  Widget _titleWidget(String title,
      {double size = 14,
      FontWeight fontWeight = FontWeight.w600,
      Color color = darkBlueColor}) {
    return Text(
      title,
      style: GoogleFonts.poppins(
        fontSize: size,
        fontWeight: fontWeight,
        color: color,
      ),
    );
  }

  Widget _loanCancellationTopWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _titleWidget("Withdrawal Overview"),
        verticalSpacer(24),
        _withdrawalOverviewCard(),
        verticalSpacer(24),
        _titleWidget("Amount To Pay"),
        verticalSpacer(12),
      ],
    );
  }

  Widget _withdrawalOverviewCard() {
    return Container(
      padding: const EdgeInsets.only(right: 12, left: 22, bottom: 20, top: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF3EB),
        borderRadius: const BorderRadius.all(Radius.circular(8)),
        border: Border.all(color: const Color(0xff161742), width: .5),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 10, top: 10),
            child: Column(
              children: [
                LoanDetailsItemWidget(
                    firstItem: CardTitleAndValueWidget(
                      "Amount Withdrawn",
                      '₹${AppFunctions().parseIntoCommaFormat(logic.paymentViewModel.loanCancellationDetails!.loanAmount.toString())}',
                    ),
                    secondItem: CardTitleAndValueWidget("Amount Credited",
                        '₹${AppFunctions().parseIntoCommaFormat(logic.paymentViewModel.loanCancellationDetails!.disbursalAmount.toString())}')),
                LoanDetailsItemWidget(
                    firstItem: CardTitleAndValueWidget(
                      "Rate of Interest",
                      '${logic.paymentViewModel.loanCancellationDetails!.roi}%',
                    ),
                    secondItem: CardTitleAndValueWidget(
                      "Annual Percentage Rate (APR)",
                      logic.paymentViewModel.loanCancellationDetails!.apr,
                      iconWidget:
                          _infoIcon(onPressed: logic.aprBottomSheetEvents),
                    )),
                LoanDetailsItemWidget(
                    firstItem: CardTitleAndValueWidget(
                      "Broken Period Interest (BPI)",
                      '₹${AppFunctions().parseIntoCommaFormat(logic.paymentViewModel.loanCancellationDetails!.bpiAmount.toString())}',
                      iconWidget:
                          _infoIcon(onPressed: logic.bpiBottomSheetEvents),
                    ),
                    secondItem: CardTitleAndValueWidget("Processing Fee",
                        '₹${AppFunctions().parseIntoCommaFormat(logic.paymentViewModel.loanCancellationDetails!.processingFee.toString())}')),
              ],
            ),
          ),
        ],
      ),
    );
  }

  InkWell _infoIcon({required Function() onPressed}) {
    return InkWell(
        onTap: onPressed,
        child: Padding(
          padding: const EdgeInsets.only(left: 1.0),
          child: SvgPicture.asset(
            Res.question_icon,
          ),
        ));
  }

  Widget _computeConsentWidget() {
    switch (logic.paymentViewModel.paymentType) {
      case PaymentType.advanceEmi:
        return _advanceEMIConsentWidget();
      case PaymentType.foreclosure:
      case PaymentType.loanCancellation:
      default:
        return _foreclosureOrCancellationConsentWidget();
    }
  }

  Widget _breakdownBottomWidget() {
    return Row(
      children: [
        Text(
          logic.paymentViewModel.totalAmoutKey,
          style: AppTextStyles.bodyMMedium(color: AppTextColors.neutralDarkSubtitle),
        ),
        const Spacer(),
        Text(
          logic.paymentViewModel.totalAmountValue,
          style: AppTextStyles.bodyMMedium(color: AppTextColors.neutralDarkSubtitle),
          textAlign: TextAlign.right,
        ),
      ],
    );
  }

  Widget _ctaButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: GetBuilder<PaymentLogic>(
        id: logic.PAY_BUTTON_KEY,
        builder: (logic) {
          return GradientButton(
            isLoading: logic.isButtonLoading,
            enabled: logic.paymentViewModel.paymentType ==
                        PaymentType.advanceEmi ||
                    logic.paymentViewModel.paymentType == PaymentType.overdue
                ? true
                : logic.isButtonEnabled,
            onPressed: logic.onPayCTA,
            title: "Pay ${_buttonText()}",
          );
        },
      ),
    );
  }

  _buttonText() {
    if (logic.paymentViewModel.totalAmountValue.isNotEmpty) {
      return logic.paymentViewModel.totalAmountValue;
    } else {
      return "₹${logic.partPayAmountTextController.text}";
    }
  }

  Widget _advanceEMIConsentWidget() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: RichText(
        text: TextSpan(
          children: [
             TextSpan(
              text: "I agree to the ",
              style: AppTextStyles.bodyXSRegular(color: AppTextColors.brandBlueBodyFocus),
            ),
            TextSpan(
              text: "Terms and Conditions",
              style: AppTextStyles.bodyXSRegular(color: AppTextColors.link).copyWith(decoration: TextDecoration.underline),
              recognizer: TapGestureRecognizer()..onTap = logic.onTnCClick,
            ),
             TextSpan(
              text: " by proceeding with the ‘EMI Fast-track’",
              style: AppTextStyles.bodyXSRegular(color: AppTextColors.brandBlueBodyFocus),
            ),
          ],
        ),
      ),
    );
  }

  Widget _foreclosureOrCancellationConsentWidget() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: logic.computeForeclosureCancellationConsentText(),
              style: AppTextStyles.bodyXSRegular(color: AppTextColors.brandBlueBodyFocus),
            ),
            TextSpan(
                text: "Terms and Conditions",
                style: AppTextStyles.bodyXSRegular(color: AppTextColors.link).copyWith(decoration: TextDecoration.underline),
                recognizer: TapGestureRecognizer()..onTap = logic.onTnCClick)
          ],
        ),
      ),
    );
  }

  @override
  void afterFirstLayout(BuildContext context) {
    logic.onAfterLayout();
  }

  _computeBreakDownWidget() {
    if(logic.paymentViewModel.paymentType == PaymentType.advanceEmi && logic.paymentViewModel.loanDetailsModel != null){
      return AdvanceEmiBreakdownWidget(loanDetailsModel: logic.paymentViewModel.loanDetailsModel!,breakdownModel: _breakDownModel(),);
    }
  }
}
