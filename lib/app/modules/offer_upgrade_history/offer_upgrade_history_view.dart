import 'dart:async';

import 'package:after_layout/after_layout.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:privo/app/modules/offer_upgrade_history/widgets/upgrade_history_list_view.dart';

import 'offer_upgrade_history_logic.dart';

class OfferUpgradeHistoryPage extends StatefulWidget {
  OfferUpgradeHistoryPage({Key? key}) : super(key: key);

  @override
  State<OfferUpgradeHistoryPage> createState() =>
      _OfferUpgradeHistoryPageState();
}

class _OfferUpgradeHistoryPageState extends State<OfferUpgradeHistoryPage>
    with AfterLayoutMixin {
  final logic = Get.find<OfferUpgradeHistoryLogic>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetBuilder<OfferUpgradeHistoryLogic>(
        id: logic.PAGE_WIDGET_ID,
        builder: (logic) {
          return logic.isLoading
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : UpgradeHistoryListScreen();
        },
      ),
    );
  }

  @override
  FutureOr<void> afterFirstLayout(BuildContext context) {
    logic.onAfterLayout();
  }
}
