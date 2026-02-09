import 'package:after_layout/after_layout.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:privo/app/modules/low_and_grow/low_and_grow_user_states.dart';

import 'low_and_grow_logic.dart';

class LowAndGrowScreen extends StatefulWidget {
  const LowAndGrowScreen({Key? key}) : super(key: key);

  @override
  State<LowAndGrowScreen> createState() => _LowAndGrowScreenState();
}

class _LowAndGrowScreenState extends State<LowAndGrowScreen>
    with AfterLayoutMixin {
  final logic = Get.find<LowAndGrowLogic>();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => logic.onBackPressed(),
      child: Scaffold(
        body: GetBuilder<LowAndGrowLogic>(
          id: logic.LOW_AND_GROW_SCREEN_ID,
          builder: (logic) {
            return lowAndGrowUserState[logic.lowAndGrowUserStates]!;
          },
        ),
      ),
    );
  }

  @override
  void afterFirstLayout(BuildContext context) {
    logic.afterLayout();
  }
}
