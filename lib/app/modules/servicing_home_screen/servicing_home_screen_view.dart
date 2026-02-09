import 'dart:async';

import 'package:after_layout/after_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:privo/app/modules/servicing_home_screen/servicing_all_withdrawal_screen.dart';

import 'servicing_home_screen_logic.dart';

class ServicingHomeScreenPage extends StatefulWidget {
  ServicingHomeScreenPage({Key? key}) : super(key: key);

  @override
  State<ServicingHomeScreenPage> createState() =>
      _ServicingHomeScreenPageState();
}

class _ServicingHomeScreenPageState extends State<ServicingHomeScreenPage>
    with AfterLayoutMixin {
  final logic = Get.find<ServicingHomeScreenLogic>();

  // @override
  // void initState() {
  //   super.initState();
  //   SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
  //     statusBarBrightness: Brightness.light,
  //     statusBarIconBrightness: Brightness.light,
  //   ));
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: GetBuilder<ServicingHomeScreenLogic>(
          builder: (logic) {
            if (logic.isPageLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else {
              return ServicingAllWithdrawalScreen();
            }
          },
        ),
      ),
    );
  }

  @override
  FutureOr<void> afterFirstLayout(BuildContext context) {
    logic.onAfterLayout();
  }
}
