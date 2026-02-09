import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:privo/app/common_widgets/spacer_widgets.dart';
import 'package:privo/app/theme/app_colors.dart';
import 'package:privo/app/utils/app_text_styles.dart';

class WithdrawalLimitDetailsWidget extends StatelessWidget {
  const WithdrawalLimitDetailsWidget(
      {Key? key, required this.withdrawalLimitType})
      : super(key: key);

  final WithdrawalLimitType withdrawalLimitType;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          withdrawalLimitType.title,
          style: _titleTextStyle(),
        ),
        VerticalSpacer(4.sp),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SvgPicture.asset(
              withdrawalLimitType.icon,
              width: 16.sp,
              height: 16.sp,
            ),
            SizedBox(
              width: 4.sp,
            ),
            if (withdrawalLimitType.valueWidget != null)
              withdrawalLimitType.valueWidget!
            else
              Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: withdrawalLimitType.value,
                      style: _valueTextStyle(),
                    ),
                    TextSpan(
                      text: withdrawalLimitType.secondaryValue,
                      style: _secondaryValueTextStyle(),
                    )
                  ],
                ),
              ),
          ],
        )
      ],
    );
  }

  TextStyle _valueTextStyle() {
    return TextStyle(
        color: withdrawalLimitType.valueColor,
        fontSize: 14.sp,
        fontWeight: FontWeight.w500);
  }

  TextStyle _secondaryValueTextStyle() {
    return TextStyle(
        color: withdrawalLimitType.valueColor,
        fontSize: 8.sp,
        fontWeight: FontWeight.w600);
  }

  TextStyle _titleTextStyle() {
    return AppTextStyles.bodyXSRegular(
      color: withdrawalLimitType.titleColor,
    );
  }
}

class WithdrawalLimitType {
  String title;
  String value;
  String secondaryValue;
  String icon;
  Color valueColor;
  Color titleColor;
  Widget? valueWidget;

  WithdrawalLimitType(
      {required this.title,
      required this.value,
      required this.icon,
      this.valueWidget,
      this.secondaryValue = "",
      this.titleColor = offWhiteColor,
      required this.valueColor});
}
