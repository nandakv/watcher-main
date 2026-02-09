import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../../components/radio_tile.dart';
import '../../common_widgets/bottom_sheet_widget.dart';
import '../../common_widgets/spacer_widgets.dart';
import '../../theme/app_colors.dart';
import '../../utils/app_text_styles.dart';
import 'job_type_model.dart';
import 'non_eligible_finsights_logic.dart';

class WorkTypeSpecificQuestions extends StatelessWidget {
  WorkTypeSpecificQuestions({super.key});

  final logic = Get.find<NonEligibleFinsightLogic>();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildWorkTypeGrid(), // display grid
        _buildWorkTypeQuestions(), // display question title
      ],
    );
  }

  GetBuilder<NonEligibleFinsightLogic> _buildWorkTypeQuestions() {
    return GetBuilder<NonEligibleFinsightLogic>(
      id: "questions",
      builder: (_) {
        final selectedEnum = logic.selectedJobTypeEnum;
        if (selectedEnum == null ) {
          return const SizedBox();
        }
        final questions = selectedEnum.computeQuestions(logic);
        return Padding(
          padding: EdgeInsets.only(top: 40.h, left: 4.w),
          child: Column(
            children: questions.map((question) {
              return Column(
                children: [
                  _buildQuestionTile(question),
                  VerticalSpacer(24.h),
                ],
              );
            }).toList(),
          ),
        );
      },
    );
  }

  GetBuilder<NonEligibleFinsightLogic> _buildWorkTypeGrid() {
    return GetBuilder<NonEligibleFinsightLogic>(
      id: "grid_id",
      builder: (_) {
        return GridView.count(
          shrinkWrap: true,
          crossAxisCount: 2,
          crossAxisSpacing: 10.w,
          mainAxisSpacing: 16.h,
          childAspectRatio: 1.3,
          children: WorkType.values.map((jobType) {
            final isSelected = logic.selectedType == jobType.title;
            return GestureDetector(
              onTap: () {
                logic.onTapGrid(jobType);
              },
              child: Card(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                elevation: 2,
                child: Padding(
                  padding: EdgeInsets.all(12.0.w),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Container(
                            decoration: const BoxDecoration(
                              color: Color(0xFFEAF5FF),
                              shape: BoxShape.circle,
                            ),
                            padding: EdgeInsets.all(11.w),
                            child: SvgPicture.asset(jobType.img),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 12.w),
                            child: Icon(
                              isSelected
                                  ? Icons.radio_button_checked
                                  : Icons.radio_button_unchecked,
                              color: const Color(0xFF003366),
                            ),
                          ),
                        ],
                      ),
                      VerticalSpacer(16.h),
                      Text(
                        jobType.title,
                        style: AppTextStyles.bodySMedium(color: darkBlueColor),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
        );
      },
    );
  }

  void _showRadioBottomSheet(JobTypeQuestion question) {
    Get.bottomSheet(
      GetBuilder<NonEligibleFinsightLogic>(
          id: logic.BUSINESS_SELECTION_ID,
          builder: (logic) {
            return BottomSheetWidget(
              child: Container(
                padding: EdgeInsets.all(16.w),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(question.title,
                        style: AppTextStyles.headingMedium(
                            color: appBarTitleColor)),
                    VerticalSpacer(8.h),
                    Text(question.subTitle,
                        style: AppTextStyles.bodySRegular(
                            color: secondaryDarkColor)),
                    VerticalSpacer(16.h),
                    ...question.options.map((option) => Padding(
                      padding:  EdgeInsets.symmetric(vertical: 6.0.h),
                      child: RadioTile<String>(
                            label: option,
                            groupValue: question.selectedValue,
                            value: option,
                            onChange: (val) {
                              if (val != null) {
                                question.onChanged(val);
                                logic.updateUI();
                              }
                              Get.back();
                            },
                          ),
                    )),
                  ],
                ),
              ),
            );
          }),
      isScrollControlled: true,
    );
  }

  Widget _buildQuestionTile(JobTypeQuestion question) {
    return GetBuilder<NonEligibleFinsightLogic>(
        id: logic.HINT_TEXT,
        builder: (context) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(question.label,
                  style: AppTextStyles.bodyMMedium(color: appBarTitleColor)),
              VerticalSpacer(8.h),
              GestureDetector(
                onTap: () => _showRadioBottomSheet(question),
                child: Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(right: 12.w),
                      child: SvgPicture.asset(question.img,
                          height: 24.h, width: 24.w),
                    ),
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            vertical: 4.h, horizontal: 12.w),
                        decoration: const BoxDecoration(
                          border:
                              Border(bottom: BorderSide(color: Colors.grey)),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              (question.selectedValue.isEmpty)
                                  ? question.hint
                                  : question.selectedValue,
                              style: AppTextStyles.bodyMMedium(
                                color: (question.selectedValue.isEmpty)
                                    ? Colors.grey
                                    : grey900,
                              ),
                            ),
                            const Icon(Icons.keyboard_arrow_down,
                                color: secondaryDarkColor),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        });
  }
}
