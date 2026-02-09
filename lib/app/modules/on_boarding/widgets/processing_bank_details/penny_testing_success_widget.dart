import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:privo/app/common_widgets/polling_title_widget.dart';
import 'package:privo/app/modules/on_boarding/widgets/processing_bank_details/processing_bank_details_logic.dart';
import 'package:privo/app/theme/app_colors.dart';
import 'package:privo/res.dart';

class PennyTestingSuccessWidget extends StatelessWidget {
  PennyTestingSuccessWidget({Key? key}) : super(key: key);

  final logic = Get.find<ProcessingBankDetailsLogic>();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const PollingTitleWidget(title: "Account verification"),
            const SizedBox(
              height: 5,
            ),
            const PollingTitleWidget(title: "Successful"),
            const SizedBox(
              height: 20,
            ),
            Flexible(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 70),
                child: Text(
                  logic.getSuccessMessage(),
                  textAlign: TextAlign.center,
                  style: secondLineTextStyle(),
                ),
              ),
            ),
            const SizedBox(
              height: 50,
            ),
            Align(
              alignment: Alignment.topRight,
              child: SvgPicture.asset(
                Res.accountVerificationSuccess,
                alignment: Alignment.centerRight,
              ),
            ),
          ],
        ),
      ),
    );
  }

  TextStyle secondLineTextStyle() {
    return const TextStyle(
        fontSize: 12,
        letterSpacing: 0.19,
        fontStyle: FontStyle.normal,
        fontWeight: FontWeight.w500,
        color: darkBlueColor);
  }
}
