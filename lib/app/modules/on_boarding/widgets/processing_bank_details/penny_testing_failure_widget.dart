import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:privo/app/modules/on_boarding/widgets/processing_bank_details/processing_bank_details_logic.dart';
import 'package:privo/res.dart';

import '../../../../common_widgets/gradient_button.dart';
import '../../../../firebase/analytics.dart';
import '../../../../utils/web_engage_constant.dart';
import 'package:privo/app/theme/app_colors.dart';

class PennyTestingFailureWidget extends StatelessWidget {
  PennyTestingFailureWidget({
    Key? key,
  }) : super(key: key);

  final logic = Get.find<ProcessingBankDetailsLogic>();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Align(
                alignment: Alignment.centerRight,
                child: IconButton(
                  onPressed: () => Get.back(),
                  icon: const Icon(Icons.clear),
                ),
              ),
              const Spacer(),
              SvgPicture.asset(
                Res.bank_verify_failure,
              ),
              const SizedBox(
                height: 50,
              ),
              Flexible(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    "Bank verification failed",
                    textAlign: TextAlign.center,
                    style: _titleTextStyle(),
                  ),
                ),
              ),
              verticalSpacer(16),
              Flexible(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 60),
                  child: Text(
                    logic.failureMessage,
                    textAlign: TextAlign.center,
                    style: _messageTextStyle(),
                  ),
                ),
              ),
              verticalSpacer(50),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 35),
          child: configureRetryButton(),
        ),
        verticalSpacer(20),
      ],
    );
  }

  SizedBox verticalSpacer(double verticalHeight) {
    return SizedBox(
      height: verticalHeight,
    );
  }

  Widget configureRetryButton() {
    return Center(
      child: GradientButton(
        onPressed: () {
          AppAnalytics.trackWebEngageEventWithAttribute(
              eventName: WebEngageConstants.pennyTestFailureEditBankDetailsCTA);
          logic.goToBankDetails();
        },
        title: "Retry",
      ),
    );
  }

  TextStyle textButtonStyle() {
    return const TextStyle(
      fontSize: 16,
      letterSpacing: 0.24,
      decoration: TextDecoration.underline,
      fontStyle: FontStyle.normal,
      fontWeight: FontWeight.w300,
      color: skyBlueColor,
    );
  }

  TextStyle _titleTextStyle() {
    return GoogleFonts.poppins(
      fontSize: 14,
      fontWeight: FontWeight.w500,
      color: blue,
    );
  }

  TextStyle _messageTextStyle() {
    return const TextStyle(
      fontFamily: 'Figtree',
      fontSize: 11,
      fontWeight: FontWeight.w400,
      height: 1.5,
      color: blue,
    );
  }
}
