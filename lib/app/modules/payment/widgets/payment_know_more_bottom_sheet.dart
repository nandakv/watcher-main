import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:privo/app/common_widgets/rich_text_widget.dart';
import 'package:privo/app/common_widgets/spacer_widgets.dart';
import 'package:privo/app/models/rich_text_model.dart';
import 'package:privo/app/modules/payment/model/loan_breakdown_model.dart';
import 'package:privo/app/modules/payment/widgets/loan_breakdown_widget.dart';
import 'package:privo/app/utils/app_text_styles.dart';
import 'package:privo/res.dart';

import '../../../common_widgets/bottom_sheet_widget.dart';
import '../../../theme/app_colors.dart';

class PaymentKnowMoreBottomSheet extends StatelessWidget {
  const PaymentKnowMoreBottomSheet({
    Key? key,
    required this.body,
    required this.faqTile,
    required this.onPressMoreFAQ,
    this.loanBreakdownModel,
    this.bottomWidget,
    this.image = "",
    this.paymentNotEnabledString = "",
    required this.paymentNotEnabledTitles,
    this.paymentNotEnabledTexts,
    this.disableFaq = false,
  }) : super(key: key);

  final String body;
  final String image;
  final List<RichTextModel> paymentNotEnabledTitles;
  final Widget faqTile;
  final Function onPressMoreFAQ;
  final LoanBreakdownModel? loanBreakdownModel;
  final Widget? bottomWidget;
  final String paymentNotEnabledString;
  final List<RichTextModel>? paymentNotEnabledTexts;
  final bool disableFaq;

  @override
  Widget build(BuildContext context) {
    return BottomSheetWidget(
      childPadding: EdgeInsets.zero,
      child: paymentNotEnabledString.isEmpty
          ? _breakDownWidget()
          : _paymentNotEnabledWidget(),
    );
  }

  Widget _paymentNotEnabledWidget() {
    return Column(
      children: [
        if(paymentNotEnabledTitles.isNotEmpty && image.isNotEmpty) SvgPicture.asset(image),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w,vertical: 16.h),
          child: RichTextWidget(infoList: paymentNotEnabledTitles),
        ),
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
              color: AppBackgroundColors.primarySubtle,
              borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(8.r),
                  bottomLeft: Radius.circular(8.r))),
          padding: EdgeInsets.only(bottom: 24.h,top: 16.h),
          child: paymentNotEnabledTexts == null
              ? Text(
            paymentNotEnabledString,
            style: const TextStyle(
              fontWeight: FontWeight.w500,
              color: darkBlueColor,
              fontSize: 12,
            ),
          )
              : RichTextWidget(
            infoList: paymentNotEnabledTexts!,
            textAlign: TextAlign.center,
          ),
        )
      ],
    );
  }

  Column _breakDownWidget() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RichTextWidget(infoList: [
                RichTextModel(
                    text: body,
                    textStyle: AppTextStyles.bodySRegular(
                        color: AppTextColors.neutralBody)),
                if (disableFaq)
                  RichTextModel(
                      text: " FAQs",
                      textStyle:
                      AppTextStyles.bodySRegular(color: AppTextColors.link),
                      onTap: () => onPressMoreFAQ())
              ]),
              VerticalSpacer(
                32.h,
              ),
              if (!disableFaq)...[
                Text(
                  "Frequently asked questions (FAQs)",
                  style: AppTextStyles.headingSMedium(
                      color: AppTextColors.brandBlueTitle),
                ),
                VerticalSpacer(
                  16.h,
                ),
                faqTile,
                VerticalSpacer(8.h),
                InkWell(
                  onTap: () => onPressMoreFAQ(),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        'See more FAQs',
                        style:
                        AppTextStyles.bodySRegular(color: AppTextColors.link),
                      ),
                      HorizontalSpacer(4.w),
                      SvgPicture.asset(Res.doubleArrow),
                    ],
                  ),
                ),
                SizedBox(
                  height: 10.h,
                ),
              ],

              if (loanBreakdownModel != null)
                LoanBreakdownWidget(
                  breakdownModel: loanBreakdownModel!,
                  disableBorder: true,
                ),
              const SizedBox(
                height: 10,
              ),
            ],
          ),
        ),
        if (bottomWidget != null) bottomWidget!,
      ],
    );
  }
}