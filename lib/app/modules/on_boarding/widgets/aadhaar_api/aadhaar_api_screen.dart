import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:pinput/pinput.dart';
import 'package:privo/app/common_widgets/consent_text_widget.dart';
import 'package:privo/app/common_widgets/gradient_button.dart';
import 'package:privo/app/common_widgets/otp_resend_widget/otp_resend_widget_view.dart';
import 'package:privo/app/common_widgets/vertical_spacer.dart';
import 'package:privo/app/modules/on_boarding/widgets/aadhaar_api/aadhaar_field_validator.dart';
import 'package:privo/app/utils/no_leading_space_formatter.dart';

import '../../../../../res.dart';
import '../../../../common_widgets/forms/base_field_validator.dart';
import '../../../../common_widgets/on_boarding_step_widget.dart';
import '../../../../common_widgets/privo_text_form_field/privo_text_form_field.dart';
import '../../../../common_widgets/safe_and_encrypted_info_widget.dart';
import '../../../../theme/app_colors.dart';
import '../kyc_aadhaar_selfie_status_view/kyc_verification_logic.dart';
import 'aadhaar_api_logic.dart';

class AadhaarApiScreen extends StatelessWidget
    with AadhaarFieldValidators {
  AadhaarApiScreen({
    Key? key,
  }) : super(key: key);

  final logic = Get.find<AadhaarApiLogic>();
  final kycLogic = Get.find<KycVerificationLogic>();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AadhaarApiLogic>(
      builder: (logic) {
        return _aadhaarFormWidget(logic);
      },
    );
  }

  Widget _progressStepWidget() {
    return OnBoardingStepWidget(
      currentStep: 1,
      totalSteps: 2,
      onInfoTap: kycLogic.onStepInfoClicked,
      title: "Aadhaar Verification",
      showStepOfText: kycLogic.showStepText,
    );
  }

  Widget _aadhaarFormWidget(AadhaarApiLogic logic) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Form(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                key: logic.aadhaarApiFormKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    verticalSpacer(30),
                    _progressStepWidget(),
                    verticalSpacer(40),
                    const Text(
                      "Aadhaar Number",
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 12,
                      ),
                    ),
                    verticalSpacer(8),
                    _aadhaarInputTextField(logic),
                    verticalSpacer(14),
                    _aadhaarInputInfoText(),
                    if (logic.showOTPField) ..._onShowOtpField()
                  ],
                ),
              ),
            ),
          ),
          verticalSpacer(10),
          _aadhaarLogo(),
          verticalSpacer(10),
          const SafeAndEncryptedInfoWidget(),
          verticalSpacer(24),
          _ctaButton(),
          verticalSpacer(10),
        ],
      ),
    );
  }

  Center _aadhaarLogo() {
    return Center(
      child: Image.asset(
        Res.aadhaarLogo,
        height: 40,
        width: 60,
      ),
    );
  }

  Widget _ctaButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: GradientButton(
        onPressed: () {
          logic.onAadhaarContinue();
        },
        title: "Continue",
        isLoading: logic.isLoading,
        enabled: logic.isAadhaarAPIFormFilled,
      ),
    );
  }

  List<Widget> _onShowOtpField() {
    return [
      verticalSpacer(50),
      const Align(
        alignment: Alignment.centerLeft,
        child: Text(
          'Enter OTP',
          style: TextStyle(
            color: primaryDarkColor,
            fontSize: 12,
            fontWeight: FontWeight.w500,
            letterSpacing: 0.11,
          ),
        ),
      ),
      const SizedBox(
        height: 12,
      ),
      _OTPTextField(),
      const Text(
        'An OTP is sent to your registered mobile number for verification',
        style: TextStyle(
          color: accountSummaryTitleColor,
          fontSize: 10,
          letterSpacing: 0.16,
        ),
      ),
      const SizedBox(
        height: 24,
      ),
      Visibility(
        visible: !logic.isLoading,
        maintainState: true,
        child: _ResendButton(),
      ),
    ];
  }

  Widget _aadhaarInputInfoText() {
    return const Text(
      "Enter the 12-digit Aadhaar number linked to your registered mobile number",
      style: TextStyle(
        fontSize: 10,
        color: secondaryDarkColor,
      ),
    );
  }

  PrivoTextFormField _aadhaarInputTextField(AadhaarApiLogic logic) {
    return PrivoTextFormField(
      id: logic.AADHAAR_TEXT_FIELD_ID,
      controller: logic.aadhaarNumberTextController,
      validator: aadhaarNumberValidator,
      keyboardType: TextInputType.number,
      inputFormatters: _inputFormatters(),
      maxLength: 14,
      enabled: !logic.isLoading,
      readOnly: logic.showOTPField,
      onChanged: (value) => logic.onAadhaarApiTextChanged(),
      style: _textFieldStyle(),

      ///restrict users to paste values to text field
      enableInteractiveSelection: false,
      decoration: InputDecoration(
        icon: SvgPicture.asset(
          Res.idCardIcon,
        ),
        helperMaxLines: 3,
        helperStyle: const TextStyle(
            fontSize: 10, letterSpacing: 0.16, color: accountSummaryTitleColor),
        errorText: logic.isInvalidAadhaarNumber
            ? "Invalid Input: Enter a valid Aadhaar."
            : null,
        counterText: "",
        suffix: logic.showOTPField ? _editButton(logic) : null,
        contentPadding: const EdgeInsets.only(bottom: 4),
        isDense: true,
        border: _textFieldBorder(),
      ),
    );
  }

  Widget _editButton(AadhaarApiLogic logic) {
    return InkWell(
      onTap: logic.onAadhaarRetryTapped,
      child: SvgPicture.asset(
        Res.editIcon,
      ),
    );
  }

  List<TextInputFormatter> _inputFormatters() =>
      [FilteringTextInputFormatter.digitsOnly, AadhaarSpaceFormatter()];

  UnderlineInputBorder _textFieldBorder() {
    return const UnderlineInputBorder(
      borderSide: BorderSide(
        color: Color(0xFF707070),
      ),
    );
  }

  TextStyle _textFieldStyle() {
    return const TextStyle(
      fontSize: 14,
      color: Color(0xff404040),
      letterSpacing: 0.22,
    );
  }
}

class _OTPTextField extends StatelessWidget
    with AadhaarFieldValidators {
  _OTPTextField({Key? key}) : super(key: key);

  final logic = Get.find<AadhaarApiLogic>();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: GetBuilder<AadhaarApiLogic>(
          id: logic.OTP_INPUT_ID,
          builder: (logic) {
            return Pinput(
              controller: logic.aadhaarOtpTextController,
              validator: otpValidator,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              enabled: !logic.isLoading,
              onChanged: (value) => logic.onAadhaarApiTextChanged(),
              length: 6,
              errorText: logic.otpErrorText,
              errorTextStyle: const TextStyle(
                fontSize: 12,
                color: Colors.red,
              ),
              forceErrorState: logic.otpErrorText != null,
              defaultPinTheme: const PinTheme(
                height: 45,
                width: double.infinity,
                decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border(
                        bottom: BorderSide(
                      color: secondaryDarkColor,
                      width: 1,
                    ))),
              ),
            );
          }),
    );
  }
}

class _ResendButton extends StatelessWidget {
  _ResendButton({Key? key}) : super(key: key);

  final logic = Get.find<AadhaarApiLogic>();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AadhaarApiLogic>(
      id: 'resend',
      builder: (controller) {
        return OtpResendWidget(
          isResendLoading: logic.isResendLoading,
          onResendPressed: logic.resetAadhaarOTP,
          alignment: Alignment.topLeft,
          timerValue: 60,
          fontWeight: FontWeight.w500,
          color: darkBlueColor,
          buttonTheme: AppButtonTheme.dark,
          buttonPadding: const EdgeInsets.only(top: 8.0),
        );
      },
    );
  }
}
