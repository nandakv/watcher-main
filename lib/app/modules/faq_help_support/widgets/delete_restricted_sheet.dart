import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:privo/app/common_widgets/vertical_spacer.dart';
import 'package:privo/app/models/delete_eligible_model.dart';
import 'package:privo/app/modules/faq_help_support/widgets/flat_outlined_button.dart';
import 'package:privo/app/theme/app_colors.dart';

class DeleteRestrictedSheet extends StatelessWidget {
  String title;
  String message;

  DeleteRestrictedSheet(
      {this.title = "We can't process your account deletion request",
      required this.message});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: [
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: Colors.white,
          ),
          margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _close(),
              _bodyWidget(),
            ],
          ),
        )
      ],
    );
  }

  Align _close() {
    return Align(
      alignment: Alignment.topRight,
      child: IconButton(
        onPressed: () {
          // AppAnalytics.trackWebEngageEventWithAttribute(
          //     eventName: closedEvent);
          Get.back();
        },
        icon: const Icon(
          Icons.clear_rounded,
          color: Color(0xFF161742),
          size: 20,
        ),
      ),
    );
  }

  Widget _bodyWidget() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(right: 30),
            child: Text(
              title,
              style: TextStyle(
                fontSize: 14,
                color: darkBlueColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          verticalSpacer(10),
          Text(
            message,
            style: const TextStyle(
                color: secondaryDarkColor,
                fontSize: 12,
                fontWeight: FontWeight.w400),
          ),
          verticalSpacer(20),
          Center(
            child: FlatOutlinedButton(
              title: 'Got it',
              onPressed: () {
                Get.back();
              },
              isFilled: true,
            ),
          ),
          verticalSpacer(20),
        ],
      ),
    );
  }
}
