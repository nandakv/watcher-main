import 'package:after_layout/after_layout.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:privo/app/common_widgets/gradient_button.dart';
import 'package:privo/app/common_widgets/home_screen_loading_widget.dart';
import 'package:privo/app/common_widgets/onboarding_timeline_widget/onboarding_timeline_widget.dart';
import 'package:privo/app/modules/home_screen_module/widgets/home_page_top_widget.dart';
import 'package:privo/app/modules/on_boarding/user_state_maps.dart';
import 'package:privo/app/modules/on_boarding/widgets/credit_line_approved/credit_line_approved_logic.dart';
import 'package:privo/app/modules/on_boarding/widgets/credit_line_approved/setup_credit_line_top_widget.dart';
import 'package:privo/app/theme/app_colors.dart';

import '../../../../../res.dart';
import '../../../../common_widgets/app_stepper.dart';
import '../../../../firebase/analytics.dart';
import '../../../../utils/web_engage_constant.dart';

class CreditLineApproved extends StatefulWidget {
  const CreditLineApproved({Key? key}) : super(key: key);

  @override
  State<CreditLineApproved> createState() => _CreditLineApprovedState();
}

class _CreditLineApprovedState extends State<CreditLineApproved>
    with AfterLayoutMixin {
  final logic = Get.find<CreditLineApprovedLogic>();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CreditLineApprovedLogic>(
      builder: (logic) {
        return logic.isPageLoading
            ? const HomeScreenLoadingWidget()
            : _bodyWidget(logic);
      },
    );
  }

  Widget _bodyWidget(CreditLineApprovedLogic logic) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _creditLineInfo(logic),
        GetBuilder<CreditLineApprovedLogic>(
          id: logic.CONTINUE_BUTTON,
          builder: (logic) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: GradientButton(
                onPressed: logic.onContinuePressed,
                isLoading: logic.isButtonLoading,
                title: "Link Bank Account",
                bottomPadding: 20,
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _creditLineInfo(CreditLineApprovedLogic logic) {
    return Expanded(
      child: SingleChildScrollView(
        child: Column(
          children: [
            HomeScreenTopWidget(
              showHamburger: false,
              infoText: "Keep Bank details handy for smooth and quick withdrawal",
              background: Res.sparkleSVG,
              infoPadding: const EdgeInsets.symmetric(horizontal: 32,vertical: 12),
              widget: SetupCreditLineWidget(logic: logic),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 40),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "All you have to do to withdraw",
                    style: TextStyle(
                      color: navyBlueColor,
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  AppStepper(
                    currentStep: 2,
                    appSteps: [
                      AppStep(
                        child: const Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Get Final Offer",
                              style: TextStyle(
                                color: greenColor,
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              "Provide your basic information",
                              style: TextStyle(
                                color: secondaryDarkColor,
                                fontSize: 10,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                          ],
                        ),
                      ),
                      AppStep(
                        child: const Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "KYC",
                              style: TextStyle(
                                color: greenColor,
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              "Authenticate your identity using Aadhaar and a selfie",
                              style: TextStyle(
                                color: secondaryDarkColor,
                                fontSize: 10,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                          ],
                        ),
                      ),
                      AppStep(
                        child: const Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Withdraw",
                              style: TextStyle(
                                color: goldColor,
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              "Verify your bank and withdraw",
                              style: TextStyle(
                                color: secondaryDarkColor,
                                fontSize: 10,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                          ],
                        ),
                      ),
                    ],
                    isCurrentStepBordered: true,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  TextStyle _titleTextStyle() {
    return const TextStyle(
      fontSize: 12,
      letterSpacing: 0.19,
      color: Color(0xff888686),
      fontWeight: FontWeight.w500,
    );
  }

  @override
  void afterFirstLayout(BuildContext context) {
    logic.checkFinalOffer();
    AppAnalytics.trackWebEngageEventWithAttribute(
        eventName: WebEngageConstants.lineActivationScreenLoaded);
    AppAnalytics.trackWebEngageUser(
        userAttributeName: "CreditLineStatus", userAttributeValue: "Activated");
  }
}
