import 'package:after_layout/after_layout.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:privo/app/modules/on_boarding/widgets/personal_details_polling/personal_details_polling_logic.dart';
import 'package:privo/app/modules/polling/polling_screen.dart';
import 'package:privo/res.dart';

class PersonalDetailsPollingView extends StatefulWidget {
  const PersonalDetailsPollingView({Key? key}) : super(key: key);

  @override
  State<PersonalDetailsPollingView> createState() =>
      _PersonalDetailsPollingViewState();
}

class _PersonalDetailsPollingViewState extends State<PersonalDetailsPollingView>
    with AfterLayoutMixin {
  final logic = Get.find<PersonalDetailsPollingLogic>();

  @override
  Widget build(BuildContext context) {
    return PollingScreen(
      isV2: true,
      assetImagePath: Res.offer_polling,
      titleLines: const ["Hold Tight !"],
      bodyTexts: const ["We are evaluating your personal details"],
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
