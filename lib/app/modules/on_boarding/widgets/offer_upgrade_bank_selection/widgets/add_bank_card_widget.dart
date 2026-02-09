import 'dart:async';

import 'package:after_layout/after_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:privo/app/common_widgets/gradient_border_container.dart';
import 'package:privo/res.dart';

import '../../../../../common_widgets/gradient_button.dart';
import '../../../../../theme/app_colors.dart';

enum AddBankCardType {
  primary(
    title: "Add Primary Bank",
    titleInfo: "  (Mandatory)",
    subTitle: "You need to provide a bank statement in the next step",
    ctaEnabled: true,
    titleInfoColor: red,
    enableAdditionalText: false,
  ),
  recommendedDisabled(
    title: "Add Secondary Bank",
    titleInfo: "  (Recommended)",
    subTitle:
        "By adding more bank details, you stand a higher chance of getting a better offer",
    ctaEnabled: false,
    titleInfoColor: darkBlueColor,
    enableAdditionalText: true,
  ),
  recommendedEnabled(
    title: "Add Secondary Bank",
    titleInfo: "  (Recommended)",
    subTitle:
        "By adding more bank details, you stand a higher chance of getting a better offer",
    ctaEnabled: true,
    titleInfoColor: darkBlueColor,
    enableAdditionalText: true,
  );

  final String title;
  final String titleInfo;
  final String subTitle;
  final bool ctaEnabled;
  final Color titleInfoColor;
  final bool enableAdditionalText;

  const AddBankCardType({
    required this.title,
    required this.titleInfo,
    required this.subTitle,
    required this.ctaEnabled,
    required this.titleInfoColor,
    required this.enableAdditionalText,
  });
}

class AddBankCardWidget extends StatelessWidget {
  const AddBankCardWidget({
    Key? key,
    required this.addBankCardType,
    required this.onTap,
    this.isCLP = false,
  }) : super(key: key);

  final AddBankCardType addBankCardType;
  final Function() onTap;
  final bool isCLP;

  @override
  Widget build(BuildContext context) {
    return GradientBorderContainer(
      borderRadius: 8,
      width: double.infinity,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(
              left: 16,
              right: 16,
              top: 16,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text.rich(
                  TextSpan(
                    text: addBankCardType.title,
                    children: [
                      if (!isCLP)
                        TextSpan(
                          text: addBankCardType.titleInfo,
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w400,
                            color: addBankCardType.titleInfoColor,
                          ),
                        ),
                    ],
                  ),
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                    color: navyBlueColor,
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                Text(
                  addBankCardType.subTitle,
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 10,
                    color: secondaryDarkColor,
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                if (addBankCardType.enableAdditionalText) ...[
                  _additionalText("10% higher loan amount"),
                  const SizedBox(
                    height: 8,
                  ),
                  _additionalText("Upto 5% lower interest rate"),
                  const SizedBox(
                    height: 15,
                  ),
                ],
                GradientButton(
                  fillWidth: false,
                  enabled: addBankCardType.ctaEnabled,
                  onPressed: onTap,
                  title: "Add",
                  edgeInsets: const EdgeInsets.symmetric(
                    vertical: 9,
                    horizontal: 50,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
              ],
            ),
          ),
          if (addBankCardType.enableAdditionalText)
            Container(
              decoration: const BoxDecoration(
                color: lightBlueColor,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(8),
                  bottomRight: Radius.circular(8),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 8,
                ),
                child: Row(
                  children: [
                    SvgPicture.asset(
                      Res.coinSVG,
                      height: 32,
                      width: 32,
                    ),
                    const SizedBox(
                      width: 4,
                    ),
                    const Expanded(
                      child: Text(
                        "10K+ people got additional loan amount after syncing and adding more bank accounts",
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                          color: darkBlueColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  _additionalText(String title) {
    return Text.rich(
      TextSpan(
        children: [
          WidgetSpan(
            child: SvgPicture.asset(
              Res.checkCircleBlueSVG,
              width: 20,
              height: 20,
            ),
            alignment: PlaceholderAlignment.middle,
          ),
          TextSpan(text: "   $title"),
        ],
      ),
      style: const TextStyle(
        fontSize: 10,
        fontWeight: FontWeight.w500,
        color: darkBlueColor,
          fontFamily: 'Figtree'),
    );
  }
}
