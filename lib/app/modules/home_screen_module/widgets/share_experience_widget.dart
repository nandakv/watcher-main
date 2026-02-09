import 'package:flutter/material.dart';
import 'package:privo/app/utils/app_text_styles.dart';

import '../../../theme/app_colors.dart';

class ShareExperienceWidget extends StatelessWidget {
  final Function() onTap;
  const ShareExperienceWidget({Key? key, required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: InkWell(
        onTap: onTap,
        child: Container(
          decoration: const BoxDecoration(
            color: Color(0xffdef3fc),
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(8),
              bottomRight: Radius.circular(8),
            ),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Share your experience here",
                style: AppTextStyles.bodyXSRegular(color: blue1600),
              ),
              const Icon(
                Icons.chevron_right,
                size: 20,
                color: navyBlueColor,
              )
            ],
          ),
        ),
      ),
    );
  }
}
