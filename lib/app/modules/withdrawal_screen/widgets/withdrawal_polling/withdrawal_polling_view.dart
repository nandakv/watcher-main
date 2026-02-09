import 'dart:async';

import 'package:after_layout/after_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:privo/app/common_widgets/gradient_button.dart';
import 'package:privo/app/common_widgets/horizontal_timeline_step_widget.dart';
import 'package:privo/app/modules/polling/gradient_circular_progress_indicator.dart';
import 'package:privo/app/modules/polling/polling_screen.dart';
import 'package:privo/app/theme/app_colors.dart';
import 'package:privo/res.dart';

import '../../../../models/withdrawal_status_model.dart';
import 'withdrawal_polling_logic.dart';

class WithdrawalPollingPage extends StatefulWidget {
  WithdrawalPollingPage({Key? key}) : super(key: key);

  @override
  State<WithdrawalPollingPage> createState() => _WithdrawalPollingPageState();
}

class _WithdrawalPollingPageState extends State<WithdrawalPollingPage>
    with AfterLayoutMixin {
  final logic = Get.find<WithdrawalPollingLogic>();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<WithdrawalPollingLogic>(
      id: logic.WITHDRAWAL_POLLING_PAGE_KEY,
      builder: (logic) {
        return logic.isLoading
            ? const Center(
                child: Hero(
                  tag: 'circle',
                  child: RotationTransitionWidget(
                      loadingState: LoadingState.bottomLoader),
                ),
              )
            : Column(
                children: [
                  // _topRightButton(),
                  Expanded(
                    child: PollingScreen(
                      bodyTexts: [logic.pollingBodyText],
                      titleLines: [logic.pollingTitleText],
                      assetImagePath: logic.centerIllustration,
                      bodyTextStyle: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: darkBlueColor,
                        fontFamily: 'Figtree'
                      ),
                      onClosePressed: logic.onClosePressed,
                      progressIndicatorText:
                          "Please do not close the app",
                      isV2: true,
                      widgetBelowIllustration: _withdrawalProgressWidget(),
                      replaceProgressWidget: _computeBottomButton(),
                      stopPollingCallback: logic.stopPolling,
                      startPollingCallback: logic.startPolling,
                    ),
                  ),
                ],
              );
      },
    );
  }

  Container _topRightButton() {
    return Container(
      color: offWhiteColor,
      padding: const EdgeInsets.all(12),
      child: Align(
        alignment: Alignment.centerRight,
        child: InkWell(
          onTap: logic.onMinimizePressed,
          child: SvgPicture.asset(logic.topRightIcon),
        ),
      ),
    );
  }

  Widget? _computeBottomButton() {
    switch (logic.withdrawalPollingStatus) {
      case WithdrawalPollingStatus.initiated:
      case WithdrawalPollingStatus.processed:
        return null;
      case WithdrawalPollingStatus.withdrawCancelled:
        return GradientButton(
          onPressed: logic.onRetryWithdrawalClicked,
          title: "Retry Withdrawal",
        );
      case WithdrawalPollingStatus.loanCreated:
        return const SizedBox();
      case WithdrawalPollingStatus.withdrawalFailed:
        return _withdrawalFailedBottomWidget();
    }
  }

  Widget _withdrawalFailedBottomWidget() {
    return InkWell(
      onTap: logic.navigateToServicingScreen,
      child: const Text.rich(
        TextSpan(
          children: [
            TextSpan(
              text: 'You can find processing withdrawal under \n',
              style: TextStyle(
                color: darkBlueColor,
                fontSize: 10,
                fontWeight: FontWeight.w500,
              ),
            ),
            TextSpan(
              text: 'All withdrawals',
              style: TextStyle(
                color: skyBlueColor,
                fontSize: 12,
                fontWeight: FontWeight.w500,
                decoration: TextDecoration.underline,
              ),
            ),
          ],
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _withdrawalProgressWidget() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 20,
          horizontal: 15,
        ),
        child: Column(
          children: [
            _stepperRow(),
            if (logic.withdrawalPollingStatus ==
                    WithdrawalPollingStatus.withdrawCancelled ||
                logic.withdrawalPollingStatus ==
                    WithdrawalPollingStatus.withdrawalFailed) ...[
              const SizedBox(
                height: 15,
              ),
              Text(
                logic.errorMessage,
                style: const TextStyle(
                  color: red,
                  fontSize: 10,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              if (logic.errorDateTime != null)
                Text(
                  DateFormat('dd MMMM, yyyy \'at\' hh:mm a')
                      .format(logic.errorDateTime!.toLocal()),
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: red,
                    fontSize: 8,
                    fontWeight: FontWeight.w400,
                  ),
                ),
            ],
          ],
        ),
      ),
    );
  }

  Row _stepperRow() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        HorizontalTimelineStepWidget(
          label: "Initiated",
          step: "1",
          state: logic.initiatedState,
        ),
        HorizontalTimelineStepWidget(
          label: "Processed",
          step: "2",
          state: logic.processedState,
        ),
        HorizontalTimelineStepWidget(
          label: "Transferred",
          step: "3",
          state: logic.transferredState,
          isLastStep: true,
        ),
      ],
    );
  }

  @override
  FutureOr<void> afterFirstLayout(BuildContext context) {
    logic.afterLayout();
  }
}
