import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../../res.dart';
import '../../../../../theme/app_colors.dart';
import '../kyc_verification_logic.dart';
import '../model/kyc_step_model.dart';

enum KycStepperLocation { bottomSheet, fullScreen }

class KycStepsStatusWidget extends StatelessWidget {
  final KycStepperLocation kycStepperLocation;

  KycStepsStatusWidget({
    Key? key,
    this.kycStepperLocation = KycStepperLocation.fullScreen,
  }) : super(key: key);

  final logic = Get.find<KycVerificationLogic>();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<KycVerificationLogic>(
      id: logic.APP_STEPPER_ID,
      builder: (logic) {
        return ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            String step = logic.kycSteppers[index];
            switch (step.toUpperCase()) {
              case "AADHAAR":
                return _kycStep(kycStep: _computeAadhaarKycStep());
              case "SELFIE":
                return _kycStep(kycStep: _computeSelfieVKYCTextSpan());
              case "VKYC":
                return _kycStep(
                  kycStep: _computeSelfieVKYCTextSpan(
                    isVKYC: true,
                  ),
                );
              default:
                return _kycStep(kycStep: _computeAadhaarKycStep());
            }
          },
          separatorBuilder: (context, index) {
            return Align(
              alignment: Alignment.centerLeft,
              child: _verticalDivider(),
            );
          },
          itemCount: logic.kycSteppers.length,
        );
      },
    );
  }

  Widget _verticalDivider() {
    return SizedBox(
      height: kycStepperLocation == KycStepperLocation.fullScreen ? 125 : 90,
      child: const VerticalDivider(
        indent: 18,
        endIndent: 18,
        thickness: 1,
        color: darkBlueColor,
        width: 98,
      ),
    );
  }

  KycStepModel _computeAadhaarKycStep() {
    late TextSpan textSpan;
    late bool isVerified;
    switch (logic.kycVerificationState) {
      case KycVerificationState.loading:
      case KycVerificationState.aadhaar:
      case KycVerificationState.aadharDetails:
      case KycVerificationState.digioDigilocker:
      case KycVerificationState.aadharMethodSelection:
        isVerified = false;
        textSpan = _verifyYourAadhaarTextSpan();
        break;
      case KycVerificationState.selfie:
      case KycVerificationState.vKYC:
      case KycVerificationState.kycSuccess:
      case KycVerificationState.polling:
        isVerified = true;
        textSpan = _aadhaarVerifiedTextSpan();
        break;
      default:
        textSpan = const TextSpan();
        isVerified = false;
        break;
    }
    return KycStepModel(
      textSpan: textSpan,
      isVerified: isVerified,
      iconPath: Res.aadharIcon,
    );
  }

  TextSpan _verifyYourAadhaarTextSpan() {
    return TextSpan(
      children: <TextSpan>[
        if (logic.showStepText) TextSpan(text: "Step 1", style: _stepTextStyle()),
        TextSpan(text: "\nVerify Your", style: _titleTextStyle()),
        TextSpan(text: ' Aadhaar', style: _highLightTextStyle()),
        TextSpan(
            text:
                ' \nComplete your verification using DigiLocker or an OTP sent to your mobile number linked to Aadhaar',
            style: _subTitleTextStyle()),
      ],
    );
  }

  TextSpan _aadhaarVerifiedTextSpan() {
    return TextSpan(
      children: <TextSpan>[
        if (logic.showStepText) TextSpan(text: "Step 1", style: _stepTextStyle()),
        TextSpan(text: "\nYour", style: _titleTextStyle()),
        TextSpan(text: ' Aadhaar', style: _highLightTextStyle()),
        TextSpan(text: " has been verified", style: _titleTextStyle()),
      ],
    );
  }

  TextStyle _stepTextStyle() {
    return const TextStyle(
        fontSize: 12, height: 1.6, color: secondaryDarkColor);
  }

  Widget _verifiedTextWidget() {
    return Container(
      decoration: BoxDecoration(
        color: verifiedGreenColor,
        borderRadius: BorderRadius.circular(50),
      ),
      margin: const EdgeInsets.only(top: 10),
      child: const Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 4,
        ),
        child: Text(
          'VERIFIED',
          style: TextStyle(
            fontFamily: 'Figtree',
            fontWeight: FontWeight.w400,
            fontSize: 10,
            color: offWhiteColor,
          ),
        ),
      ),
    );
  }

  KycStepModel _computeSelfieVKYCTextSpan({bool isVKYC = false}) {
    late TextSpan textSpan;
    late bool isVerified;
    switch (logic.kycVerificationState) {
      case KycVerificationState.loading:
      case KycVerificationState.aadhaar:
      case KycVerificationState.aadharDetails:
      case KycVerificationState.aadharMethodSelection:
      case KycVerificationState.digioDigilocker:
      case KycVerificationState.selfie:
      case KycVerificationState.vKYC:
        isVerified = false;
        textSpan = isVKYC ? _beReadyVKYCTextSpan() : _beReadySelfieTextSpan();
        break;
      case KycVerificationState.kycSuccess:
      case KycVerificationState.polling:
        isVerified = true;
        textSpan = _processingIdentityVerificationTextSpan();
        break;
      default:
        textSpan = const TextSpan();
        isVerified = false;
        break;
    }

    return KycStepModel(
      textSpan: textSpan,
      isVerified: isVerified,
      iconPath: Res.selfieIcon,
    );
  }

  TextSpan _beReadyVKYCTextSpan() {
    return TextSpan(
      children: [
        if (logic.showStepText) TextSpan(text: "Step 2", style: _stepTextStyle()),
        TextSpan(text: "\nBe Ready for", style: _titleTextStyle()),
        TextSpan(text: ' Video KYC', style: _highLightTextStyle()),
        TextSpan(
            text:
                ' \nVerify your identity through a live video call with our verification team\n',
            style: _subTitleTextStyle()),
        if (logic.isLoading)
          const WidgetSpan(child: SizedBox())
        else if (logic.computeVkycNonAvailabilityBadge())
          ..._availableTimeTextWidgetSpan(),
      ],
    );
  }

  List<InlineSpan> _availableTimeTextWidgetSpan() {
    return [
      const WidgetSpan(
        child: SizedBox(
          height: 35,
        ),
      ),
      WidgetSpan(
        child: Container(
          decoration: BoxDecoration(
            color: offWhiteColor,
            borderRadius: BorderRadius.circular(50),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            child: RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text:
                        'Available from ${logic.vkycAvailability?.fromTime} - ${logic.vkycAvailability?.toTime}',
                    style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w400,
                      color: darkBlueColor,
                      fontFamily: 'Figtree',
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      )
    ];
  }

  TextSpan _beReadySelfieTextSpan() {
    return TextSpan(
      children: <TextSpan>[
        if (logic.showStepText) TextSpan(text: "Step 2", style: _stepTextStyle()),
        TextSpan(text: "\nBe Ready for", style: _titleTextStyle()),
        TextSpan(text: ' Selfie', style: _highLightTextStyle()),
        TextSpan(
            text: ' \nComplete your KYC verification by taking a selfie ',
            style: _subTitleTextStyle()),
      ],
    );
  }

  TextSpan _processingIdentityVerificationTextSpan() {
    return TextSpan(
      children: <TextSpan>[
        if (logic.showStepText) TextSpan(text: "Step 2", style: _stepTextStyle()),
        TextSpan(text: "\nProcessing Your ", style: _titleTextStyle()),
        TextSpan(text: ' Identity Verification', style: _highLightTextStyle()),
      ],
    );
  }

  Widget _kycStep({required KycStepModel kycStep}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Stack(
          alignment: Alignment.bottomCenter,
          children: [
            Padding(
              padding: EdgeInsets.only(bottom: kycStep.isVerified ? 10.0 : 0),
              child: SvgPicture.asset(kycStep.iconPath),
            ),
            if (kycStep.isVerified) _verifiedTextWidget(),
          ],
        ),
        const SizedBox(
          width: 16,
        ),
        Expanded(
          child: RichText(
            text: kycStep.textSpan,
          ),
        ),
      ],
    );
  }

  TextStyle _highLightTextStyle() {
    return GoogleFonts.poppins(
        fontSize: 14,
        letterSpacing: 0.11,
        color: darkBlueColor,
        fontWeight: FontWeight.w600);
  }

  TextStyle _titleTextStyle() {
    return GoogleFonts.poppins(
        fontSize: 14, letterSpacing: 0.11, color: accountSummaryTitleColor);
  }

  TextStyle _subTitleTextStyle() {
    return TextStyle(
      fontFamily: 'Figtree',
      fontSize: kycStepperLocation == KycStepperLocation.fullScreen ? 12 : 10,
      letterSpacing: 0.16,
      color: secondaryDarkColor,
    );
  }

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
}
