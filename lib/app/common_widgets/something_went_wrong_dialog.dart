import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:privo/app/common_widgets/vertical_spacer.dart';
import 'package:privo/app/theme/app_colors.dart';
import '../utils/app_dialogs.dart';
import 'bottom_sheet_widget.dart';

class SomethingWentWrongDialog extends StatelessWidget {
  final bool shouldDismiss;
  final bool shouldRetry;
  final bool showReportIssue;
  const SomethingWentWrongDialog(
      {Key? key,
      this.shouldDismiss = false,
      required this.shouldRetry,
      this.showReportIssue = false})
      : super(key: key);

  Widget _messageWidget() {
    return Text(
      _computeMessageText,
      textAlign: TextAlign.center,
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: darkBlueColor,
        height: 1.6,
      ),
    );
  }

  String get _computeMessageText {
    if (showReportIssue) {
      if (shouldRetry) {
        return "We're experiencing some technical difficulties. Please try again or report the issue.";
      } else {
        return "We're experiencing some technical difficulties. You can report the issue to us.";
      }
    } else {
      if (shouldRetry) {
        return "We're experiencing some technical difficulties. Please try again.";
      } else {
        return "We're experiencing some technical difficulties. Please try again later.";
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BottomSheetWidget(
      onCloseClicked: () => Get.back(result: ErrorDialogResult.close),
      child: Column(
        children: [
          _messageWidget(),
          verticalSpacer(20),
          _computeCTA(),
          verticalSpacer(24),
        ],
      ),
    );
  }

  Widget _computeCTA() {
    if (!shouldRetry && !showReportIssue) {
      return _tryAgainLaterCTA();
    } else {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (showReportIssue) _reportIssueCTA(isFilled: !shouldRetry),
          if (shouldRetry) _retryCTA(),
        ],
      );
    }
  }

  Widget _reportIssueCTA({bool isFilled = false}) {
    return _ctaButton(
      title: "Report issue",
      onTap: () => Get.back(result: ErrorDialogResult.reportIssue),
      isFilled: isFilled,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
    );
  }

  Widget _retryCTA() {
    return _ctaButton(
      title: "Retry",
      onTap: () => Get.back(result: ErrorDialogResult.retry),
      isFilled: true,
    );
  }

  Widget _tryAgainLaterCTA() {
    return _ctaButton(
      title: "Try again later",
      onTap: () => Get.back(result: ErrorDialogResult.tryAgainLater),
      isFilled: true,
    );
  }

  Widget _ctaButton({
    required String title,
    required Function() onTap,
    required bool isFilled,
    EdgeInsets padding =
        const EdgeInsets.symmetric(horizontal: 35, vertical: 10),
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: InkWell(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            color: isFilled ? darkBlueColor : Colors.white,
            borderRadius: BorderRadius.circular(50),
            border: Border.all(
              color: darkBlueColor,
              width: 1,
            ),
          ),
          child: Padding(
            padding: padding,
            child: Text(
              title,
              style: TextStyle(
                color: isFilled ? offWhiteColor : darkBlueColor,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
