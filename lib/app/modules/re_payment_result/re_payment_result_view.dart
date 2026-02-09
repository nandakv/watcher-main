import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:privo/app/common_widgets/app_lottie_widget.dart';
import 'package:privo/app/modules/re_payment_result/widgets/failure_screen.dart';
import 'package:privo/app/modules/re_payment_result/widgets/success_widget.dart';
import 'package:privo/app/theme/app_colors.dart';
import 'package:privo/app/utils/app_functions.dart';
import 'package:privo/res.dart';

import 're_payment_result_logic.dart';

class RePaymentResultPage extends StatelessWidget {
  final logic = Get.find<RePaymentResultLogic>();

  RePaymentResultPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Get.back(result: computeIsPaymentSuccess());
        return true;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SizedBox(
          width: double.infinity,
          child: SafeArea(
            child: logic.resultModel.isSuccess ? SuccessWidget(amount: logic.resultModel.amount) : FailureScreen(),
          ),
        ),
      ),
    );
  }

  bool computeIsPaymentSuccess() => logic.resultModel.isSuccess ? true : false;


}
