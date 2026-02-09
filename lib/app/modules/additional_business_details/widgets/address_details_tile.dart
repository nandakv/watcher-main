import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:privo/app/common_widgets/nudge_badge_widget.dart';
import 'package:privo/app/common_widgets/spacer_widgets.dart';
import 'package:privo/app/theme/app_colors.dart';
import 'package:privo/res.dart';

class AddressDetailsTile extends StatelessWidget {
  final String title;
  final String subTitle;
  final Function() onTap;
  final bool isPending;

  const AddressDetailsTile({
    Key? key,
    required this.title,
    required this.subTitle,
    required this.onTap,
    this.isPending = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return NudgeBadgeWidget(
      nudgeText: isPending ? "Pending" : null,
      bgColor: red,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.only(top: isPending ? 6.0 : 0),
          child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: darkBlueColor, width: 1),
              ),
              child: _body()),
        ),
      ),
    );
  }

  Widget _body() {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _titleWidget(),
              const VerticalSpacer(4),
              _subTitleWidget(),
            ],
          ),
        ),
        SvgPicture.asset(Res.rightCircleArrowIconSVG)
      ],
    );
  }

  Widget _titleWidget() {
    return Text(
      title,
      style: const TextStyle(
        color: darkBlueColor,
        fontSize: 12,
      ),
    );
  }

  Widget _subTitleWidget() {
    return Text(
      subTitle,
      style: const TextStyle(
        color: primaryDarkColor,
        fontSize: 12,
        fontWeight: FontWeight.w500,
      ),
    );
  }
}
