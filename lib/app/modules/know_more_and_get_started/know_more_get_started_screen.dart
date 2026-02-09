import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:privo/app/modules/know_more_and_get_started/know_more_get_started_logic.dart';
import 'package:privo/app/modules/know_more_and_get_started/widgets/get_started_screen.dart';
import 'package:privo/app/modules/know_more_and_get_started/widgets/know_more_app_bar.dart';
import 'package:privo/app/modules/know_more_and_get_started/widgets/know_more_screen.dart';

class KnowMoreGetStartedScreen extends StatelessWidget {
  KnowMoreGetStartedScreen({Key? key}) : super(key: key);

  final KnowMoreGetStartedLogic logic = Get.find<KnowMoreGetStartedLogic>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            const KnowMoreAppBar(),
            Expanded(child: _computeBody()),
          ],
        ),
      ),
    );
  }

  Widget _computeBody() {
    return GetBuilder<KnowMoreGetStartedLogic>(builder: (logic) {
      switch (logic.knowMoreGetStartedState) {
        case KnowMoreGetStartedState.knowMore:
          return KnowMoreScreen();
        default:
          return GetStartedScreen();
      }
    });
  }
}
