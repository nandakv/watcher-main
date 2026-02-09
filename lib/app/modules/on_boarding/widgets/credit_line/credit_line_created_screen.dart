import 'package:after_layout/after_layout.dart';
import 'package:privo/app/common_widgets/blue_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:privo/app/common_widgets/retry_page.dart';
import 'package:privo/app/modules/on_boarding/user_state_maps.dart';
import 'package:privo/app/modules/on_boarding/widgets/credit_line/credit_line_logic.dart';
import 'package:privo/app/utils/app_functions.dart';

import '../../../../../res.dart';
import '../../on_boarding_logic.dart';

class CreditLineCreatedScreen extends StatefulWidget {

  const CreditLineCreatedScreen({Key? key}) : super(key: key);

  @override
  State<CreditLineCreatedScreen> createState() =>
      _CreditLineCreatedScreenState();
}

class _CreditLineCreatedScreenState extends State<CreditLineCreatedScreen>
    with AfterLayoutMixin {
  final logic = Get.find<CreditLineLogic>();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CreditLineLogic>(
        builder: (logic) {
          if (logic.getOnBoardingState == OnBoardingState.success) {
            return Padding(
              padding: const EdgeInsets.only(top: 107),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Hey there!",
                    style: _buildTitleTextStyle,
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 13, right: 13, top: 23),
                    child: Text(
                      "Your credit line has been created!",
                      textAlign: TextAlign.center,
                      style: buildSubTitleTextStyle(),
                    ),
                  ),
                  const SizedBox(
                    height: 69,
                  ),
                  Expanded(
                    child: SvgPicture.asset(
                      Res.credit_line_created,
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 13, right: 13, top: 61),
                    child: Text(
                      "Your Available Limit is ₹ ${AppFunctions().parseIntoCommaFormat(logic.creditLineLimitDetailsModel!.approvedLimit!.toInt().toString())}",
                      textAlign: TextAlign.center,
                      style: _buildAvailableLimitTextStyle,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 13, vertical: 10),
                    child: Text(
                      "Go ahead and start withdrawing!",
                      textAlign: TextAlign.center,
                      style: buildBottomTextStyle(),
                    ),
                  ),
                  // Text(
                  //   "${logic.appForm} only for testing.(will not be in prod)",
                  // ),
                  const SizedBox(
                    height: 38,
                  ),
                  GetBuilder<CreditLineLogic>(
                      builder: (logic) {
                        return Center(
                            child: BlueButton(
                          onPressed: () =>
                              logic.onCreditLineCreatedContinueTapped(),
                          buttonColor: const Color(0xFF004097),
                          title: "Transfer",
                          isLoading: logic.getOnBoardingState ==
                                  OnBoardingState.loading
                              ? true
                              : false,
                        ));
                      }),
                  const SizedBox(
                    height: 50,
                  ),
                ],
              ),
            );
          } else {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [Center(child: CircularProgressIndicator())],
            );
          }
        });
  }

  TextStyle get _buildAvailableLimitTextStyle {
    return const TextStyle(
        color: Color(0xFF73767C),
        fontSize: 14,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.12);
  }

  TextStyle buildBottomTextStyle() {
    return const TextStyle(
        color: Color(0xFF344157),
        fontSize: 16,
        fontWeight: FontWeight.normal,
        letterSpacing: 0);
  }

  TextStyle buildSubTitleTextStyle() {
    return const TextStyle(
        color: Color(0xFF344157), fontSize: 18, letterSpacing: 0.14);
  }

  TextStyle get _buildTitleTextStyle {
    return const TextStyle(
        color: Color(0xFF0E9823),
        fontSize: 28,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.84);
  }

  @override
  void afterFirstLayout(BuildContext context) {
    logic.createWithdrawalLimit();
  }
}
