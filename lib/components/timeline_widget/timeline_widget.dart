import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:privo/app/common_widgets/spacer_widgets.dart';
import 'package:privo/app/theme/app_colors.dart';
import 'package:privo/app/utils/app_text_styles.dart';
import 'package:privo/components/svg_icon.dart';
import 'package:privo/components/timeline_widget/timeline_model.dart';

import '../../res.dart';

class TimelineWidget extends StatelessWidget {
  final List<TimelineModel> steps;

  const TimelineWidget({
    super.key,
    required this.steps,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      separatorBuilder: (context, index) {
        return Row(
          children: [
            HorizontalSpacer(12.w),
            Container(
              height: 20.h,
              width: 1.w,
              color: AppBorderColors.brandBlue,
              margin: EdgeInsets.only(
                bottom: 8.h,
              ),
            ),
            const Spacer(),
          ],
        );
      },
      itemCount: steps.length,
      itemBuilder: (context, index) {
        final step = steps[index];
        final bool isLastStep = index == steps.length - 1;
        return _StepItem(
          step: step,
          isLastStep: isLastStep,
        );
      },
    );
  }
}

/// An internal widget to render a single step in the list.
class _StepItem extends StatelessWidget {
  final TimelineModel step;
  final bool isLastStep;

  const _StepItem({
    required this.step,
    required this.isLastStep,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SvgPicture.asset(
          step.icon,
          width: 24.w,
        ),
        HorizontalSpacer(12.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    step.title,
                    style: AppTextStyles.headingXSSemiBold(
                      color: AppTextColors.brandBlueTitle,
                    ),
                  ),
                  if (step.onInfoTapped != null) ...[
                    HorizontalSpacer(4.w),
                    InkWell(
                      onTap: () => step.onInfoTapped!(),
                      child: const SVGIcon(
                        size: SVGIconSize.small,
                        icon: Res.informationFilledIcon,
                      ),
                    ),
                  ]
                ],
              ),
              VerticalSpacer(4.h),
              Text(
                step.subtitle,
                style: AppTextStyles.bodySRegular(
                  color: AppTextColors.neutralBody,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
