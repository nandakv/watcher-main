import 'package:after_layout/after_layout.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:privo/app/modules/polling/polling_screen.dart';
import 'package:privo/res.dart';

import 'initial_offer_polling_logic.dart';

class InitialOfferPollingView extends StatefulWidget {
  const InitialOfferPollingView({Key? key}) : super(key: key);

  @override
  State<InitialOfferPollingView> createState() =>
      _InitialOfferPollingViewState();
}

class _InitialOfferPollingViewState extends State<InitialOfferPollingView>
    with AfterLayoutMixin {
  final logic = Get.find<InitialOfferPollingLogic>();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<InitialOfferPollingLogic>(
      builder: (logic) {
        return logic.pageLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : PollingScreen(
                isV2: true,
                assetImagePath: Res.offer_polling,
                titleLines: logic.pollingTitles,
                bodyTexts: logic.pollingBodyText,
                onClosePressed: logic.onClosePressed,
                stopPollingCallback: logic.stopOfferPolling,
                startPollingCallback: logic.startOfferPolling,
                progressIndicatorText: logic.progressIndicatorText,
              );
      },
    );
  }

  @override
  void afterFirstLayout(BuildContext context) {
    logic.onAfterLayout();
  }
}
