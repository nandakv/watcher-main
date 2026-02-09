import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:privo/app/common_widgets/limit_progress_indicator.dart';
import 'package:privo/app/modules/on_boarding/widgets/credit_line_approved/credit_line_approved_logic.dart';
import 'package:privo/app/theme/app_colors.dart';
import 'package:privo/app/utils/app_functions.dart';
import 'package:privo/app/theme/app_colors.dart';
import 'package:privo/app/utils/ui_constant_text.dart';

class SetupCreditLineWidget extends StatelessWidget {
  SetupCreditLineWidget({Key? key, required this.logic}) : super(key: key);

  CreditLineApprovedLogic logic;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Align(
          alignment: Alignment.topRight,
          child: IconButton(
            onPressed: () => Get.back(),
            icon: const Icon(
              Icons.clear_rounded,
              color: infoTextColor,
              size: 20,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20,),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(
                height: 16,
              ),
              Flexible(
                child: Text(
                  congratulation,
                  style: titleTextStyle,
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              Flexible(
                child: Text(
                  creditLineSubTitle,
                  textAlign: TextAlign.center,
                  style: _subTitleTextStyle(),
                ),
              ),
              const SizedBox(
                height: 32,
              ),
              _buttonAndHelpText(logic.approvedLimit),
              const SizedBox(
                height: 40,
              ),
            ],
          ),
        )
      ],
    );
  }

  Widget _buttonAndHelpText(double amount) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 30),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          LimitProgressIndicator(
            strokeWidth: 10,
          ),
          const SizedBox(width: 38,),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Flexible(
                  child: Text(
                    "Your available limit",
                    //textAlign: TextAlign.center,
                    style: _subTitleTextStyle(),
                  ),
                ),
                FittedBox(
                  child: Text(
                    AppFunctions.getIOFOAmount(amount),
                    style: amountTextStyle(fontSize: 25,),
                  ),
                ),
                Flexible(
                  child: Text(
                    "at ${logic.roi}% ROI",
                    //    textAlign: TextAlign.center,
                    style: _subTitleTextStyle().copyWith(fontWeight: FontWeight.w500),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  TextStyle _subTitleTextStyle() {
    return const TextStyle(
        fontSize: 12, color: Color(0xffFFF3EB), fontWeight: FontWeight.normal);
  }

  TextStyle get titleTextStyle {
    return GoogleFonts.poppins(
      fontSize: 24,
      fontWeight: FontWeight.w600,
      letterSpacing: 0.58,
      color:  skyBlueColor,
    );
  }

  TextStyle amountTextStyle({required double fontSize}) {
    return GoogleFonts.poppins(
      fontSize: fontSize,
      letterSpacing: 0.3,
      fontWeight: FontWeight.bold,
      color: const Color(0xffFFF3EB),
    );
  }
}