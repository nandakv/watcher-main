import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:privo/app/theme/app_colors.dart';

class PoweredByWidget extends StatelessWidget {
  final String logo;
  const PoweredByWidget({super.key, required this.logo});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text(
          "Powered by",
          style: TextStyle(fontSize: 12, color: secondaryDarkColor),
        ),
        const SizedBox(
          width: 8,
        ),
        SvgPicture.asset(
          logo,
          height: 18,
        ),
      ],
    );
  }
}
