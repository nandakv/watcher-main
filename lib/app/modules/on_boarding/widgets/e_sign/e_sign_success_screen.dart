import 'package:privo/res.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../on_boarding_logic.dart';

class ESignSuccessScreen extends StatelessWidget {
  ESignSuccessScreen({Key? key}) : super(key: key);
  final logic = Get.find<OnBoardingLogic>();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 30),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            "E sign successful!",
            style: TextStyle(
                color: Color(0xFF0E9823),
                fontSize: 24,
                letterSpacing: 0.84),
          ),
          const Padding(
            padding: EdgeInsets.only(left: 33, right: 33, top: 24),
            child: Text(
              "Loan Agreement has been sent to your registered email address",
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Color(0xFF344157),
                  fontSize: 16,
                  letterSpacing: 0.12),
            ),
          ),
          const SizedBox(
            height: 30,
          ),
          SvgPicture.asset(
            Res.e_sign_verified,
          )
        ],
      ),
    );
  }
}
