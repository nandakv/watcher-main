import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:privo/app/common_widgets/bottom_sheet_widget.dart';
import 'package:privo/app/common_widgets/spacer_widgets.dart';
import 'package:privo/app/models/loan_details_model.dart';
import 'package:privo/app/models/pending_loan_details.dart';
import 'package:privo/app/theme/app_colors.dart';
import 'package:privo/app/utils/app_functions.dart';
import 'package:privo/app/utils/app_text_styles.dart';
import 'package:privo/components/svg_icon.dart';
import 'package:privo/res.dart';

class OverDueDetailsBottomSheet extends StatefulWidget {
  OverDueDetailsBottomSheet({
    Key? key,
    required this.loanDetailsModel,
    required this.referenceId,
  }) : super(key: key);

  LoanDetailsModel loanDetailsModel;
  String referenceId;

  @override
  State<OverDueDetailsBottomSheet> createState() =>
      _OverDueDetailsBottomSheetState();
}

class _OverDueDetailsBottomSheetState extends State<OverDueDetailsBottomSheet> {
  List<OverDueLineItem> overDueLineItems = [];

  @override
  void initState() {
    overDueLineItems = [
      OverDueLineItem(
          type: "Overdue principal amount",
          amount: AppFunctions().parseNumberToCommaFormatWithRupeeSymbol(
              num.parse(widget.loanDetailsModel.overduePrincipal))),
      OverDueLineItem(
          type: "Overdue interest amount",
          amount: AppFunctions().parseNumberToCommaFormatWithRupeeSymbol(
              num.parse(widget.loanDetailsModel.overdueInterest))),
      OverDueLineItem(
          type: "Bounce charges",
          amount: AppFunctions().parseNumberToCommaFormatWithRupeeSymbol(
              num.parse(widget.loanDetailsModel.bounceCharges))),
      OverDueLineItem(
          type: "Late pay penalty charges",
          amount: AppFunctions().parseNumberToCommaFormatWithRupeeSymbol(
              num.parse(widget.loanDetailsModel.latePaymentPenalty))),
      if (widget.loanDetailsModel.unappliedAmount.isNotEmpty)
        OverDueLineItem(
          type: "Excess amount with us",
          amount:
              "-${AppFunctions().parseNumberToCommaFormatWithRupeeSymbol(num.parse(widget.loanDetailsModel.unappliedAmount))}",
        )
    ];
  }

  @override
  Widget build(BuildContext context) {
    return BottomSheetWidget(
      enableCloseIconButton: true,
      childPadding: EdgeInsets.zero,
      child: Column(
        children: [
          VerticalSpacer(16.h),
          _overDueDetails(),
          VerticalSpacer(16.h),
          _overDueAlert()
        ],
      ),
    );
  }

  Container _overDueAlert() {
    return Container(
      decoration: _alertDecoration(),
      alignment: Alignment.center,
      padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 24.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SvgPicture.asset(
            Res.errorFilledIcon,
            width: 24.w,
            height: 24.h,
            color: red700,
          ),
          HorizontalSpacer(8.w),
          Flexible(
            child: Text(
              "Pay now to stop accruing late fees and protect your credit profile. ",
              style: AppTextStyles.bodySRegular(color: red700),
            ),
          )
        ],
      ),
    );
  }

  BoxDecoration _exclamatoryDecoration() {
    return const BoxDecoration(
        color: Color(0xFFFFF3EB), shape: BoxShape.circle);
  }

  BoxDecoration _alertDecoration() {
    return BoxDecoration(
      color: AppBackgroundColors.negativeSubtle,
      borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(8.r), bottomRight: Radius.circular(8.r)),
    );
  }

  Padding _overDueDetails() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
           widget.loanDetailsModel.isPendingPayment ? "Pending amount" : "Overdue charges",
            style: AppTextStyles.headingSMedium(
                color: AppTextColors.brandBlueBodyFocus),
          ),
          VerticalSpacer(16.h),
          Text(
            "Loan ID: #${widget.referenceId}",
            style: AppTextStyles.bodySRegular(
                color: AppTextColors.neutralBody),
          ),
          VerticalSpacer(8.h),
          _overDueItems(),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 8.h),
            child: Divider(
              height: 0.06.h,
              color: grey300,
            ),
          ),
          VerticalSpacer(8.h),
          titleAndValue(
              OverDueLineItem(
                  type: "Total due amount",
                  amount: AppFunctions()
                      .parseNumberToCommaFormatWithRupeeSymbol(num.parse(
                          widget.loanDetailsModel.totalPendingAmount)),
                  shouldHighlight: true),
              titleTextStyle: AppTextStyles.bodySMedium(
                  color: AppTextColors.neutralDarkBody),
              subTitleTextStyle: AppTextStyles.bodySSemiBold(
                  color: AppTextColors.neutralDarkBody)),
        ],
      ),
    );
  }

  Widget _overDueItems() {
    return Column(
      children: List.generate(overDueLineItems.length, (index) {
        return titleAndValue(overDueLineItems[index]);
      }),
    );
  }

  Widget titleAndValue(OverDueLineItem overDueType,
      {TextStyle? titleTextStyle, TextStyle? subTitleTextStyle}) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            overDueType.type,
            style: titleTextStyle ?? _shouldHighlight(overDueType),
          ),
          Text(
            overDueType.amount,
            style: subTitleTextStyle ?? _shouldHighlight(overDueType),
          ),
        ],
      ),
    );
  }

  TextStyle _shouldHighlight(OverDueLineItem overDueType) {
    return overDueType.shouldHighlight
        ? AppTextStyles.bodySMedium(color: AppTextColors.neutralDarkBody)
        : AppTextStyles.bodySRegular(color: AppTextColors.neutralDarkBody);
  }
}

class OverDueLineItem {
  final String type;
  final String amount;
  final bool shouldHighlight;
  final bool showRupeeSymbol;

  OverDueLineItem(
      {required this.type,
      required this.amount,
      this.shouldHighlight = false,
      this.showRupeeSymbol = true});
}
