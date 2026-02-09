import 'dart:async';

import 'package:after_layout/after_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:privo/app/common_widgets/app_lottie_widget.dart';
import 'package:privo/app/common_widgets/bottom_sheet_widget.dart';
import 'package:privo/app/common_widgets/sliding_button.dart';
import 'package:privo/app/models/home_screen_model.dart';
import 'package:privo/app/modules/credit_report/widgets/credit_score_consent_widget/credit_score_consent_widget.dart';
import 'package:privo/app/theme/app_colors.dart';
import 'package:privo/app/utils/app_text_styles.dart';
import 'package:privo/app/utils/corner_radius.dart';
import 'package:privo/components/svg_icon.dart';
import 'package:privo/res.dart';

import '../../../../common_widgets/spacer_widgets.dart';
import 'credit_report_refresh_bottom_sheet_logic.dart';

class CreditReportRefreshBottomSheet extends StatefulWidget {
  CreditReportRefreshBottomSheet({
    super.key,
    required this.creditScoreModel,
    this.isReferralEnabled = false,
  });

  final CreditScoreModel creditScoreModel;
  final bool isReferralEnabled;

  @override
  State<CreditReportRefreshBottomSheet> createState() =>
      _CreditReportRefreshBottomSheetState();
}

class _CreditReportRefreshBottomSheetState
    extends State<CreditReportRefreshBottomSheet> with AfterLayoutMixin {
  final CreditReportRefreshBottomSheetLogic logic =
      Get.put(CreditReportRefreshBottomSheetLogic());

  @override
  Widget build(BuildContext context) {
    return BottomSheetWidget(
      onCloseClicked: logic.onClosedClicked,
      enableCloseIconButton: false,
      childPadding: EdgeInsets.zero,
      child: GetBuilder<CreditReportRefreshBottomSheetLogic>(
        builder: (logic) {
          return logic.isLoading
              ? _onLoading()
              : _refreshScoreWidget(logic, context);
        },
      ),
    );
  }

  Stack _refreshScoreWidget(
      CreditReportRefreshBottomSheetLogic logic, BuildContext context) {
    return Stack(
      children: [
        GetBuilder<CreditReportRefreshBottomSheetLogic>(
          id: logic.SPARKLE_WIDGET,
          builder: (logic) {
            return logic.showSparkle
                ? const Positioned.fill(
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: AppLottieWidget(
                        assetPath: Res.creditScoreRefreshSparkles,
                        repeatCount: 1,
                      ),
                    ),
                  )
                : const SizedBox.shrink();
          },
        ),
        Column(
          children: [
            GetBuilder<CreditReportRefreshBottomSheetLogic>(
              builder: (logic) {
                return _computeBodyWidget();
              },
            ),
            if (!logic.isConsentRequired || logic.isConsentChecked)
              SlidingButton(
                status: logic.state == CreditReportRefreshWidgetState.completed
                    ? SlideStatus.viewInsights
                    : null,
                controller: logic.slidingButtonController,
                width: (MediaQuery.of(context).size.width * 0.85).clamp(150.0, 400.0),
                onSlideToLoadTriggered: () => logic.onSlideToLoadTriggered(
                  widget.creditScoreModel,
                ),
                height: 52.h,
                onTapViewInsights: () =>
                    logic.onTapViewInsights(widget.creditScoreModel,widget.isReferralEnabled),
              ),
            VerticalSpacer(32.h),
          ],
        ),
      ],
    );
  }

  SizedBox _onLoading() {
    return SizedBox(
      width: double.infinity,
      height: 300.h,
      child: const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
        ],
      ),
    );
  }

  Widget _computeBodyWidget() {
    switch (logic.state) {
      case CreditReportRefreshWidgetState.sliding:
        return _slideWidget();
      case CreditReportRefreshWidgetState.completed:
        return _creditScoreWidget();
      case CreditReportRefreshWidgetState.error:
        return _errorWidget();
    }
  }

  Widget _errorWidget() {
    return SizedBox(
      width: double.infinity,
      child: Column(
        children: [
          _closeButton(CreditReportRefreshWidgetState.error),
          SvgPicture.asset(
            Res.alertFilledIcon,
            height: 80.h,
            width: 80.h,
          ),
          VerticalSpacer(16.h),
          Text(
            "Oops! Something went wrong",
            textAlign: TextAlign.center,
            style: AppTextStyles.headingSMedium(color: blue1600),
          ),
          VerticalSpacer(8.h),
          Text(
            "We are having trouble loading the data.\nPlease try sliding again",
            textAlign: TextAlign.center,
            style: AppTextStyles.bodySRegular(color: secondaryDarkColor),
          ),
          VerticalSpacer(24.h),
        ],
      ),
    );
  }

  Widget _creditScoreWidget() {
    return SizedBox(
      width: double.infinity,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Stack(
            children: [
              Container(
                alignment: Alignment.center,
                height: 226.h,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8.r),
                  child: SvgPicture.asset(
                    Res.creditScoreRefreshBottomSheetBg,
                    fit: BoxFit.fitWidth,
                    width: double.infinity,
                  ),
                ),
              ),
              Container(
                alignment: Alignment.center,
                margin: EdgeInsets.only(top: 46.h),
                child: SvgPicture.asset(Res.creditScoreBottomSheetStarsSVG),
              ),
              Column(
                children: [
                  _closeButton(CreditReportRefreshWidgetState.completed),
                  VerticalSpacer(24.h),
                  Text(
                    logic.creditScore,
                    style: AppTextStyles.displayM(
                      color: navyBlueColor,
                      addShadow: true,
                      poppins: true,
                    ),
                  ),
                  Text(
                    "${logic.creditScoreScale.title.toUpperCase()} SCORE",
                    style: AppTextStyles.bodySSemiBold(
                      color: logic.creditScoreScale.color,
                    ),
                  ),
                  VerticalSpacer(16.h),
                  Text(
                    "Your credit score is updated! Dive deeper to\nsee what’s influencing it",
                    style: AppTextStyles.bodySRegular(color: grey700),
                    textAlign: TextAlign.center,
                  )
                ],
              )
            ],
          ),
        ],
      ),
    );
  }

  Padding _closeButton(CreditReportRefreshWidgetState state) {
    return Padding(
      padding: const EdgeInsets.only(top: 16, right: 16),
      child: Align(
        alignment: Alignment.topRight,
        child: InkWell(
          onTap:  () {
            logic.onClosedClicked(state: state);
          },
          child: Padding(
            padding: const EdgeInsets.all(5.4),
            child: SvgPicture.asset(
              Res.close_mark_svg,
              width: 13.15,
              height: 13.15,
            ),
          ),
        ),
      ),
    );
  }

  Widget _slideWidget() {
    return SizedBox(
      width: double.infinity,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _closeButton(CreditReportRefreshWidgetState.sliding),
          Image.asset(
            Res.creditScoreRefreshBottomSheetPeoplePNG,
            height: 64.h,
          ),
          VerticalSpacer(16.h),
          Text(
            "Viewed your latest Credit Score?",
            textAlign: TextAlign.center,
            style: AppTextStyles.headingSMedium(color: blue1600),
          ),
          VerticalSpacer(8.h),
          Text(
            "Over 2,000 checked their score this week.\nStay on top of your credit, check yours now!",
            textAlign: TextAlign.center,
            style: AppTextStyles.bodySRegular(color: grey700),
          ),
          VerticalSpacer(24.h),
          if (logic.isConsentRequired) ...[
            Container(
              margin: EdgeInsets.symmetric(horizontal: 24.w),
              decoration: BoxDecoration(
                  color: AppBackgroundColors.primarySubtle,
                  borderRadius: CornerRadius.small()),
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
              child: Row(
                children: [
                  const SVGIcon(
                      size: SVGIconSize.small, icon: Res.informationInfo),
                  HorizontalSpacer(8.h),
                  Flexible(
                    child: Text(
                      "Your consent has expired, re-authorise now for an updated credit score! ",
                      style: AppTextStyles.bodySRegular(
                          color: AppTextColors.neutralBody),
                    ),
                  )
                ],
              ),
            ),
            VerticalSpacer(24.h),
            Padding(
              padding:  EdgeInsets.symmetric(horizontal: 24.w),
              child: IgnorePointer(
                  ignoring: logic.isApiLoading,
                  child: CreditScoreConsentWidget(onConsentChanged: logic.onConsentChanged,textColor: blue1200,)),
            ),
            VerticalSpacer(12.h),
          ]
        ],
      ),
    );
  }

  @override
  FutureOr<void> afterFirstLayout(BuildContext context) {
    logic.onAfterFirstLayout();
  }
}
