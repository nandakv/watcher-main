import 'package:intl/intl.dart';
import 'package:privo/app/common_widgets/app_button.dart';
import 'package:privo/app/common_widgets/blue_button.dart';
import 'package:privo/app/modules/on_boarding/widgets/upl_withdrawal_loading/upl_withdrawal_loading_logic.dart';
import 'package:privo/app/theme/app_colors.dart';
import 'package:privo/app/utils/app_functions.dart';
import 'package:privo/res.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class UPLWithdrawSuccess extends StatelessWidget {
  UPLWithdrawSuccess({Key? key}) : super(key: key);

  final logic = Get.find<UPLWithdrawalLoadingLogic>();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const Text(
            "Transfer successful!",
            style: TextStyle(
              fontSize: 24,
              color: Color(0xff33A344),
              fontWeight: FontWeight.w600,
              letterSpacing: 0.18,
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 33),
            child: Text(
              "We have transferred 250000 to your bank account",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: Colors.black),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 45),
            child: SvgPicture.asset(Res.wIthdrawal_success),
          ),

          ///Withdraw button
          AppButton(
            onPressed: logic.onSuccessPressed,
            title: "Confirm",
          )
        ],
      ),
    );
  }
}
