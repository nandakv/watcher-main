import 'package:after_layout/after_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:privo/app/common_widgets/polling_title_widget.dart';
import 'package:privo/app/theme/app_colors.dart';
import 'package:privo/res.dart';

import '../../../polling/polling_screen.dart';
import 'offer_upgrade_polling_logic.dart';
import '../../../../common_widgets/failure_page.dart';
import 'widgets/offer_upgrade_polling_success_widget.dart';

class OfferUpgradePollingView extends StatefulWidget {
  const OfferUpgradePollingView({Key? key}) : super(key: key);

  @override
  State<OfferUpgradePollingView> createState() =>
      _OfferUpgradePollingViewState();
}

class _OfferUpgradePollingViewState extends State<OfferUpgradePollingView>
    with AfterLayoutMixin {
  final logic = Get.put(OfferUpgradePollingLogic());

  @override
  Widget build(BuildContext context) {
    return GetBuilder<OfferUpgradePollingLogic>(
      id: logic.PAGE_ID,
      builder: (logic) {
        switch (logic.offerUpgradeStatus) {
          case OfferUpgradeStatus.polling:
            return PollingScreen(
              isV2: true,
              assetImagePath: Res.businessPollingSVG,
              titleLines: const ["Hold Tight!"],
              bodyTexts: const [
                "Give us a minute for checking eligibility...",
                "Evaluating credit profile..."
              ],
              onClosePressed: logic.onClosePressed,
              stopPollingCallback: logic.stopOfferUpgradePolling,
              startPollingCallback: logic.startOfferUpgradePolling,
            );
          case OfferUpgradeStatus.failure:
          case OfferUpgradeStatus.nameMatchFailure:
          case OfferUpgradeStatus.limitExceeded:
          case OfferUpgradeStatus.noTransactions:
            return _offerUpgradeFailureWidget();
          case OfferUpgradeStatus.sameOffer:
            return OfferPollingSuccessWidget(
              offerUpgraded: false,
            );
          case OfferUpgradeStatus.offerUpgraded:
            return OfferPollingSuccessWidget(
              offerUpgraded: true,
            );
          case OfferUpgradeStatus.loading:
            return const Center(
              child: CircularProgressIndicator(),
            );
        }
      },
    );
  }

  Widget _offerUpgradeFailureWidget() {
    return FailurePage(
      title: logic.computeFailureTitle(),
      message: logic.computeFailureBodyText(),
      illustration: logic.computeFailureIllustration(),
      ctaTitle: logic.computeFailureButtonText(),
      onCtaClicked: logic.onPollingFailedRetryClicked,
    );
  }

  @override
  void afterFirstLayout(BuildContext context) {
    logic.onAfterLayout();
  }

  _successWidget() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Spacer(),
          const PollingTitleWidget(title: "Upgrade Success"),
          const SizedBox(
            height: 28,
          ),
          const Text(
            "It might take up to a minute to load\nyour offer",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: darkBlueColor,
              fontWeight: FontWeight.w300,
              fontSize: 12,
              letterSpacing: 0.19,
            ),
          ),
          const SizedBox(
            height: 24,
          ),
          SvgPicture.asset(Res.aa_success),
          const Spacer()
        ],
      ),
    );
  }
}
