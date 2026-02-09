import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:privo/app/common_widgets/spacer_widgets.dart';
import 'package:privo/app/modules/credit_report/widgets/credit_account_base_container.dart';
import 'package:privo/app/theme/app_colors.dart';
import 'package:privo/res.dart';

class CreditReportTile extends StatelessWidget {
  final String title;
  final String subTitle;
  final String iconPath;
  final Color subTitleColor;
  final Function()? onTap;
  final Widget? rightInfoWidget;
  final Decoration? decoration;
  final EdgeInsetsGeometry padding;
  final double iconPadding;

  const CreditReportTile({
    Key? key,
    required this.title,
    required this.subTitle,
    this.iconPath = Res.creditScoreBankSVG,
    this.onTap,
    this.rightInfoWidget,
    this.subTitleColor = secondaryDarkColor,
    this.decoration,
    this.iconPadding = 7,
    this.padding = const EdgeInsets.all(16),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CreditAccountBaseContainer(
      decoration: decoration,
      padding: padding,
      child: InkWell(
        onTap: onTap,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            _logoWidget(),
            const HorizontalSpacer(18),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: _titleTextStyle(),
                  ),
                  _subTitle(subTitle),
                ],
              ),
            ),
            const SizedBox(
              width: 8,
            ),
            rightInfoWidget == null
                ? SvgPicture.asset(Res.creditReportArrow)
                : rightInfoWidget!,
          ],
        ),
      ),
    );
  }

  Widget _logoWidget() {
    return Container(
      width: 30,
      height: 30,
      padding: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        color: const Color(0xFFE8F6FD),
        borderRadius: BorderRadius.circular(25),
      ),
      child: Container(
        padding: EdgeInsets.all(iconPadding),
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(25),
          border: Border.all(color: goldColor, width: 0.4),
        ),
        child: SvgPicture.asset(iconPath),
      ),
    );
  }

  Text _subTitle(String subTitle) {
    return Text(
      subTitle,
      maxLines: 2,
      style: _subTitleTextStyle(),
    );
  }

  TextStyle _subTitleTextStyle() {
    return TextStyle(
      color: subTitleColor,
      fontSize: 10,
      fontWeight: FontWeight.w500,
      height: 1.4,
    );
  }

  TextStyle _titleTextStyle() {
    return const TextStyle(
      color: navyBlueColor,
      fontSize: 12,
      fontWeight: FontWeight.w600,
      height: 16 / 12,
    );
  }
}
