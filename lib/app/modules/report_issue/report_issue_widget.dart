import 'dart:async';

import 'package:after_layout/after_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:privo/app/common_widgets/gradient_button.dart';
import 'package:privo/app/common_widgets/vertical_spacer.dart';
import 'package:privo/app/modules/report_issue/report_issue_logic.dart';
import 'package:privo/app/theme/app_colors.dart';

import '../../../res.dart';
import '../../common_widgets/bottom_sheet_widget.dart';

class ReportIssueWidget extends StatefulWidget {
  final String screenName;
  final String errorLog;
  final bool fromHomeScreen;
  const ReportIssueWidget(
      {Key? key, required this.screenName, this.errorLog = "",this.fromHomeScreen = false})
      : super(key: key);

  @override
  State<ReportIssueWidget> createState() => _ReportIssueWidgetState();
}

class _ReportIssueWidgetState extends State<ReportIssueWidget>
    with AfterLayoutMixin {
  final logic = Get.put(ReportIssueLogic());

  @override
  Widget build(BuildContext context) {
    return BottomSheetWidget(
      onCloseClicked: () => Get.back(result: logic.isSuccess),
      child: SingleChildScrollView(
        child: GetBuilder<ReportIssueLogic>(
          builder: (logic) {
            if (logic.isSuccess) {
              return _successScreen();
            } else {
              return _reportIssueScreen();
            }
          },
        ),
      ),
    );
  }

  Widget _successTitle() {
    return const Text(
      "Thank you for reporting the issue!",
      textAlign: TextAlign.center,
      style: TextStyle(
          fontWeight: FontWeight.w500, fontSize: 16, color: darkBlueColor),
    );
  }

  Widget _successMessage() {
    return const Text(
      "Our team will investigate and get back to you shortly.",
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: 12,
        color: primaryDarkColor,
      ),
    );
  }

  Widget _successScreen() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18.0),
      child: Column(
        children: [
          SvgPicture.asset(
            Res.success_icon,
            width: 75,
            height: 75,
          ),
          verticalSpacer(12),
          _successTitle(),
          verticalSpacer(12),
          _successMessage(),
          verticalSpacer(24),
        ],
      ),
    );
  }

  Widget _title() {
    return const Text(
      "Describe the issue",
      style: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: darkBlueColor,
      ),
    );
  }

  Widget _inputField() {
    return TextFormField(
      maxLines: 8,
      controller: logic.issueDescriptionController,
      onChanged: logic.onTextChange,
      maxLength: 500,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: logic.validateReason,
      decoration: InputDecoration(
        hintText: "Type your issue in detail here...",
        hintStyle: const TextStyle(
          color: secondaryDarkColor,
          fontSize: 12,
        ),
        border: logic.borderStyle,
        enabledBorder: logic.borderStyle,
        focusedErrorBorder: logic.borderStyle,
        errorBorder: logic.borderStyle,
        focusedBorder: logic.borderStyle,
      ),
    );
  }

  Widget _ctaButton() {
    return GetBuilder<ReportIssueLogic>(
        id: logic.BUTTON_ID,
        builder: (logic) {
          return GradientButton(
            onPressed: logic.onSubmit,
            title: "Submit",
            isLoading: logic.buttonLoading,
            enabled: logic.buttonEnabled,
          );
        });
  }

  Widget _reportIssueScreen() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _title(),
        verticalSpacer(16),
        _inputField(), // TODO: fix height issue
        verticalSpacer(32),
        _ctaButton(),
        verticalSpacer(16),
      ],
    );
  }

  @override
  FutureOr<void> afterFirstLayout(BuildContext context) {
    logic.onAfterLayout(widget.screenName, widget.errorLog,widget.fromHomeScreen);
  }
}
