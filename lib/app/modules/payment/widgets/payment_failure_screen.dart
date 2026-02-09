import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:privo/app/common_widgets/gradient_button.dart';
import 'package:privo/app/common_widgets/vertical_spacer.dart';
import 'package:privo/app/firebase/analytics.dart';
import 'package:privo/app/theme/app_colors.dart';
import 'package:privo/app/utils/web_engage_constant.dart';

import '../../../../../res.dart';
import '../../../common_widgets/polling_title_widget.dart';

class PaymentFailureScreen extends StatelessWidget {
  var arguments = Get.arguments;

  Widget _closeButton() {
    return Padding(
      padding: const EdgeInsets.only(right: 12.0),
      child: Align(
        alignment: Alignment.centerRight,
        child: SizedBox(
          width: 35,
          child: IconButton(
            onPressed: Get.back,
            icon: const Icon(
              Icons.clear_rounded,
              color: appBarTitleColor,
            ),
          ),
        ),
      ),
    );
  }

  Widget _titleWidget() {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 32),
      child: PollingTitleWidget(title: "Payment Failed!"),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        color: offWhiteColor,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _closeButton(),
            const Spacer(),
            _titleWidget(),
            verticalSpacer(26),
            SvgPicture.asset(Res.piggy_bank_failure_svg),
            verticalSpacer(44),
            const Text(
              "Uh-oh!",
              style: TextStyle(
                color: darkBlueColor,
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
            verticalSpacer(8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Text(
                arguments != null && arguments['message'] != null
                    ? arguments['message']
                    : "We're having a temporary issue with your payment. Please try again later. Any debited amount will be reflected in your available limit within 24-48 hours.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: darkBlueColor,
                  fontWeight: FontWeight.w500,
                  fontSize: 12,
                ),
              ),
            ),
            const Spacer(),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 32),
              child: GradientButton(
                onPressed: () {
                  AppAnalytics.trackWebEngageEventWithAttribute(
                    eventName: WebEngageConstants.paymentFailureLoaded,
                    attributeName: {
                      "part_payment": true,
                    },
                  );
                  Get.back();
                },
                title: "Try again",
                bottomPadding: 30,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
