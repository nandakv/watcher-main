import 'package:after_layout/after_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:privo/app/common_widgets/gradient_button.dart';
import 'package:privo/res.dart';

import '../../../../common_widgets/safe_and_encrypted_info_widget.dart';
import '../../../../theme/app_colors.dart';
import 'digio_digilocker_aadhaar_logic.dart';

class DigioDigilockerAadhaarView extends StatefulWidget {
  const DigioDigilockerAadhaarView({
    Key? key,
  }) : super(key: key);

  @override
  State<DigioDigilockerAadhaarView> createState() =>
      _DigioDigilockerAadhaarViewState();
}

class _DigioDigilockerAadhaarViewState extends State<DigioDigilockerAadhaarView>
    with AfterLayoutMixin {
  final logic = Get.find<DigioDigilockerAadhaarLogic>();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<DigioDigilockerAadhaarLogic>(
      id: logic.PAGE_ID,
      builder: (logic) {
        return logic.isPageLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : _digioHomePageWidget();
      },
    );
  }

  Widget _digioHomePageWidget() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SvgPicture.asset(
                    Res.digio_page_placeholder_svg,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  FittedBox(
                    child: Text(
                      "${logic.firstName}, your Aadhaar verification failed",
                      maxLines: 1,
                      style: const TextStyle(
                        color: Color(0xff1D478E),
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  const Text(
                    'because the UIDAI website is currently down',
                    style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: Color(0xff1D478E)),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  _digiLockerInfoWidget(),
                  const SizedBox(
                    height: 15,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          const SafeAndEncryptedInfoWidget(),
          const SizedBox(
            height: 15,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            child: GetBuilder<DigioDigilockerAadhaarLogic>(
              id: logic.BUTTON_ID,
              builder: (logic) {
                return GradientButton(
                  onPressed: logic.startDigioSDK,
                  isLoading: logic.isButtonLoading,
                  title: "Verify my aadhaar",
                );
              },
            ),
          ),
          const SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }

  Container _digiLockerInfoWidget() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 5),
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: const [
          BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 0.16),
            blurRadius: 2,
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(
            height: 10,
          ),
          const Text(
            'Verify your Aadhaar with',
            style: TextStyle(
              color: Color(0xff1D478E),
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          SvgPicture.asset(Res.digi_locker_logo_svg),
          const SizedBox(
            height: 10,
          ),
          const Text(
            'from Govt. of India',
            style: TextStyle(
              color: Color(0xff707070),
              fontWeight: FontWeight.w400,
              fontSize: 8,
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          _infoWidget(),
        ],
      ),
    );
  }

  _infoWidget() {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xffFFF3EB),
        borderRadius: BorderRadius.only(
          bottomRight: Radius.circular(8),
          bottomLeft: Radius.circular(8),
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 11),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildBulbIcon(),
          const SizedBox(
            width: 8,
          ),
          const Expanded(
            child: Text(
              "Don’t have an DigiLocker account yet?\nRegister with Aadhaar and PAN number on the go",
              style: TextStyle(
                  color: appBarTitleColor,
                  fontSize: 10,
                  letterSpacing: 0.16,
                  fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }

  Container _buildBulbIcon() {
    return Container(
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: appBarTitleColor,
      ),
      padding: const EdgeInsets.all(6),
      child: SvgPicture.asset(Res.info_bulb),
    );
  }

  @override
  void afterFirstLayout(BuildContext context) {
    logic.onDigioDigilockerAfterLayout();
  }
}
