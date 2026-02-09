import 'package:after_layout/after_layout.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../res.dart';
import '../../../polling/polling_screen.dart';
import 'low_and_grow_wait_logic.dart';

class LowAndGrowWaitScreen extends StatefulWidget {
  const LowAndGrowWaitScreen({Key? key}) : super(key: key);

  @override
  State<LowAndGrowWaitScreen> createState() => _LowAndGrowWaitScreenState();
}

class _LowAndGrowWaitScreenState extends State<LowAndGrowWaitScreen>
    with AfterLayoutMixin {
  final logic = Get.find<LowAndGrowWaitLogic>();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xffFFF3EB),
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: PollingScreen(
        isV2: true,
        bodyTexts: const ["We're processing your request for an upgraded offer"],
        titleLines: [],
        assetImagePath: Res.applicationInProgressFull,
        onClosePressed: logic.onClosePressed,
      ),
    );
  }

  @override
  void afterFirstLayout(BuildContext context) {
    logic.onAfterLayout();
  }
}
