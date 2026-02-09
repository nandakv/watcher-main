import 'package:after_layout/after_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:privo/app/common_widgets/blue_button.dart';

import '../../../../../res.dart';
import 'e_sign_logic.dart';

class ESignScreen extends StatefulWidget {
  ESignScreen({Key? key}) : super(key: key);

  @override
  State<ESignScreen> createState() => _ESignScreenState();
}

class _ESignScreenState extends State<ESignScreen> with AfterLayoutMixin {
  final logic = Get.find<ESignLogic>();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ESignLogic>(
        id: 'page',
        builder: (logic) {
          return logic.isPageLoading
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 45.16),
                      child: Text(
                        logic.eSignAgreementLine(),
                        textAlign: TextAlign.center,
                        style: _titleTextStyle,
                      ),
                    ),
                    Expanded(child: SvgPicture.asset(Res.e_sign)),
                    const SizedBox(
                      height: 47,
                    ),
                    GetBuilder<ESignLogic>(
                        id: 'button',
                        builder: (logic) {
                          return Center(
                              child: BlueButton(
                            onPressed: () => logic.onESignContinueTapped(),
                            buttonColor: const Color(0xFF004097),
                            title: "Continue",
                            isLoading: logic.isButtonLoading,
                          ));
                        }),
                    const SizedBox(
                      height: 43,
                    ),
                  ],
                );
        });
  }

  TextStyle get _titleTextStyle {
    return const TextStyle(fontSize: 18, color: Color(0xFF363840));
  }

  @override
  void afterFirstLayout(BuildContext context) {
    logic.onAfterLayout();
  }
}
