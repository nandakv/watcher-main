import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../res.dart';

class HomePageRightArrowWidget extends StatelessWidget {
  final Color? color;
  final Function()? onTap;
  const HomePageRightArrowWidget({Key? key, this.onTap, this.color})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: SvgPicture.asset(
        Res.arrow_dark,
        colorFilter:
            color == null ? null : ColorFilter.mode(color!, BlendMode.srcIn),
      ),
    );
  }
}
