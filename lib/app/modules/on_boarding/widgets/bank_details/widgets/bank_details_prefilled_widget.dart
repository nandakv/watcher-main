import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:privo/app/common_widgets/bank_details_column_widget.dart';
import 'package:privo/app/common_widgets/onboarding_step_of_widget.dart';
import 'package:privo/app/common_widgets/spacer_widgets.dart';
import 'package:privo/app/modules/on_boarding/widgets/privo_app_bar/privo_app_bar.dart';
import 'package:privo/app/theme/app_colors.dart';

import '../../../../../../res.dart';
import '../bank_details_logic.dart';

class BankDetailsPrefilledWidget extends StatelessWidget {
  BankDetailsPrefilledWidget({Key? key}) : super(key: key);

  final logic = Get.find<BankDetailsLogic>();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Align(
            alignment: Alignment.centerLeft,
            child: OnboardingStepOfWidget(
              title: "Bank Verification",
            ),
          ),
          const VerticalSpacer(30),
          SvgPicture.asset(
            Res.piggyBankVerificationSVG,
            height: 171,
          ),
          const VerticalSpacer(12),
          Text(
           logic.computeMessage(),
            style:const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: darkBlueColor,
            ),
            textAlign: TextAlign.center,
          ),
          const VerticalSpacer(40),
          const Text(
            "Account used for verification",
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 12,
              color: navyBlueColor,
            ),
          ),
          const VerticalSpacer(8),
          Container(
            decoration: _containerDecoration(),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      BankDetailsColumnWidget(
                        bankName: logic.bankName,
                        accountNumber: logic.accountNumberController.text,
                        ifscCode: logic.ifscNameController.text,
                      ),
                    ],
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: lightSkyBlueColor,
                    borderRadius: const BorderRadius.only(
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
                          Res.coinImg,
                          height: 32,
                          width: 32,
                        ),
                        const SizedBox(
                          width: 4,
                        ),
                        const Expanded(
                          child: Text(
                            "For verification, ₹1 will be deposited into your account to check the account's activeness",
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
          ),
          const VerticalSpacer(40),
        ],
      ),
    );
  }

  BoxDecoration _containerDecoration() {
    return BoxDecoration(
      border: Border.all(
        color: preRegistrationEnabledGradientColor3,
        width: 0.6,
      ),
      borderRadius: BorderRadius.circular(8),

    );
  }
}
