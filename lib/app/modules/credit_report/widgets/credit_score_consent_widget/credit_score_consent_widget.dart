import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:privo/app/models/rich_text_model.dart';
import 'package:privo/app/modules/on_boarding/widgets/consent_widget.dart';
import 'package:privo/app/theme/app_colors.dart';
import 'package:privo/app/utils/app_text_styles.dart';
import 'package:privo/flavors.dart';
import 'package:url_launcher/url_launcher_string.dart';


import 'credit_score_consent_logic.dart';

class CreditScoreConsentWidget extends StatelessWidget {
  final Function(bool) onConsentChanged;
  final Color? textColor;

  const CreditScoreConsentWidget({
    super.key,
    this.textColor,
    required this.onConsentChanged,
  });

  @override
  Widget build(BuildContext context) {
    final logic = Get.lazyPut(() => CreditScoreConsentLogic(
      onConsentChanged: onConsentChanged,
    ));

    return GetBuilder<CreditScoreConsentLogic>(
      builder: (logic) {
        return logic.isConsentRequired
            ? ConsentWidget(
          horizontalPadding: 0,
          checkBoxColor: AppIconColors.primaryFocus,
          consentTextList: [
            RichTextModel(
              text:
              "I allow Kisetsu Saison Finance (India) Private Limited (KSF) to access my Experian D2C report to provide personalised financial insights. I also agree to Experian's ",
              textStyle: AppTextStyles.bodyXSRegular(
                  color: textColor ?? AppTextColors.primaryNavyBlueHeader),
            ),
            RichTextModel(
                text: "T&C",
                onTap: () {
                  launchUrlString(
                    F.envVariables.experianTnCUrl,
                    mode: LaunchMode.inAppWebView,
                  );
                },
                textStyle: AppTextStyles.bodyXSRegular(
                    color: AppTextColors.link))
          ],
          value: logic.isConsentChecked,
          onChanged: logic.onConsentValueChanged,
          color: darkBlueColor,
        )
            : const SizedBox();
      },
    );
  }
}