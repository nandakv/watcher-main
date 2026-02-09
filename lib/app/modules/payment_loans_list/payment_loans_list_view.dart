import 'dart:async';

import 'package:after_layout/after_layout.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:privo/app/common_widgets/gradient_border_container.dart';
import 'package:privo/app/common_widgets/gradient_button.dart';
import 'package:privo/app/common_widgets/nudge_badge_widget.dart';
import 'package:privo/app/common_widgets/overdue_details_bottom_sheet.dart';
import 'package:privo/app/common_widgets/rich_text_widget.dart';
import 'package:privo/app/common_widgets/spacer_widgets.dart';
import 'package:privo/app/mixin/advance_emi_payment_mixin.dart';
import 'package:privo/app/models/advance_emi_payment_info_model.dart';
import 'package:privo/app/models/loan_details_model.dart';
import 'package:privo/app/models/rich_text_model.dart';
import 'package:privo/app/modules/home_screen_module/home_screen_analytics.dart';
import 'package:privo/app/routes/app_pages.dart';
import 'package:privo/app/utils/app_functions.dart';
import 'package:privo/app/utils/app_text_styles.dart';
import 'package:privo/components/badges/cs_badge.dart';
import 'package:privo/components/button.dart';
import 'package:privo/res.dart';
import '../../../components/skeletons/skeletons.dart';
import '../../theme/app_colors.dart';
import 'payment_loans_list_logic.dart';
import 'widgets/loan_details_base_widget.dart';

enum PaymentLoanListType { overdue, advanceEMI }

class PaymentLoansListView extends StatefulWidget {
  const PaymentLoansListView({Key? key}) : super(key: key);

  @override
  State<PaymentLoansListView> createState() => _PaymentLoansListViewState();
}

class _PaymentLoansListViewState extends State<PaymentLoansListView>
    with AfterLayoutMixin, AdvanceEMIPaymentMixin, HomeScreenAnalytics {
  final logic = Get.find<PaymentLoansListLogic>();

  @override
  Widget build(BuildContext context) {
    return Material(
      child: GetBuilder<PaymentLoansListLogic>(
        builder: (logic) {
          return SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _titleBar(),
                Divider(
                  color: grey300,
                  height: 0.6.h,
                ),
                VerticalSpacer(32.h),
                if (logic.paymentLoanListType ==
                    PaymentLoanListType.overdue) ...[
                  _infoText(),
                  VerticalSpacer(32.h),
                ],
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24.w),
                  child: Text(
                    _computeTitle(),
                    style: AppTextStyles.headingXSMedium(
                        color: AppTextColors.primaryNavyBlueHeader),
                  ),
                ),
                VerticalSpacer(14.h),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        logic.isLoanListLoading
                            ? Padding(
                                padding: EdgeInsets.symmetric(horizontal: 24.w),
                                child: _skeletonView(),
                              )
                            : _showOverDueLoansList(logic)
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  String _computeTitle() {
    switch (logic.paymentLoanListType) {
      case PaymentLoanListType.overdue:
        return "Overdues";
      case PaymentLoanListType.advanceEMI:
        return "Upcoming EMIs";
    }
  }

  Widget _showOverDueLoansList(PaymentLoansListLogic logic) {
    if (logic.loanDetailsList.isNotEmpty) {
      return Column(
        children: List.generate(
          logic.loanDetailsList.length,
          (index) {
            return Padding(
              padding: EdgeInsets.only(left: 24.w, right: 24.w, bottom: 12.h,top: 10.h),
              child: _loanDetailsCard(logic.loanDetailsList[index], index),
            );
          },
        ),
      );
    } else {
      return const SizedBox();
    }
  }

  Widget _skeletonView() {
    return SkeletonItem(
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: SkeletonParagraph(
                  style: SkeletonParagraphStyle(
                    lines: 3,
                    spacing: 6,
                    lineStyle: SkeletonLineStyle(
                      randomLength: true,
                      height: 10,
                      borderRadius: BorderRadius.circular(8),
                      minLength: Get.width / 6,
                      maxLength: Get.width / 3,
                    ),
                  ),
                ),
              )
            ],
          ),
          const SizedBox(
            height: 12,
          ),
          SkeletonLine(
            style: SkeletonLineStyle(
                height: 16,
                width: Get.width,
                borderRadius: BorderRadius.circular(8)),
          )
        ],
      ),
    );
  }

  Widget _dpdBadge(String days) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: const Color(0xffEE3D4B),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        "${logic.computeDPD(days)} Days Overdue",
        style: const TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 8,
          color: offWhiteColor,
        ),
      ),
    );
  }

  Widget _loanDetailsCard(LoanDetailsModel loanDetailsModel, int index) {
    switch (logic.paymentLoanListType) {
      case PaymentLoanListType.overdue:
        return _overdueLoanDetailsCard(loanDetailsModel, index);
      case PaymentLoanListType.advanceEMI:
      default:
        return NudgeBadgeWidget(
          csBadge: CSBadge(
            text:
                "Due date: ${logic.computeDueDate(loanDetailsModel.nextDueDate)}",
            showLeadingIcon: false,
            bgColor: blue1200,
            textColor: Colors.white,
          ),
          offset: const Offset(5, -4.5),
          child: _loanDetailsInfoWidget(loanDetailsModel, index),
        );
    }
  }

  Widget _overdueLoanDetailsCard(LoanDetailsModel loanDetailsModel, int index) {
    return NudgeBadgeWidget(
      csBadge: CSBadge(
        text: logic.computeOverDueBadgeTitle(loanDetailsModel),
        showLeadingIcon: false,
        bgColor: red700,
        textColor: Colors.white,
      ),
      offset: const Offset(5, -3.5),
      child: _overDueLoanDetailsInfoWidget(loanDetailsModel, index),
    );
  }

  Widget _overDueLoanDetailsInfoWidget(
      LoanDetailsModel loanDetailsModel, int index) {
    return LoanDetailsBaseWidget(
      loanDetailsModel: loanDetailsModel,
      index: index,
      loanSpecificInfoWidget: RichTextWidget(
        infoList: [
          RichTextModel(
            text: "Total due amount: ",
            textStyle: AppTextStyles.bodySRegular(
                color: AppTextColors.neutralDarkBody),
          ),
          RichTextModel(
            text: AppFunctions().parseNumberToCommaFormatWithRupeeSymbol(
                num.parse(loanDetailsModel.totalPendingAmount.isEmpty
                    ? '0'
                    : loanDetailsModel.totalPendingAmount)),
            textStyle:
                AppTextStyles.bodySMedium(color: AppTextColors.neutralDarkBody),
          ),
          RichTextModel(
            text: "\nView the breakdown",
            textStyle: AppTextStyles.bodyXSRegular(color: AppTextColors.link),
            onTap: () {
              _onKnowMoreClicked(loanDetailsModel);
            },
          )
        ],
      ),
    );
  }

  Widget _loanDetailsInfoWidget(LoanDetailsModel loanDetailsModel, int index) {
    return LoanDetailsBaseWidget(
      loanDetailsModel: loanDetailsModel,
      index: index,
      loanSpecificInfoWidget: RichTextWidget(
        infoList: [
          RichTextModel(
            text: "EMI amount: ",
            textStyle: AppTextStyles.bodySRegular(
                color: AppTextColors.neutralDarkBody),
          ),
          RichTextModel(
            text: AppFunctions().parseNumberToCommaFormatWithRupeeSymbol(
                num.parse(loanDetailsModel.emiAmount)),
            textStyle:
                AppTextStyles.bodySMedium(color: AppTextColors.neutralDarkBody),
          ),
          RichTextModel(
              text: "\nView loan details",
              textStyle: AppTextStyles.bodyXSRegular(color: AppTextColors.link),
              onTap: () {
                computeKnowMoreWidget(loanDetailsModel, index);
              })
        ],
      ),
    );
  }

  computeKnowMoreWidget(LoanDetailsModel loanDetailsModel, int index) async{
    if (logic.paymentLoanListType == PaymentLoanListType.advanceEMI) {
      await Get.toNamed(
        Routes.LOAN_DETAILS_SCREEN,
        arguments: {"loan_details": logic.loanList[index]},
      );
    } else {
      _onKnowMoreClicked(loanDetailsModel);
    }
  }

  void _onKnowMoreClicked(LoanDetailsModel loanDetailsModel) {
    logic.logOnOverdueKnowMoreClicked(loanDetailsModel);
    Get.bottomSheet(
      OverDueDetailsBottomSheet(
        loanDetailsModel: loanDetailsModel,
        referenceId: loanDetailsModel.loanId,
      ),
      isScrollControlled: true,
    );
  }

  SizedBox _titleBar() {
    return SizedBox(
      width: double.infinity,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 17.h),
        child: Row(
          children: [
            InkWell(
              child: SvgPicture.asset(Res.arrowBack),
              onTap: () {
                Get.back();
              },
            ),
            HorizontalSpacer(16.w),
            Text(
              _computeAppBarTitle(),
              style: AppTextStyles.headingSMedium(color: blue1600),
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoText() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: Row(
        children: [
          SvgPicture.asset(Res.overDueAlertBulb),
          HorizontalSpacer(12.w),
          Flexible(
            child: Text(
              "Pay now to stop accruing late fees and protect your credit profile",
              style: AppTextStyles.bodyXSMedium(
                  color: AppTextColors.primaryNavyBlueHeader),
            ),
          )
        ],
      ),
    );
  }

  String _computeAppBarTitle() {
    switch (logic.paymentLoanListType) {
      case PaymentLoanListType.overdue:
        return "Overdue";
      case PaymentLoanListType.advanceEMI:
        return "EMI Fast-Track";
    }
  }

  @override
  FutureOr<void> afterFirstLayout(BuildContext context) {
    logic.onAfterLayout();
  }

  void _onAdvanceEMIKnowMoreClicked(int index) {
    logAdvanceEMIKnowMoreClick();
    onAdvanceEMIKnowMorePressed(
      logic.advanceEMIList[index],
      advanceEmi: logic.loanDetailsList[index].advanceEMIPaymentTypeDetails,
    );
  }
}
