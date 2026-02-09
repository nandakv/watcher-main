import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:privo/app/common_widgets/gradient_button.dart';
import 'package:privo/app/common_widgets/onboarding_step_of_widget.dart';
import 'package:privo/app/common_widgets/spacer_widgets.dart';
import 'package:privo/app/modules/on_boarding/widgets/e_mandate/e_mandate_logic.dart';
import 'package:privo/app/modules/on_boarding/widgets/e_mandate/widgets/powered_by_npci_widget.dart';

import '../../../../../../res.dart';
import '../../../../../common_widgets/bank_details_column_widget.dart';
import '../../../../../theme/app_colors.dart';

class MandateDetailsWidget extends StatelessWidget {
  MandateDetailsWidget({Key? key}) : super(key: key);

  final logic = Get.find<EMandateLogic>();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: OnboardingStepOfWidget(
                      title: logic.title,
                    ),
                  ),
                  const VerticalSpacer(30),
                  Center(
                    child: SvgPicture.asset(
                      Res.eMandateSVG,
                    ),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  Text(
                    "Set up automatic EMI repayments to avoid late penalty fees",
                    style: _buildContentTextStyle,
                    textAlign: TextAlign.center,
                  ),
                  const VerticalSpacer(40),
                  const Text(
                    "Account used for Auto-Pay",
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
                                accountNumber: logic.accountNumber,
                                ifscCode: logic.ifscCode,
                              ),
                            ],
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            color: lightSkyBlueColorShade1,
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
                                    "Keep bank account and debit card/net banking details handy to set up autopay.",
                                    style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w500,
                                      color: navyBlueColor,
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
            ),
          ),
          const PoweredByNPCIWidget(),
          GetBuilder<EMandateLogic>(
            id: logic.BUTTON_KEY,
            builder: (logic) {
              return GradientButton(
                onPressed: logic.toggleToJusPayScreen,
                title: "Setup Auto-Pay",
                isLoading: logic.isButtonLoading,
              );
            },
          ),
          const SizedBox(
            height: 32,
          ),
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

  TextStyle get _buildContentTextStyle {
    return const TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w500,
      color: darkBlueColor,
    );
  }
}

class _BankDetailsRowWidget extends StatelessWidget {
  const _BankDetailsRowWidget({
    Key? key,
    required this.leading,
    required this.title,
    required this.value,
  }) : super(key: key);

  final String leading;
  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SvgPicture.asset(
          leading,
          height: 20,
          width: 20,
        ),
        const SizedBox(
          width: 10,
        ),
        Text(
          title,
          style: _accountDetailsTextStyle,
        ),
        const SizedBox(
          width: 10,
        ),
        Text(
          value,
          style: const TextStyle(
              fontSize: 16,
              letterSpacing: 0.15,
              fontWeight: FontWeight.normal,
              color: activeButtonColor),
        ),
      ],
    );
  }

  TextStyle get _accountDetailsTextStyle {
    return const TextStyle(
        fontSize: 12,
        letterSpacing: 0.11,
        fontWeight: FontWeight.normal,
        color: Color(0xFF616B7C));
  }
}
