import 'package:after_layout/after_layout.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:privo/app/modules/on_boarding/widgets/result_page_widget.dart';
import 'package:privo/app/modules/polling/polling_screen.dart';
import 'package:privo/res.dart';

import 'offer_screen_polling_logic.dart';

class OfferScreenPollingView extends StatefulWidget {
  const OfferScreenPollingView({Key? key}) : super(key: key);

  @override
  State<OfferScreenPollingView> createState() => _OfferScreenPollingViewState();
}

class _OfferScreenPollingViewState extends State<OfferScreenPollingView>
    with AfterLayoutMixin {
  final logic = Get.find<OfferScreenPollingLogic>();

  @override
  Widget build(BuildContext context) {
    return PollingScreen(
      isV2: true,
      assetImagePath: Res.offer_polling,
      titleLines: const ["You’re doing great!"],
      bodyTexts: logic.computePollingBody(),
      onClosePressed: logic.onClosePressed,
      stopPollingCallback: logic.stopOfferPolling,
      startPollingCallback: logic.startOfferPolling,
    );
  }

  @override
  void afterFirstLayout(BuildContext context) {
    logic.onAfterLayout();
  }
}
