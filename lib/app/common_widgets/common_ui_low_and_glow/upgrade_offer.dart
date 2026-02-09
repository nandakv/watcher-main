import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/svg.dart';

import '../../../res.dart';

class UpgradeOfferWidget extends StatelessWidget {
  const UpgradeOfferWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IntrinsicWidth(
      child: Container(
      //  alignment: Alignment.center,
        decoration: BoxDecoration(
            color: const Color(0xFFAF8E2F).withOpacity(1),
            borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              SvgPicture.asset(
                Res.starUpgrade,
                height: 15,
              ),
              const SizedBox(
                width: 3,
              ),
              Text(
                "UPGRADED",
                style: _titleTextStyle,
              ),
            ],
          ),
        ),
      ),
    );
  }

  TextStyle get _titleTextStyle {
    return const TextStyle(
        fontSize: 10,
        letterSpacing: 0.18,
        fontWeight: FontWeight.w500,
        color: Color(0xFFFFF3EB));
  }
}
