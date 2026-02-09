import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:privo/app/common_widgets/vertical_spacer.dart';
import 'package:privo/app/modules/transaction_history/model/date_filter_type_model.dart';
import 'package:privo/app/modules/transaction_history/transaction_history_logic.dart';
import 'package:privo/app/theme/app_colors.dart';
import 'package:privo/app/utils/app_text_styles.dart';
import 'package:privo/components/svg_icon.dart';
import 'package:privo/res.dart';

class BottomFilterSortButton extends StatelessWidget {
  final Function() onTap;
  final Function() onClearFilterTap;
  final String iconPath;
  final String title;
  final bool isHighlighted;
  final TransactionHistoryLogic logic;
  const BottomFilterSortButton(
      {Key? key,
      required this.onTap,
      required this.iconPath,
      required this.title,
      required this.isHighlighted,
      required this.onClearFilterTap,
      required this.logic})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return (logic.selectedDateFilterType != DateFilterTypeModel.none)
        ? Container(
            padding: const EdgeInsets.all(12.0),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: darkBlueColor)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: [
                InkWell(
                  onTap: onTap,
                  child: Row(
                    children: [
                      const SVGIcon(
                          size: SVGIconSize.small, icon: Res.filterNew),
                      horizontalSpacer(8.w),
                      Text(
                        computeText(),
                        style: AppTextStyles.bodySMedium(
                            color: secondaryDarkColor),
                      ),
                    ],
                  ),
                ),
                horizontalSpacer(8.w),
                const Text(
                  "|",
                  style: TextStyle(color: lightGrayColor),
                ),
                horizontalSpacer(8.w),
                InkWell(
                    onTap: onClearFilterTap,
                    child: const SVGIcon(
                        size: SVGIconSize.small, icon: Res.crossButton)),
              ],
            ),
          )
        : Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  logic.showTooltip
                      ? Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 10),
                              decoration: BoxDecoration(
                                color: primarySubtleColor,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                'Apply filters',
                                style: AppTextStyles.bodySRegular(
                                    color: navyBlueColor),
                              ),
                            ),
                            const TriangleTipPointner(width: 11, height: 12),
                            horizontalSpacer(6.w)
                          ],
                        )
                      : const SizedBox(),
                  InkWell(
                    onTap: onTap,
                    child: Container(
                      decoration: BoxDecoration(boxShadow: [
                        BoxShadow(
                          color: const Color(0xff000026).withValues(alpha: 0.1),
                          spreadRadius: 2,
                          blurRadius: 2,
                          offset:
                              const Offset(0, 0), // changes position of shadow
                        ),
                      ], color: Colors.white, shape: BoxShape.circle),
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: SvgPicture.asset(iconPath),
                      ),
                    ),
                  ),
                ],
              ),
              verticalSpacer(15.h)
            ],
          );
  }

  String computeText() {
    return logic.selectedDateFilterType != DateFilterTypeModel.none &&
            logic.sortByFilterState != SortBy.none
        ? "2"
        : "1";
  }
}

/// A widget that draws the tip (pointer/triangle) as in Tip.svg using CustomPainter
class TriangleTipPointner extends StatelessWidget {
  final double width;
  final double height;

  /// The color of the pointer. Default: Color(0xFFEFF9FD)
  final Color color;

  const TriangleTipPointner({
    Key? key,
    this.width = 8,
    this.height = 12,
    this.color = primarySubtleColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(width, height),
      painter: _TriangleTipPointerPainter(color: color),
    );
  }
}

class _TriangleTipPointerPainter extends CustomPainter {
  final Color color;

  _TriangleTipPointerPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color;
    final path = Path();

    // Based on SVG path: M6.93333 5.2C7.46667 5.6 7.46667 6.4 6.93333 6.8L-5.24537e-07 12L0 -3.49691e-07L6.93333 5.2Z
    path.moveTo(size.width * 0.8667, size.height * 0.4333); // M6.93333 5.2
    path.cubicTo(
      size.width * 0.9333, size.height * 0.4667, // C7.46667 5.6
      size.width * 0.9333, size.height * 0.5333, // 7.46667 6.4
      size.width * 0.8667, size.height * 0.5667, // 6.93333 6.8
    );
    path.lineTo(0, size.height); // L0 12
    path.lineTo(0, 0); // L0 0
    path.lineTo(size.width * 0.8667, size.height * 0.4333); // L6.93333 5.2
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _TriangleTipPointerPainter oldDelegate) =>
      color != oldDelegate.color;
}
