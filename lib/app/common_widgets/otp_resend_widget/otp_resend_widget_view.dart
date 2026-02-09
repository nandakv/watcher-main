import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:privo/app/common_widgets/gradient_button.dart';
import 'package:privo/app/modules/polling/gradient_circular_progress_indicator.dart';
import 'package:privo/app/theme/app_colors.dart';

import 'otp_resend_widget_logic.dart';

class OtpResendWidget extends StatefulWidget {
  const OtpResendWidget({
    Key? key,
    required this.isResendLoading,
    required this.onResendPressed,
    this.timerValue = 30,
    this.alignment = Alignment.center,
    this.color = activeButtonColor,
    this.buttonTheme = AppButtonTheme.light,
    this.fontWeight = FontWeight.w500,
    this.buttonPadding = const EdgeInsets.all(20.0),
  }) : super(key: key);

  final bool isResendLoading;
  final Function() onResendPressed;
  final int timerValue;
  final Alignment alignment;
  final Color color;
  final FontWeight fontWeight;
  final AppButtonTheme buttonTheme;
  final EdgeInsets buttonPadding;

  @override
  State<OtpResendWidget> createState() => _OtpResendWidgetState();
}

class _OtpResendWidgetState extends State<OtpResendWidget> {
  final logic = Get.put(OtpResendWidgetLogic());

  @override
  void initState() {
    super.initState();
    logic.sCount = widget.timerValue;
    if (logic.sCount < widget.timerValue) {
      widget.onResendPressed();
    }
    logic.stateTimerStart();
  }

  @override
  void dispose() {
    logic.onClose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<OtpResendWidgetLogic>(
      id: 'resend',
      builder: (controller) {
        return Align(
          alignment: widget.alignment,
          child: widget.isResendLoading
              ? _resendLoadingWidget()
              : _resendButton(controller),
        );
      },
    );
  }

  Padding _resendLoadingWidget() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: RotationTransitionWidget(
        loadingState: LoadingState.bottomLoader,
        buttonTheme: widget.buttonTheme,
        alignment: widget.alignment,
      ),
    );
  }

  Widget _resendButton(OtpResendWidgetLogic controller) {
    return Padding(
      padding: widget.buttonPadding,
      child: InkWell(
        onTap: () async {
          if (!(controller.sCount > 0)) {
            await widget.onResendPressed();
            logic.onResendPressed(widget.timerValue);
          }
        },
        child: Text(
          (controller.sCount > 0)
              ? """Resend in 00:${controller.sCount < 10 ? "0" + controller.sCount.toString() : controller.sCount.toString()} """
              : "Resend",
          style: TextStyle(
            fontSize: 12,
            color: widget.color,
            letterSpacing: 0.1,
            fontWeight: widget.fontWeight,
          ),
          textAlign: TextAlign.start,
        ),
      ),
    );
  }
}
