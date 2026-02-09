import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../../../../../res.dart';
import '../../../../../common_widgets/horizontal_timeline_step_widget.dart';
import '../../../../../theme/app_colors.dart';
import '../../../../polling/polling_screen.dart';
import '../e_mandate_polling_logic.dart';

class EMandatePollingWidget extends StatelessWidget {
  EMandatePollingWidget({Key? key}) : super(key: key);

  final logic = Get.find<EMandatePollingLogic>();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: PollingScreen(
            bodyTexts: logic.computeBodyTexts(),
            titleLines: const ["Activating Auto-Pay"],
            assetImagePath: Res.eMandatePollingSVG,
            bodyTextStyle: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: darkBlueColor,
                fontFamily: 'Figtree'),
            progressIndicatorText: "it usually takes less than a minute to complete",
            isV2: true,
            // widgetBelowIllustration: _withdrawalProgressWidget(),
            onClosePressed: logic.onClosePressed,
            stopPollingCallback: logic.stopEMandatePolling,
            startPollingCallback: logic.startEmandatePolling,
          ),
        ),
      ],
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
          child: SvgPicture.asset(Res.minimizeSVG),
        ),
      ),
    );
  }

  _withdrawalProgressWidget() {
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
        child: _stepperRow(),
      ),
    );
  }

  Widget _stepperRow() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: const [
          HorizontalTimelineStepWidget(
            label: "Request Sent",
            step: "1",
            state: HorizontalTimelineStepWidgetState.success,
          ),
          HorizontalTimelineStepWidget(
            label: "Request Approved",
            step: "2",
            state: HorizontalTimelineStepWidgetState.inActive,
            isLastStep: true,
          ),
        ],
      ),
    );
  }
}
