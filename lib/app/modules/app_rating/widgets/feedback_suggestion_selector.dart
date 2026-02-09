import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:privo/app/common_widgets/gradient_button.dart';
import 'package:privo/app/common_widgets/privo_radio_list.dart';
import 'package:privo/app/common_widgets/spacer_widgets.dart';
import 'package:privo/app/modules/app_rating/app_rating_logic.dart';
import 'package:privo/app/theme/app_colors.dart';
import 'package:privo/app/utils/app_text_styles.dart';

class FeedbackSuggestionSelector extends StatelessWidget {
  var logic = Get.find<AppRatingLogic>();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AppRatingLogic>(
      id: logic.feedBackSelectorKey,
      builder: (logic) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ...List.generate(
              logic.feedBackSelectorList.length,
              (index) {
                return RadioTheme(
                  data: _radioButtonTheme(),
                  child: ListTileTheme(
                    data: _listTileThemeData(),
                    child: RadioListTile<int>(
                      title: Text(
                        logic.feedBackSelectorList[index],
                        style: AppTextStyles.bodyMMedium(color: grey900),
                      ),
                      value: index,
                      contentPadding: EdgeInsets.zero,
                      groupValue: logic.feedBackSelectorIndex,
                      onChanged: logic.onFeedBackSelectionChanged,
                    ),
                  ),
                );
              },
            ),
            VerticalSpacer(16.h),
            if (logic.showFeedBackTextField) ...[
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
                  hintText: "Type here",
                  hintStyle: AppTextStyles.bodyMRegular(color: grey500),
                  isDense: true,
                  contentPadding: EdgeInsets.all(16.h),
                ),
                style: AppTextStyles.bodySRegular(color: grey500),
              ),
              VerticalSpacer(24.h)
            ],
          ],
        );
      },
    );
  }

  ListTileThemeData _listTileThemeData() {
    return const ListTileThemeData(
      visualDensity: VisualDensity(
        horizontal: 0,
        vertical: -3,
      ),
    );
  }

  RadioThemeData _radioButtonTheme() {
    return RadioThemeData(
      fillColor: MaterialStateProperty.all(const Color(0xff404040)),
      visualDensity: const VisualDensity(
        horizontal: VisualDensity.minimumDensity,
      ),
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
    );
  }
}

class FeedbackSuggestionMultiSelector extends StatelessWidget {
  var logic = Get.find<AppRatingLogic>();
  List<CheckboxListTile> checkBoxUI(int sectionIndex) {
    return logic.sections[sectionIndex].items.asMap().entries.map((entry) {
      final item = entry.value;
      return CheckboxListTile(
        contentPadding: EdgeInsets.zero,
        side: const BorderSide(color: darkBlueColor),
        controlAffinity: ListTileControlAffinity.leading,
        title: Text(
          item.name,
          style: AppTextStyles.bodyMMedium(color: grey900),
        ),
        value: item.isChecked,
        onChanged: (value) {
          logic.onReasonToggled(
            header: logic.sections[sectionIndex].header,
            reason: item,
            isSelected: value!,
          );
        },
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AppRatingLogic>(
        id: logic.feedBackSelectorKey,
        builder: (logic) {
          return ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: logic.sections.length,
            itemBuilder: (context, sectionIndex) {
              final section = logic.sections[sectionIndex];
              return Theme(
                data: Theme.of(context)
                    .copyWith(dividerColor: Colors.transparent),
                child: ExpansionTile(
                  tilePadding: EdgeInsets.zero,
                  title: Text(
                    section.header,
                    style: AppTextStyles.bodyMMedium(color: grey900),
                  ),
                  children: [...checkBoxUI(sectionIndex)],
                ),
              );
            },
          );
        });
  }
}
