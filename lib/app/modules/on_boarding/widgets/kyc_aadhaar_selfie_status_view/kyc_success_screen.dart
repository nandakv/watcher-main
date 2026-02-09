import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:privo/app/common_widgets/polling_title_widget.dart';
import 'package:privo/app/common_widgets/vertical_spacer.dart';
import 'package:privo/app/services/lpc_service.dart';
import 'package:privo/app/theme/app_colors.dart';
import 'package:privo/app/utils/multi_lpc_faq.dart';
import 'package:privo/res.dart';

import 'kyc_verification_logic.dart';

class KycSuccessScreen extends StatelessWidget {
  KycSuccessScreen({Key? key}) : super(key: key);

  final logic = Get.find<KycVerificationLogic>();

  Widget _appBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        _helpButton(),
        horizontalSpacer(4),
        _closeButton(),
        horizontalSpacer(14),
      ],
    );
  }

  Widget _helpButton() {
    return InkWell(
      onTap: () {
        MultiLPCFaq(
          lpcCard: LPCService.instance.activeCard,
        ).openMultiLPCBottomSheet(
          onPressContinue: () {},
        );
      },
      child: SvgPicture.asset(Res.helpAppBar),
    );
  }

  Widget _closeButton() {
    return SizedBox(
      width: 35,
      child: IconButton(
        onPressed: Get.back,
        icon: const Icon(
          Icons.clear_rounded,
          color: appBarTitleColor,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      color: Colors.white,
      child: Column(
        children: [
          _appBar(),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Spacer(),
                  const PollingTitleWidget(title: "Congratulations!"),
                  const SizedBox(
                    height: 16,
                  ),
                  const Text(
                    "Your KYC verification is successful.",
                    style: TextStyle(
                      fontWeight: FontWeight.w300,
                      fontSize: 12,
                      color: darkBlueColor,
                    ),
                  ),
                  const Spacer(),
                  SvgPicture.asset(Res.kycSuccessfull),
                  const Spacer(
                    flex: 4,
                  ),
                  // GradientButton(
                  //   onPressed: logic.continueToLineAgreement,
                  //   title: "Continue to Line Agreement",
                  // ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
