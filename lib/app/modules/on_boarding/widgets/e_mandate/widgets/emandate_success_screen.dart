import 'package:privo/app/modules/on_boarding/on_boarding_logic.dart';
import 'package:privo/app/modules/on_boarding/widgets/e_mandate/e_mandate_logic.dart';
import 'package:privo/app/theme/app_colors.dart';
import 'package:privo/res.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

///This class shows e mandate success page with an illustration

class EMandateSuccessScreen extends StatelessWidget {
  final logic = Get.find<EMandateLogic>();

  EMandateSuccessScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgPicture.asset(Res.registered_svg),
            const SizedBox(
              height: 30,
            ),
            const Text(
              "Your E-Mandate registration is Successful!",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: darkBlueColor,
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
    );
  }
}