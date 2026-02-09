import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../res.dart';
import '../../../theme/app_colors.dart';

class FAQCategoryTile extends StatelessWidget {
  final Function() onTap;
  final String title;
  final String subTitle;
  const FAQCategoryTile({
    Key? key,
    required this.onTap,
    required this.title,
    required this.subTitle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: InkWell(
        onTap: onTap,
        child: Row(
          children: [
            CircleAvatar(
                backgroundColor: darkBlueColor,
                child: SvgPicture.asset(Res.faq)),
            const SizedBox(
              width: 12,
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      color: primaryDarkColor,
                      fontSize: 14,
                    ),
                  ),
                  Text(
                    subTitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 10,
                      color: secondaryDarkColor,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
