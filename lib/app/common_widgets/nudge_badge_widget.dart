import 'package:flutter/material.dart';
import 'package:privo/components/badges/cs_badge.dart';

import '../theme/app_colors.dart';

class NudgeBadgeWidget extends StatelessWidget {
  final String? nudgeText;
  final Widget child;
  final Color bgColor;
  final Offset offset;

  CSBadge? csBadge;

  NudgeBadgeWidget({
    Key? key,
    this.nudgeText,
    this.csBadge,
    this.offset = const Offset(0, 0),
    required this.child,
    this.bgColor = const Color(0xffEE3D4B),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if(csBadge != null){
      return nudgeWithChild;
    }
    if (nudgeText == null) {
      return child;
    }
    return nudgeWithChild;
  }

  Widget get nudgeWithChild {
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 6.0),
          child: child,
        ),
       csBadge != null ? Transform.translate(offset: offset,child: csBadge,) : _nudgeBadge(),
      ],
    );
  }

  _nudgeBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        nudgeText!,
        style: const TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 10,
          color: offWhiteColor,
        ),
      ),
    );
  }
}
