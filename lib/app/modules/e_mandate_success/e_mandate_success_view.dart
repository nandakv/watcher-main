import 'package:privo/app/theme/app_colors.dart';
import 'package:privo/res.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import 'e_mandate_success_logic.dart';

///This class shows e mandate success page with an illustration

class EMandateSuccessView extends StatelessWidget {
  final logic = Get.find<EMandateSuccessLogic>();

  EMandateSuccessView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text("Your Auto-Pay registration is",
              textAlign: TextAlign.center,
              style: TextStyle(
              color: greenTextColor,
              fontSize: 20,
              letterSpacing: 0.15
            ),),
            const SizedBox(height: 10,),
            const Text("Successful!",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                  color: greenTextColor,
                  fontSize: 24,
                  letterSpacing: 0.18
              ),),
            const SizedBox(height: 80,),
            SvgPicture.asset(Res.e_mandate_success)
          ],
        ),
      )),
    );
  }
}
