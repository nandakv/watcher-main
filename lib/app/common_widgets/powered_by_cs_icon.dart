import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../res.dart';
import '../theme/app_colors.dart';

class PoweredByCSIcon extends StatelessWidget {
  const PoweredByCSIcon({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SvgPicture.asset(
        Res.poweredByCS,
        height: 20,
        colorFilter: const ColorFilter.mode(
          navyBlueColor,
          BlendMode.srcIn,
        ),
      ),
    );
  }
}
