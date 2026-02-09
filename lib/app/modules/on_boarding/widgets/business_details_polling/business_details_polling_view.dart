import 'dart:async';

import 'package:after_layout/after_layout.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:privo/app/modules/polling/polling_screen.dart';
import 'package:privo/res.dart';

import 'business_details_polling_logic.dart';

class BusinessDetailsPollingView extends StatefulWidget {
  const BusinessDetailsPollingView({super.key});

  @override
  State<BusinessDetailsPollingView> createState() =>
      _BusinessDetailsPollingViewState();
}

class _BusinessDetailsPollingViewState extends State<BusinessDetailsPollingView>
    with AfterLayoutMixin {
  final logic = Get.find<BusinessDetailsPollingLogic>();

  @override
  Widget build(BuildContext context) {
    return PollingScreen(
      bodyTexts: const ["We are evaluating your business details"],
      titleLines: const ["Hold Tight !"],
      assetImagePath: Res.businessPollingSVG,
      isV2: true,
      onClosePressed: logic.onClosePressed,
      stopPollingCallback: logic.onStopPolling,
      startPollingCallback: logic.startPolling,
    );
  }

  @override
  FutureOr<void> afterFirstLayout(BuildContext context) {
    logic.onAfterLayout();
  }
}
