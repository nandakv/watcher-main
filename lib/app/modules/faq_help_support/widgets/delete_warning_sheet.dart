import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:privo/app/common_widgets/vertical_spacer.dart';
import 'package:privo/app/firebase/analytics.dart';
import 'package:privo/app/modules/faq_help_support/faq_help_support_logic.dart';
import 'package:privo/app/modules/faq_help_support/widgets/delete_request_success_sheet.dart';
import 'package:privo/app/modules/faq_help_support/widgets/flat_outlined_button.dart';
import 'package:privo/app/theme/app_colors.dart';

class DeleteWarningSheet extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: Colors.white,
          ),
          margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: Column(
            children: [
              Align(
                alignment: Alignment.topRight,
                child: IconButton(
                  onPressed: () {
                    // AppAnalytics.trackWebEngageEventWithAttribute(
                    //     eventName: closedEvent);
                    Get.back();
                    Get.focusScope?.unfocus();
                  },
                  icon: const Icon(
                    Icons.clear_rounded,
                    color: Color(0xFF161742),
                    size: 20,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 24, left: 24, right: 24),
                child: _bodyWidget(),
              ),
            ],
          ),
        )
      ],
    );
  }

  Column _bodyWidget() {
    return Column(
      children: [
        _bodyTitle(),
        verticalSpacer(5),
        _bodySubTitle(),
        verticalSpacer(20),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 50),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: FlatOutlinedButton(
                  onPressed: () {
                    Get.focusScope?.unfocus();
                    Get.back(result: false);
                  },
                  title: 'Cancel',
                  isFilled: false,
                ),
              ),
              const SizedBox(
                width: 30,
              ),
              Expanded(
                child: FlatOutlinedButton(
                  onPressed: () async {
                    Get.back(result: true);
                  },
                  edgeInsets: const EdgeInsets.symmetric(horizontal: 20),
                  title: 'Submit',
                  isFilled: true,
                ),
              ),
            ],
          ),
        )
      ],
    );
  }

  Text _bodySubTitle() {
    return const Text(
      "Deleting your account now means you won't be able to apply for the Privo Instant Loan for 6 months.",
      textAlign: TextAlign.center,
      style: TextStyle(
          color: secondaryDarkColor, fontSize: 12, fontWeight: FontWeight.w500),
    );
  }

  Text _bodyTitle() {
    return const Text(
      "Attention!",
      style: TextStyle(
          color: Color(0xFFEE3D4B), fontWeight: FontWeight.w600, fontSize: 16),
    );
  }
}
