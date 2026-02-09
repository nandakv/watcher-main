import 'dart:async';

import 'package:after_layout/after_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:privo/app/common_widgets/gradient_border_container.dart';
import 'package:privo/app/common_widgets/rich_text_widget.dart';
import 'package:privo/app/common_widgets/spacer_widgets.dart';
import 'package:privo/app/components/top_navigation_bar.dart';
import 'package:privo/app/models/rich_text_model.dart';
import 'package:privo/app/models/supported_banks_model.dart';
import 'package:privo/app/theme/app_colors.dart';
import 'package:privo/app/utils/app_text_styles.dart';
import 'package:privo/components/svg_icon.dart';
import 'package:privo/res.dart';

import '../../../../../components/button.dart';
import 'bank_selection_widget_logic.dart';

class FinsightsBankSelectionWidget extends StatefulWidget {
  final Function(BanksModel banksModel) onContinueTapped;
  final bool isCTALoading;
  final Function(String bankName)? onBankSelected;

  const FinsightsBankSelectionWidget({
    super.key,
    required this.onContinueTapped,
    this.onBankSelected,
    this.isCTALoading = false,
  });

  @override
  State<FinsightsBankSelectionWidget> createState() =>
      _FinsightsBankSelectionWidgetState();
}

class _FinsightsBankSelectionWidgetState
    extends State<FinsightsBankSelectionWidget> with AfterLayoutMixin {
  BankSelectionWidgetLogic logic = Get.put(BankSelectionWidgetLogic());

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return logic.finSightsBackClicked(
          "Finsights Bank Selection",
        );
      },
      child: SafeArea(
        child: GetBuilder<BankSelectionWidgetLogic>(
          id: logic.BANK_PAGE_ID,
          builder: (logic) {
            return logic.isLoading
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      TopNavigationBar(
                        title: "Finsights",
                        onBackPressed: () => logic.finSightsBackClicked(
                          "Finsights Bank Selection",
                        ),
                      ),
                      Expanded(
                        child: SingleChildScrollView(
                          padding: EdgeInsets.symmetric(
                            horizontal: 24.w,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              VerticalSpacer(32.h),
                              _titleWidget(),
                              VerticalSpacer(8.h),
                              _subTitleWidget(),
                              VerticalSpacer(48.h),
                              _illustration(),
                              VerticalSpacer(49.h),
                              _infoWidget(),
                              VerticalSpacer(16.h),
                              _bankInputField(),
                              VerticalSpacer(66.h),
                              _infoContainer(),
                              VerticalSpacer(10.h),
                            ],
                          ),
                        ),
                      ),
                      VerticalSpacer(10.h),
                      _ctaButton(),
                      VerticalSpacer(28.h),
                    ],
                  );
          },
        ),
      ),
    );
  }

  Widget _ctaButton() {
    return GetBuilder<BankSelectionWidgetLogic>(
      id: logic.BUTTON_ID,
      builder: (logic) {
        return Center(
          child: Button(
            buttonSize: ButtonSize.large,
            buttonType: ButtonType.primary,
            onPressed: () => widget.onContinueTapped(logic.selectedBank!),
            title: "Next",
            isLoading: widget.isCTALoading,
            enabled: logic.selectedBank != null,
          ),
        );
      },
    );
  }

  Widget _bankInputField() {
    return InkWell(
      onTap: () => logic.onBankSelectionTapped(widget.onBankSelected),
      child: Container(
        alignment: Alignment.center,
        // height: 42.h,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            const SVGIcon(
              size: SVGIconSize.medium,
              icon: Res.bankSmallSpaceIcon,
            ),
            HorizontalSpacer(10.w),
            SizedBox(
              width: 262.w,
              child: Stack(
                children: [
                  _bankSelectionField(),
                  Positioned(
                    bottom: 0,
                    child: Container(
                      height: 0.6.h,
                      width: 262.w,
                      color: grey700,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _bankSelectionField() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(
          child: GetBuilder<BankSelectionWidgetLogic>(
            id: logic.BANK_SELECTION_FIELD_ID,
            builder: (logic) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (logic.selectedBank != null)
                    Text(
                      "Bank",
                      style: AppTextStyles.bodyXSRegular(
                        color: AppTextColors.neutralBody,
                      ),
                    ),
                  VerticalSpacer(4.h),
                  if (logic.selectedBank == null)
                    Text(
                      "Select Bank",
                      style: AppTextStyles.bodyMLight(
                        color: AppTextColors.neutralBody,
                      ),
                    )
                  else
                    Text(
                      logic.selectedBank!.perfiosBankName,
                      style: AppTextStyles.bodyMMedium(
                        color: AppTextColors.neutralDarkBody,
                      ),
                    ),
                  VerticalSpacer(8.h),
                ],
              );
            },
          ),
        ),
        const SVGIcon(
          size: SVGIconSize.medium,
          direction: SVGIconDirection.down,
          icon: Res.accordion1Icon,
          color: grey700,
        ),
      ],
    );
  }

  Widget _illustration() {
    return Center(
      child: SvgPicture.asset(
        Res.bankIllustration,
        height: 192.h,
      ),
    );
  }

  Widget _infoWidget() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: const Color(0xffEFF9FD),
        borderRadius: BorderRadius.circular(4.r),
      ),
      child: Center(
        child: RichTextWidget(
          infoList: [
            RichTextModel(
              text: "*",
              textStyle: const TextStyle(
                color: redTextColor,
              ),
            ),
            RichTextModel(
              text: "You can link only one bank account at this moment",
              textStyle: AppTextStyles.bodySMedium(
                color: AppTextColors.primaryNavyBlueHeader,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _titleWidget() {
    return Text(
      "Add bank account to get started",
      style: AppTextStyles.headingSMedium(
        color: AppTextColors.brandBlueTitle,
      ),
    );
  }

  Widget _subTitleWidget() {
    return Text(
      "Link your bank for a personalised view of your finances",
      style: AppTextStyles.bodySMedium(color: AppTextColors.neutralBody),
    );
  }

  Widget _infoContainer() {
    return GradientBorderContainer(
      width: 312.w,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                const SVGIcon(
                  size: SVGIconSize.small,
                  icon: Res.informationFilledIcon,
                ),
                HorizontalSpacer(8.w),
                Text(
                  "Why link bank account?",
                  style: AppTextStyles.bodySSemiBold(
                      color: AppTextColors.primaryNavyBlueHeader),
                ),
              ],
            ),
            VerticalSpacer(9.h),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                HorizontalSpacer(7.w),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 7.h),
                  width: 4.w,
                  height: 4.w,
                  decoration: const BoxDecoration(
                    color: AppBackgroundColors.primaryFocus,
                    shape: BoxShape.circle,
                  ),
                ),
                HorizontalSpacer(6.w),
                Expanded(
                  child: Text(
                    "Get personalised insights into your bank account effortlessly",
                    style: AppTextStyles.bodySRegular(
                      color: AppTextColors.neutralDarkBody,
                    ),
                  ),
                ),
              ],
            ),
            VerticalSpacer(9.h),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                HorizontalSpacer(7.w),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 7.h),
                  width: 4.w,
                  height: 4.w,
                  decoration: const BoxDecoration(
                    color: AppBackgroundColors.primaryFocus,
                    shape: BoxShape.circle,
                  ),
                ),
                HorizontalSpacer(6.w),
                Expanded(
                  child: Text(
                    "No more juggling multiple apps—manage everything hassle-free!",
                    style: AppTextStyles.bodySRegular(
                      color: AppTextColors.neutralDarkBody,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  FutureOr<void> afterFirstLayout(BuildContext context) {
    logic.onAfterLayout();
  }
}
