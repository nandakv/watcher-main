import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../res.dart';
import '../theme/app_colors.dart';

class SafeAndEncryptedInfoWidget extends StatelessWidget {
  const SafeAndEncryptedInfoWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SvgPicture.asset(Res.secure),
        const SizedBox(
          width: 10,
        ),
        const Flexible(
          child: Text(
            "Your data is 100% safe and encrypted",
            style: TextStyle(
                fontSize: 10, letterSpacing: 0.16, color: darkBlueColor,   fontWeight: FontWeight.w600,),
          ),
        )
      ],
    );
  }
}
