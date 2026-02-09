import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:privo/app/theme/app_colors.dart';

class InfoMessageWidget extends StatelessWidget {
  const InfoMessageWidget({
    Key? key,
    required this.infoMessage,
    required this.infoIcon,
    this.bgColor = darkBlueColorShade1,
    this.infoTextPadding = const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
    this.borderRadius = 0,
  }) : super(key: key);

  final String infoMessage;
  final String infoIcon;
  final EdgeInsets infoTextPadding;
  final Color bgColor;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: Padding(
        padding: infoTextPadding,
        child: Row(
          children: [
            SvgPicture.asset(infoIcon),
            const SizedBox(
              width: 15,
            ),
            Flexible(
              child: Text(
                infoMessage,
                textAlign: TextAlign.justify,
                style: const TextStyle(
                    color: infoTextColor,
                    fontSize: 10,
                    height: 1.4,
                    fontFamily: 'Figtree'),
              ),
            )
          ],
        ),
      ),
    );
  }
}
