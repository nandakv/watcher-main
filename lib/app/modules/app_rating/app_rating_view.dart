import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:privo/app/common_widgets/bottom_sheet_widget.dart';
import 'package:privo/app/common_widgets/gradient_button.dart';
import 'package:privo/app/common_widgets/spacer_widgets.dart';
import 'package:privo/app/modules/app_rating/app_rating_logic.dart';
import 'package:privo/app/modules/app_rating/success_dialog.dart';
import 'package:privo/app/modules/app_rating/widgets/feedback_suggestion_selector.dart';
import 'package:privo/app/modules/app_rating/widgets/rate_us_dialog.dart';
import 'package:privo/app/theme/app_colors.dart';
import 'package:privo/app/utils/app_text_styles.dart';
import 'package:privo/components/button.dart';
import 'package:privo/res.dart';

class AppRatingView extends StatelessWidget {
  final logic = Get.put(AppRatingLogic());

  AppRatingView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AppRatingLogic>(
      builder: (logic) {
        return BottomSheetWidget(
            childPadding: EdgeInsets.zero,
            onCloseClicked: () {
              logic.onCloseClicked(context);
            },
            enableCloseIconButton: true,
            child: computeAndShowDialog());
      },
    );
  }

  Widget computeAndShowDialog() {
    switch (logic.appRatingScreen) {
      case AppRatingScreen.rateUs:
        return RateUsDialog();
      case AppRatingScreen.experience:
        return _defaultAppReviewWidget(logic);
      case AppRatingScreen.success:
        return const SuccessDialog();
    }
  }

  Widget _defaultAppReviewWidget(AppRatingLogic logic) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          VerticalSpacer(16.h),
          Text(
            "How was your experience?",
            style: AppTextStyles.headingSMedium(color: blue1600),
          ),
          VerticalSpacer(16.h),
          _appRatingRow(),
          if (logic.showFeedbackOption) ...[
            Text(
              "Please tell us what went wrong ?",
              style: AppTextStyles.bodyLMedium(color: blue1600),
            ),
            VerticalSpacer(16.h),
            FeedbackSuggestionMultiSelector(),
            _writeYourFeedbackTextField(),
            VerticalSpacer(20.h),
          ],
          GetBuilder<AppRatingLogic>(
              id: logic.feedBackSelectorKey,
              builder: (context) {
                return Button(
                  buttonSize: ButtonSize.large,
                  buttonType: ButtonType.primary,
                  title: "Submit",
                  onPressed: () {
                    logic.postUserFeedBack();
                  },
                  enabled: logic.computeButtonEnabled(),
                );
              }),
          VerticalSpacer(32.h),
        ],
      ),
    );
  }

  Widget _writeYourFeedbackTextField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Any other feedback",
          style: AppTextStyles.bodyLMedium(color: grey900),
        ),
        VerticalSpacer(16.h),
        TextFormField(
          maxLines: 3,
          maxLength: 100,
          controller: logic.feedbackEditingController,
          onChanged: logic.onFeedbackTextChanged,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderSide: BorderSide(
                color: grey700,
                width: 0.6.w,
              ),
              borderRadius: BorderRadius.circular(8.r),
            ),
            hintText: "Write your feedback",
            hintStyle: AppTextStyles.bodyMRegular(color: grey500),
            isDense: true,
            contentPadding: EdgeInsets.all(16.h),
          ),
          style: AppTextStyles.bodySRegular(color: grey500),
        ),
      ],
    );
  }

  Align _closeButtonWidget() {
    return Align(
      alignment: Alignment.topRight,
      child: SizedBox(
        height: 25,
        child: IconButton(
          onPressed: logic.onCrossClicked,
          icon: const Icon(
            Icons.clear_rounded,
            color: appBarTitleColor,
          ),
        ),
      ),
    );
  }

  Widget _appRatingRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: List.generate(logic.appRatingModels.length, (index) {
        return AppIconWidget(
          appRatingModel: logic.appRatingModels[index],
          padding: logic.appRatingModels.length - 1 == index ? 0 : 30,
        );
      }),
    );
  }
}

class AppIconWidget extends StatelessWidget {
  var logic = Get.find<AppRatingLogic>();
  AppRatingModel appRatingModel;
  double padding;

  AppIconWidget({required this.appRatingModel, this.padding = 30});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(right: padding.w),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          InkWell(
            onTap: () {
              logic.onEmoticonTapped(appRatingModel);
            },
            child: SvgPicture.asset(
                appRatingModel.appRatingType == logic.selectedAppRating
                    ? appRatingModel.selectedIcon
                    : appRatingModel.unselectedIcon),
          ),
          VerticalSpacer(8.h),
          Text(
            appRatingModel.title,
            style: AppTextStyles.bodyXSRegular(color: navyBlueColor),
          ),
          VerticalSpacer(36.h),
        ],
      ),
    );
  }
}
