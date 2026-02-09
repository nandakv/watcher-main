import 'package:after_layout/after_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:privo/app/common_widgets/blue_button.dart';
import 'package:privo/app/modules/on_boarding/widgets/aadhaar/aadhaar_logic.dart';
import 'package:privo/app/theme/app_colors.dart';
import 'package:privo/res.dart';

class AadhaarScreen extends StatefulWidget {
  AadhaarScreen({Key? key}) : super(key: key);

  @override
  State<AadhaarScreen> createState() => _AadhaarScreenState();
}

class _AadhaarScreenState extends State<AadhaarScreen> with AfterLayoutMixin {
  final logic = Get.find<AadhaarLogic>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: GetBuilder<AadhaarLogic>(
          builder: (logic) => logic.isPageLoading
              ? const Center(
                  child: SizedBox(
                    width: 30,
                    height: 30,
                    child: CircularProgressIndicator(),
                  ),
                )
              : Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        flex: 1,
                        child: Text(
                          "Unable to fetch your CKYC details",
                          textAlign: TextAlign.center,
                          style: titleTextStyle(),
                        ),
                      ),
                      Flexible(
                          flex: 2,
                          child: SvgPicture.asset(Res.CKYC_missing)),
                      Flexible(
                        flex: 1,
                        child: Text(
                          "Please proceed with Aadhaar to complete your KYC verification",
                          textAlign: TextAlign.center,
                          style: bodyTextStyle(),
                        ),
                      ),
                      Flexible(
                        flex: 1,
                        child: BlueButton(
                          onPressed: logic.onAadhaarXML,
                          buttonColor: activeButtonColor,
                        ),
                      ),
                    ],
                  ),
              ),
        ),
      ),
    );
  }

  TextStyle bodyTextStyle() {
    return const TextStyle(
        color: titleTextColor, fontSize: 14, letterSpacing: 0.11);
  }

  TextStyle titleTextStyle() {
    return const TextStyle(
        color: Color(0xffD54A39), fontSize: 16, letterSpacing: 0.15);
  }

  @override
  void afterFirstLayout(BuildContext context) {
    logic.onAfterLayout();
  }
}
