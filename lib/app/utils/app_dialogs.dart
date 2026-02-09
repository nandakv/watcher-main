import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:privo/app/common_widgets/blue_border_button.dart';
import 'package:privo/app/common_widgets/blue_button.dart';
import 'package:privo/app/theme/app_colors.dart';

import '../api/response_model.dart';

enum ErrorDialogResult { retry, tryAgainLater, close, reportIssue }

class AppDialogs {
  static Future appDefaultDialog(
      {required String title,
      required String content,
      WillPopCallback? onWillPop,
      required List<Widget> actions}) async {
    return await Get.defaultDialog(
      onWillPop: onWillPop,
      title: title,
      barrierDismissible: false,
      titlePadding: const EdgeInsets.only(top: 30, bottom: 15),
      titleStyle: GoogleFonts.montserrat(
          fontSize: 20,
          color: const Color(0xff3B3B3E),
          fontWeight: FontWeight.normal),
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
      radius: 12,
      content: Column(
        children: [
          Text(
            content,
            style: const TextStyle(
                color: Color(0xff3B3B3E),
                fontSize: 14,
                fontWeight: FontWeight.normal),
            textAlign: TextAlign.center,
          ),
          const SizedBox(
            height: 20,
          ),
          Row(
            children: actions,
          )
          // TextButton(
          //     onPressed: () {
          //       Get.back();
          //       AppSettings.openDeviceSettings();
          //     },
          //     child: Text(
          //       "Continue",
          //       style: darkBlueButtonTextStyle(true),
          //     )),
        ],
      ),
    );
  }

  static Future<ErrorDialogResult?> appErrorDialog(ResponseState responseState,
      {bool shouldDismiss = false, bool shouldRetry = false}) async {
    return await Get.defaultDialog(
      title:
          responseState == ResponseState.noInternet ? "You're Offline" : "Oops",
      onWillPop: () async => shouldDismiss,
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(responseState == ResponseState.noInternet
              ? "Connect to a Network and Retry"
              : "Something went wrong"),
          const SizedBox(
            height: 20,
          ),
          if (shouldRetry)
            const BlueButton(
              onPressed: onRetry,
              buttonColor: activeButtonColor,
              title: "RETRY",
            ),
          if (shouldRetry)
            const SizedBox(
              height: 10,
            ),
          const BlueBorderButton(
              onPressed: onTryAgainLater,
              buttonColor: activeButtonColor,
              title: "Try again Later"),
        ],
      ),
      contentPadding: const EdgeInsets.all(12),
    );
  }
}

void onRetry() {
  Get.back(result: ErrorDialogResult.retry);
}

void onTryAgainLater() {
  Get.back(result: ErrorDialogResult.tryAgainLater);
}
