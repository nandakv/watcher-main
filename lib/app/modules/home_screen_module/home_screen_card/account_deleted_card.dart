import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:privo/app/common_widgets/spacer_widgets.dart';
import 'package:privo/app/theme/app_colors.dart';
import 'package:privo/res.dart';

class AccountDeletedCard extends StatelessWidget {
  String title;
  String message;

  AccountDeletedCard({super.key, required this.title, required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: lightSkyBlueColorShade1,
      ),
      child: Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 16,bottom: 16,left: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      color: navyBlueColor,
                      fontSize: 12,
                    ),
                  ),
                  const VerticalSpacer(8),
                  Text(
                    message,
                    style: const TextStyle(
                      fontWeight: FontWeight.w400,
                      color: primaryDarkColor,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ),
          _bgImage(),
        ],
      ),
    );
  }

  Widget _bgImage() {
    return Align(
      alignment: Alignment.bottomRight,
      child: SvgPicture.asset(
        Res.offerExpiryAlert,
        fit: BoxFit.scaleDown,
      ),
    );
  }
}
