import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:privo/app/common_widgets/gradient_button.dart';
import 'package:privo/app/modules/withdrawal_screen/widgets/withdrawal/withdrawal_logic.dart';
import 'package:privo/app/modules/withdrawal_screen/widgets/withdrawal_polling/withdrawal_polling_logic.dart';
import 'package:privo/app/common_widgets/polling_title_widget.dart';
import 'package:privo/app/theme/app_colors.dart';
import 'package:privo/app/utils/app_functions.dart';
import 'package:privo/res.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../../firebase/analytics.dart';
import '../../../utils/web_engage_constant.dart';
import '../withdrawal_screen_logic.dart';

class WithDrawSuccess extends StatelessWidget {
  WithDrawSuccess({Key? key}) : super(key: key);
  final logic = Get.find<WithdrawalPollingLogic>();
  final withdrawalLogic = Get.find<WithdrawalLogic>();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        AppAnalytics.trackWebEngageEventWithAttribute(
            eventName: WebEngageConstants.withdrawalSuccessBackButtonClicked);
        return true;
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(),
            const PollingTitleWidget(title: "Withdrawal Successful!"),
            Padding(
              padding: const EdgeInsets.only(top: 25, left: 35, right: 35),
              child: _computeSuccessText(),
            ),
            SvgPicture.asset(Res.withdrawal_processing),
            const Spacer(),

            ///Withdraw button
            GradientButton(
              bottomPadding: 32,
              onPressed: () {
                AppAnalytics.trackWebEngageEventWithAttribute(
                    eventName: WebEngageConstants.withdrawalConfirmCTAClicked);
                Get.back();
              },
              title: "Confirm",
            ),
          ],
        ),
      ),
    );
  }

  Widget _computeSuccessText() {
    if (withdrawalLogic.isInsuranceChecked) {
      AppAnalytics.trackWebEngageEventWithAttribute(
          eventName: WebEngageConstants.insuranceSuccessScreenLoaded);
    }
    return Text.rich(
      TextSpan(
        children: [
          TextSpan(
            text: AppFunctions.getIOFOAmount(logic.disbursedAmount),
            style: _titleTextStyle(),
          ),
          TextSpan(
            text: ' has been transferred \nto your bank account',
            style: _subTitleTextStyle(),
          ),
          if (withdrawalLogic.isInsuranceChecked) ...[
            TextSpan(
              text: ' and protected with \n',
              style: _subTitleTextStyle(),
            ),
            TextSpan(
              text: withdrawalLogic.withdrawalCalculationModel?.insuranceDetails
                  ?.policyDetails.first.text,
              style: _titleTextStyle(),
            )
          ]
        ],
      ),
      textAlign: TextAlign.center,
    );
  }

  TextStyle _titleTextStyle() {
    return const TextStyle(
      color: Color(0xFF1D478E),
      fontSize: 12,
      fontFamily: 'Figtree',
      fontWeight: FontWeight.w700,
    );
  }

  TextStyle _subTitleTextStyle() {
    return const TextStyle(
      color: Color(0xFF1D478E),
      fontSize: 12,
      fontFamily: 'Figtree',
      fontWeight: FontWeight.w500,
    );
  }
}
