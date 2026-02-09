import 'package:google_fonts/google_fonts.dart';
import 'package:privo/app/common_widgets/blue_button.dart';
import 'package:privo/app/common_widgets/gradient_button.dart';
import 'package:privo/app/modules/on_boarding/user_state_maps.dart';
import 'package:privo/app/modules/on_boarding/widgets/verify_bank_statement/verify_bank_statement_logic.dart';
import 'package:privo/app/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../firebase/analytics.dart';
import '../modules/on_boarding/mixins/app_form_mixin.dart';
import '../modules/on_boarding/on_boarding_logic.dart';
import '../utils/web_engage_constant.dart';

class RetryPageWidget extends StatelessWidget {
  RetryPageWidget({
    Key? key,
    required this.title,
    required this.assetImage,
    required this.userState,
    this.isSVG = true,
  }) : super(key: key);

  final String title;
  final String assetImage;
  final bool? isSVG;
  final UserState userState;

  final logic = Get.find<OnBoardingLogic>();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(
            height: 30,
          ),
          const Text(
            "Uh-oh!",
            textAlign: TextAlign.center,
            style: TextStyle(
                fontWeight: FontWeight.w600,
                color: redTextColor,
                fontSize: 24,
                letterSpacing: 0.18),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                  color: redTextColor, fontSize: 16, letterSpacing: 0.12),
            ),
          ),
          const SizedBox(
            height: 30,
          ),
          if (isSVG!)
            Expanded(
              child: SvgPicture.asset(
                assetImage,
              ),
            ),
          if (!isSVG!)
            Expanded(
              child: Image.asset(
                assetImage,
              ),
            ),
          const SizedBox(
            height: 30,
          ),
          const Text(
            "Cheer up and try again",
            style: TextStyle(
                fontSize: 16, letterSpacing: 0.12, color: Color(0xff344157)),
          ),
          const SizedBox(
            height: 20,
          ),
          GradientButton(
              onPressed: () {
                ///Add a switch case
                switch (userState) {
                  case UserState.eMandateFailure:
                    AppAnalytics.trackWebEngageEventWithAttribute(
                        eventName:
                            WebEngageConstants.eMandateFailureCTAContinue);
                    logic.currentUserState = UserState.eMandateDetails;
                    break;
                  case UserState.eSignFailure:
                    logic.currentUserState = UserState.eSignDetails;
                    break;
                  case UserState.bankVerifyFailed:
                    logic.currentUserState = UserState.verifyBankDetails;
                    break;
                  default:
                    Get.back();
                }

                // ///
                // if (userState == UserState.eMandateFailure) {
                //   logic.currentUserState = UserState.eMandateDetails;
                // } else if (userState == UserState.eSignFailure) {
                //   logic.currentUserState = UserState.eSignDetails;
                // }  else if (userState == UserState.bankVerifyFailed) {
                //   logic.currentUserState = logic.previousUserState;
                // } else {
                //   Get.back();
                // }
              },
              title: "Retry"),
          const SizedBox(
            height: 30,
          )
        ],
      ),
    );
  }
}
