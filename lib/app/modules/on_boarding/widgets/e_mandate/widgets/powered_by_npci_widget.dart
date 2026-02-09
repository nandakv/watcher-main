import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../../../res.dart';
import '../../../../../theme/app_colors.dart';

class PoweredByNPCIWidget extends StatelessWidget {
  const PoweredByNPCIWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            "Autopay is powered by",
            style: TextStyle(
                fontSize: 10,
                color: accountSummaryTitleColor,
                letterSpacing: 0.13),
          ),
          const SizedBox(
            width: 8,
          ),
          SvgPicture.asset(Res.npci)
        ],
      ),
    );
  }
}
