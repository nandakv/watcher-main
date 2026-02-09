import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:privo/app/common_widgets/consent_text_widget.dart';
import 'package:privo/app/common_widgets/gradient_button.dart';
import 'package:privo/app/common_widgets/vertical_spacer.dart';

import '../../../../../../res.dart';
import '../../../../../common_widgets/on_boarding_step_widget.dart';
import '../../../../../common_widgets/safe_and_encrypted_info_widget.dart';
import '../../../../../theme/app_colors.dart';
import '../../digio_digilocker_aadhaar/digio_digilocker_aadhaar_logic.dart';
import '../kyc_verification_logic.dart';
import 'aadhaar_selection_tile.dart';

class AadhaarVerificationOptionsWidget extends StatefulWidget {
  const AadhaarVerificationOptionsWidget({
    Key? key,
  }) : super(key: key);

  @override
  State<AadhaarVerificationOptionsWidget> createState() =>
      _AadhaarVerificationOptionsWidgetState();
}

class _AadhaarVerificationOptionsWidgetState
    extends State<AadhaarVerificationOptionsWidget> {
  final logic = Get.find<KycVerificationLogic>();
  final digiLogic = Get.find<DigioDigilockerAadhaarLogic>();

  Widget titleWidget(String title) {
    return Text(
      title,
      style: GoogleFonts.poppins(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: navyBlueColor,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<KycVerificationLogic>(builder: (logic) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25),
        child: Column(
          children: [
            verticalSpacer(30),
            Expanded(
              child: SingleChildScrollView(
                child: _aadhaarMethodSelectionWidget(),
              ),
            ),
            verticalSpacer(12),
            const SafeAndEncryptedInfoWidget(),
            verticalSpacer(12),
            _consentCheckBoxWithText(),
            verticalSpacer(14),
            _ctaButton(),
            verticalSpacer(10),
          ],
        ),
      );
    });
  }

  Widget _consentCheckBoxWithText() {
    return GetBuilder<DigioDigilockerAadhaarLogic>(
        id: digiLogic.CONSENT_CHECK_BOX,
        builder: (logic) {
      return Visibility(
        visible: !logic.isButtonLoading,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: ConsentTextWidget(
            value: logic.checkBoxValue,
            onChanged: (logic.isButtonLoading)
                ? null
                : (value) {
              if (value != null) {
                logic.checkBoxValue = value;
              }
            },
            letterSpacing: 0.14,
            horizontalGap: 5,
            horizontalPadding: 0,
            consentText:
            'I allow Kisetsu Saison Finance (India) Private Limited to fetch my Aadhaar XML details from Digilocker or UIDAI.',
            checkBoxState: CheckBoxState.postRegCheckBox,
          ),
        ),
      );
    });
  }

  Widget _aadhaarMethodSelectionWidget() {
    return GetBuilder<KycVerificationLogic>(
        id: logic.AADHAAR_SELECTION_ID,
        builder: (logic) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              OnBoardingStepWidget(
                currentStep: 1,
                totalSteps: 2,
                onInfoTap: logic.onStepInfoClicked,
                title: "Aadhaar Verification",
                showStepOfText: logic.showStepText,
              ),
              verticalSpacer(24),
              // const Text(
              //   "Choose your method",
              //   style: TextStyle(
              //     fontWeight: FontWeight.w500,
              //     fontSize: 12,
              //   ),
              // ),
              // verticalSpacer(16),
              _digilockerSelectionTile(),
              verticalSpacer(16),
              // _aadhaarOTPSelectionTile(),
            ],
          );
        });
  }

  Widget _aadhaarOTPSelectionTile() {
    return AadhaarSelectionTile(
      verificationType: AadhaarVerificationType.aadhaarOtp,
      infoList: const [
        "Fetch your Aadhaar Card through mobile OTP",
        "Takes less than 30 seconds"
      ],
      bottomInfo: "We use UIDAI which is a trusted government body.",
      title: "Aadhaar OTP",
      logoWidget: Image.asset(
        Res.aadhaarLogo,
        width: 30,
        height: 20,
      ),
    );
  }

  Widget _digilockerSelectionTile() {
    return AadhaarSelectionTile(
      verificationType: AadhaarVerificationType.digilocker,
      // isRecommended: true,
      infoList: const [
        "Digitally fetch your Aadhaar Card via DigiLocker",
        "Takes 2 minutes"
      ],
      bottomInfo:
      "DigiLocker is a flagship initiative of Ministry of Electronics & IT",
      title: "DigiLocker",
      logoWidget: SvgPicture.asset(
        Res.digi_locker_logo_svg,
        width: 60,
        height: 15,
      ),
    );
  }

  Widget _ctaButton() {
    return GetBuilder<DigioDigilockerAadhaarLogic>(
      id: digiLogic.BUTTON_ID,
      builder: (digiLogic) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5),
          child: GradientButton(
            onPressed: logic.storeAadharConsent,
            isLoading: digiLogic.isButtonLoading,
            enabled: digiLogic.checkBoxValue,
          ),
        );
      },
    );
  }
}
