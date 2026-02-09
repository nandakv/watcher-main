import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:privo/app/common_widgets/vertical_spacer.dart';
import 'package:privo/app/theme/app_colors.dart';

import '../../../res.dart';

class RaiseAnIssueCard extends StatelessWidget {
  final Function() onTap;
  const RaiseAnIssueCard({Key? key, required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: InkWell(
        onTap: onTap,
        child: Container(
          decoration: _containerDecoration(),
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              _iconWidget(),
              horizontalSpacer(16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _titleWidget(),
                    verticalSpacer(4),
                    _subTitleWidget(),
                  ],
                ),
              ),
              _ctaIcon(),
            ],
          ),
        ),
      ),
    );
  }

  Decoration _containerDecoration() {
    return BoxDecoration(
      borderRadius: BorderRadius.circular(16),
      color: darkBlueColor,
    );
  }

  Widget _iconWidget() {
    return CircleAvatar(
      backgroundColor: offWhiteColor,
      child: SvgPicture.asset(Res.raiseIssue),
    );
  }

  _ctaIcon() {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.zero,
          width: 7,
          child: Icon(
            Icons.chevron_right_rounded,
            color: offWhiteColor.withOpacity(0.6),
          ),
        ),
        const Icon(
          Icons.chevron_right_rounded,
          color: offWhiteColor,
        ),
      ],
    );
  }

  Text _titleWidget() {
    return const Text(
      "Raise an issue",
      style: TextStyle(
        fontWeight: FontWeight.w600,
        color: offWhiteColor,
        fontSize: 14,
      ),
    );
  }

  Widget _subTitleWidget() {
    return const Text(
      "Our support team will help with your query",
      style: TextStyle(
        color: offWhiteColor,
        fontSize: 10,
      ),
    );
  }
}
