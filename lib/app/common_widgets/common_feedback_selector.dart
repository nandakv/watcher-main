import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:privo/app/theme/app_colors.dart';
import 'package:privo/app/utils/app_text_styles.dart';
import 'package:privo/app/common_widgets/spacer_widgets.dart';

class CommonFeedbackSelector extends StatelessWidget {
  final List<String> feedbackOptions;
  final int selectedOptionIndex;
  final ValueChanged<int?> onOptionSelected;
  final bool showTextField;
  final TextEditingController? textEditingController;
  final ValueChanged<String>? onTextChanged;

  const CommonFeedbackSelector({
    super.key,
    required this.feedbackOptions,
    required this.selectedOptionIndex,
    required this.onOptionSelected,
    this.showTextField = false,
    this.textEditingController,
    this.onTextChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ...List.generate(
          feedbackOptions.length,
              (index) {
            return RadioTheme(
              data: _radioButtonTheme(),
              child: ListTileTheme(
                data: _listTileThemeData(),
                child: RadioListTile<int>(
                  title: Text(
                    feedbackOptions[index],
                    style: AppTextStyles.bodyMMedium(color: grey900),
                  ),
                  value: index,
                  contentPadding: EdgeInsets.zero,
                  groupValue: selectedOptionIndex,
                  onChanged: onOptionSelected,
                ),
              ),
            );
          },
        ),
        VerticalSpacer(16.h),
        if (showTextField) ...[
          TextFormField(
            maxLines: 3,
            maxLength: 100,
            controller: textEditingController,
            onChanged: onTextChanged,
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
  }

  ListTileThemeData _listTileThemeData() {
    return const ListTileThemeData(
      visualDensity: VisualDensity(
        horizontal: -1,
        vertical: -3,
      ),
    );
  }

  RadioThemeData _radioButtonTheme() {
    return RadioThemeData(
      fillColor: MaterialStateProperty.all(blue1200),
      visualDensity: const VisualDensity(
        horizontal: VisualDensity.minimumDensity,
      ),
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
    );
  }
}