import 'package:after_layout/after_layout.dart';
import 'package:intl/intl.dart';
import 'package:privo/app/common_widgets/app_lottie_widget.dart';
import 'package:privo/app/modules/on_boarding/widgets/bank_details/bank_details_logic.dart';
import 'package:privo/app/modules/on_boarding/widgets/processing_bank_details/penny_testing_failure_widget.dart';
import 'package:privo/app/modules/on_boarding/widgets/processing_bank_details/penny_testing_success_widget.dart';
import 'package:privo/app/modules/on_boarding/widgets/processing_bank_details/processing_bank_details_logic.dart';
import 'package:privo/app/modules/polling/polling_screen.dart';
import 'package:privo/app/theme/app_colors.dart';
import 'package:privo/res.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../firebase/analytics.dart';
import '../../../../utils/web_engage_constant.dart';

class ProcessingApplicationView extends StatefulWidget {
  const ProcessingApplicationView({Key? key}) : super(key: key);

  @override
  State<ProcessingApplicationView> createState() =>
      _ProcessingApplicationViewState();
}

class _ProcessingApplicationViewState extends State<ProcessingApplicationView>
    with AfterLayoutMixin {
  final logic = Get.find<ProcessingBankDetailsLogic>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: GetBuilder<ProcessingBankDetailsLogic>(
        id: logic.DEPOSITED_WIDGET,
        builder: (logic) {
          switch (logic.pennyTestingState) {
            case PennyTestingState.pending:
              return PollingScreen(
                isV2: true,
                assetImagePath: Res.penny_testing_polling,
                titleLines: logic.computeTitle(),
                timerWidget: _computeTimerWidget(),
                bodyTexts: const [
                  "We’re verifying your\nbank account...",
                ],
                onClosePressed: logic.onClosePressed,
                stopPollingCallback: logic.stopPennyTestingPolling,
                startPollingCallback: logic.startPennyTestPolling,
              );
            case PennyTestingState.success:
              return PennyTestingSuccessWidget();
            case PennyTestingState.failure:
              return PennyTestingFailureWidget();
            case PennyTestingState.loading:
              return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }

  Widget? _computeTimerWidget() {
    if (logic.pennyTestingData.pennyTestingType == PennyTestingType.reverse) {
      if (logic.pennyTestingData.validUpto != null) {
        return _countDownTimerWidget();
      }
      return const SizedBox();
    }
    return null;
  }

  TextStyle _timerTextStyle() {
    return const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w300,
        letterSpacing: 0.08,
        height: 1.3,
        color: Color(0xff1D478E),
        fontFamily: 'Figtree');
  }

  Widget _countDownTimerWidget() {
    // Duration timeDifference = logic.computeDuration();
    ///Timer will be always set to 5 minutes
    Duration timeDifference = const Duration(minutes: 5);
    return TweenAnimationBuilder<Duration>(
        duration: timeDifference,
        tween: Tween(begin: timeDifference, end: Duration.zero),
        onEnd: () {
          AppAnalytics.trackWebEngageEventWithAttribute(
              eventName: WebEngageConstants.rpdTimeOut);
        },
        builder: (BuildContext context, Duration value, Widget? child) {
          final int minutes = value.inMinutes;
          final int seconds = value.inSeconds % 60;
          if (minutes == 0 && seconds == 0) {
            return const SizedBox();
          }
          return Text(
            'Time left : ${minutes.toString().padLeft(2, "0")}:${seconds.toString().padLeft(2, "0")}',
            textAlign: TextAlign.center,
            style: _timerTextStyle(),
          );
        });
  }

  _processingApplicationWidget() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 40, bottom: 20),
          child: Text(
            "Please Wait",
            style: titleTextStyle(),
          ),
        ),
        Flexible(
          child: Text(
            "Processing Your Application",
            textAlign: TextAlign.center,
            style: subTitleTextStyle(),
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        const Expanded(
          child: AppLottieWidget(
            assetPath: Res.processing_application,
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Text(
            "Please do not close the app or go back",
            textAlign: TextAlign.center,
            style: cautionTextStyle(),
          ),
        ),
        const SizedBox(
          height: 20,
        ),
      ],
    );
  }

  TextStyle textStyle() {
    return const TextStyle(
        fontSize: 12,
        letterSpacing: 0.11,
        fontStyle: FontStyle.normal,
        color: Color(0xFF344157));
  }

  TextStyle cautionTextStyle() => const TextStyle(
        fontSize: 12,
        letterSpacing: 0.09,
        color: Color(0xff363840),
      );

  TextStyle subTitleTextStyle() {
    return const TextStyle(
        fontSize: 18, letterSpacing: 0.14, color: Color(0xff363840));
  }

  TextStyle titleTextStyle() {
    return const TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.18,
        color: activeButtonColor);
  }

  @override
  void afterFirstLayout(BuildContext context) {
    logic.onAfterLayout();
  }
}
