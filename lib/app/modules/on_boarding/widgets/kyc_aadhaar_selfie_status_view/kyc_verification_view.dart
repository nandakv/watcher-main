import 'package:after_layout/after_layout.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:privo/app/common_widgets/gradient_button.dart';
import 'package:privo/app/common_widgets/powered_by_cs_icon.dart';
import 'package:privo/app/common_widgets/spacer_widgets.dart';
import 'package:privo/app/common_widgets/vertical_spacer.dart';
import 'package:privo/app/modules/on_boarding/widgets/aadhaar_api/aadhaar_api_screen.dart';
import 'package:privo/app/modules/on_boarding/widgets/digio_digilocker_aadhaar/digio_digilocker_aadhaar_view.dart';
import 'package:privo/app/modules/on_boarding/widgets/kyc_aadhaar_selfie_status_view/kyc_success_screen.dart';
import 'package:privo/app/modules/on_boarding/widgets/kyc_aadhaar_selfie_status_view/widgets/aadhaar_verification_options_widget.dart';
import 'package:privo/app/modules/on_boarding/widgets/kyc_aadhaar_selfie_status_view/widgets/kyc_steps_status_widget.dart';
import 'package:privo/app/modules/on_boarding/widgets/kyc_aadhaar_selfie_status_view/widgets/kyc_transition_widget.dart';
import 'package:privo/app/theme/app_colors.dart';
import 'package:privo/res.dart';

import '../../../../common_widgets/animated_text_widget.dart';
import '../../../../common_widgets/safe_and_encrypted_info_widget.dart';
import '../../../../firebase/analytics.dart';
import '../../../../utils/web_engage_constant.dart';
import 'kyc_verification_logic.dart';

class KycVerificationView extends StatefulWidget {
  final KycVerificationState userState;

  const KycVerificationView({Key? key, required this.userState})
      : super(key: key);

  @override
  State<KycVerificationView> createState() => _KycVerificationViewState();
}

class _KycVerificationViewState extends State<KycVerificationView>
    with AfterLayoutMixin {
  final logic = Get.put(KycVerificationLogic());

  @override
  Widget build(BuildContext context) {
    return GetBuilder<KycVerificationLogic>(
      builder: (logic) {
        return Column(
          children: [
            const VerticalSpacer(22),
            Expanded(
              child: _bodyWidget(logic),
            ),
            if (logic.showPoweredByCS())
              const Padding(
                padding: EdgeInsets.only(bottom: 20),
                child: PoweredByCSIcon(),
              )
          ],
        );
      },
    );
  }

  Widget _bodyWidget(KycVerificationLogic logic) {
    switch (logic.kycVerificationState) {
      case KycVerificationState.loading:
        return const Center(
          child: CircularProgressIndicator(),
        );
      case KycVerificationState.aadhaar:
      case KycVerificationState.selfie:
      case KycVerificationState.vKYC:
      case KycVerificationState.polling:
        return _kycStepperScreen(logic);
      case KycVerificationState.aadharDetails:
        AppAnalytics.trackWebEngageEventWithAttribute(
            eventName: WebEngageConstants.kycLoaded);
        return AadhaarApiScreen();
      case KycVerificationState.aadharMethodSelection:
        return const AadhaarVerificationOptionsWidget();
      case KycVerificationState.digioDigilocker:
        return const DigioDigilockerAadhaarView();
      case KycVerificationState.kycSuccess:
        return KycSuccessScreen();
      case KycVerificationState.vkycToSelfie:
        return const KYCTransitionWidget(
          title: "Video KYC Attempts Reached",
          message:
              "It seems you have exhausted your video KYC attempts. No worries!",
          imagePath: Res.vkycAttemptsReached,
          bottomText: "Redirecting you to Selfie KYC now...",
        );
      case KycVerificationState.okycExpiredToSelfie:
        return const KYCTransitionWidget(
          title: "Hold Tight!",
          message: "Taking you to an easier Selfie flow",
          bottomText: "Redirecting you to Selfie KYC now...",
          imagePath: Res.okycExpired,
        );
      case KycVerificationState.okycExpiredToAadhaar:
        return const KYCTransitionWidget(
          title: "Hold Tight!",
          message: "Taking you to an easier Aadhaar flow",
          bottomText: "Redirecting you to Aadhaar KYC now...",
          imagePath: Res.okycExpired,
        );
    }
  }

  Widget _kycStepperScreen(KycVerificationLogic logic) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 35),
      child: Column(
        children: [
          Expanded(
            flex: 15,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  titleWidget("Complete your KYC"),
                  verticalSpacer(40),
                  KycStepsStatusWidget(),
                  verticalSpacer(20),
                ],
              ),
            ),
          ),
          verticalSpacer(10),
          const SafeAndEncryptedInfoWidget(),
          verticalSpacer(24),
          GradientButton(
            onPressed: logic.computeButtonAction,
            isLoading: logic.isLoading,
            title: logic.computeButtonTitle(),
            enabled: logic.buttonEnabled,
          ),
          _computeBottomText(),
          verticalSpacer(10),
        ],
      ),
    );
  }

  Widget titleWidget(String title) {
    return Text(
      title,
      style: GoogleFonts.poppins(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: darkBlueColor,
      ),
    );
  }

  Widget _computeBottomText() {
    switch (logic.kycVerificationState) {
      case KycVerificationState.vKYC:
        return logic.isLoading
            ? Center(
                child: _vkycTryAgainCTA(),
              )
            : const SizedBox();
      case KycVerificationState.polling:
        AppAnalytics.trackWebEngageEventWithAttribute(
            eventName: WebEngageConstants.kycProcessingScreen);
        return const AnimatedTextWidget(
          flex: 1,
          bodyTexts: [
            "We’re getting to know you ;)",
            "On our best days, this will only take 15 seconds.",
            "So, stay with us"
          ],
          textStyle: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.normal,
              letterSpacing: 0.19,
              color: accountSummaryTitleColor),
        );
      case KycVerificationState.aadharDetails:
      case KycVerificationState.digioDigilocker:
      case KycVerificationState.aadharMethodSelection:
      case KycVerificationState.aadhaar:
      case KycVerificationState.selfie:
      case KycVerificationState.kycSuccess:
      case KycVerificationState.loading:
      case KycVerificationState.vkycToSelfie:
      case KycVerificationState.okycExpiredToSelfie:
      case KycVerificationState.okycExpiredToAadhaar:
        return const SizedBox();
    }
  }

  GetBuilder<KycVerificationLogic> _vkycTryAgainCTA() {
    return GetBuilder<KycVerificationLogic>(
      id: logic.VKYC_TRY_AGAIN_CTA_ID,
      builder: (logic) {
        return logic.isRequestingVKYC
            ? const SizedBox()
            : GradientButton(
                onPressed: () => logic.initiateVKYC(false),
                title: "Try Again",
              );
      },
    );
  }

  TextStyle _highLightTextStyle() {
    return GoogleFonts.poppins(
        fontSize: 14,
        letterSpacing: 0.11,
        color: darkBlueColor,
        fontWeight: FontWeight.w600);
  }

  TextSpan get selfieTextSpan =>
      TextSpan(text: 'Selfie', style: _highLightTextStyle());

  TextSpan get vKYCTextSpan =>
      TextSpan(text: 'Video-KYC', style: _highLightTextStyle());

  @override
  void afterFirstLayout(BuildContext context) {
    logic.onAfterLayout(widget.userState);
  }
}
