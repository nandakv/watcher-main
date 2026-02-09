import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:privo/app/common_widgets/gradient_button.dart';
import 'package:privo/app/modules/on_boarding/widgets/offer_upgrade_bank_selection/offer_upgrade_bank_selection_logic.dart';
import 'package:privo/app/theme/app_colors.dart';
import 'package:privo/flavors.dart';
import 'package:url_launcher/url_launcher_string.dart';

class MobileEditBottomSheetWidget extends StatelessWidget {
  MobileEditBottomSheetWidget({Key? key}) : super(key: key);

  final logic = Get.find<OfferUpgradeBankSelectionLogic>();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 30,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const Text(
              'Enter the mobile number linked to your bank account',
              style: TextStyle(
                color: Color(0xff707070),
                fontWeight: FontWeight.w300,
                fontSize: 14,
                letterSpacing: 0.22,
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            _mobileTextField(),
            const SizedBox(
              height: 40,
            ),
            _consentRow(),
            const SizedBox(
              height: 12,
            ),
            GetBuilder<OfferUpgradeBankSelectionLogic>(
              id: logic.MOBILE_BUTTON_ID,
              builder: (logic) {
                return GradientButton(
                  onPressed: logic.onMobileContinueTapped,
                  enabled: logic.isMobileButtonEnabled,
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Row _consentRow() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.all(4),
          child: Row(
            children: [
              Container(
                width: 14,
                height: 14,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(2),
                  border: Border.all(
                    color: darkBlueColor,
                    width: 1,
                  ),
                ),
                child: GetBuilder<OfferUpgradeBankSelectionLogic>(
                  id: logic.MOBILE_CHECK_BOX_ID,
                  builder: (logic) {
                    return Checkbox(
                      value: logic.mobileConsentCheckBoxValue,
                      onChanged: (value) =>
                          logic.mobileConsentCheckBoxValue = value!,
                      visualDensity: const VisualDensity(
                        horizontal: -4.0,
                        vertical: -4.0,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(2),
                        side: const BorderSide(
                          color: darkBlueColor,
                          width: 1,
                        ),
                      ),
                      checkColor: Colors.white,
                      side:
                          const BorderSide(color: Colors.transparent, width: 2),
                      activeColor: darkBlueColor,
                    );
                  },
                ),
              )
            ],
          ),
        ),
        const SizedBox(
          width: 5,
        ),
        _termsAndConditionText(),
      ],
    );
  }

  Expanded _termsAndConditionText() {
    return Expanded(
      child: RichText(
        textAlign: TextAlign.start,
        text: TextSpan(
          text: 'I agree to OneMoney ',
          style: const TextStyle(
              color: Color(0xff727272),
              letterSpacing: 0.16,
              fontSize: 10,
              fontWeight: FontWeight.w500,
              fontFamily: 'Figtree'),
          children: [
            TextSpan(
              text: 'Terms and Conditions',
              recognizer: TapGestureRecognizer()
                ..onTap = () => launchUrlString(
                      F.envVariables.termsAndConditionUrl,
                      mode: LaunchMode.externalApplication,
                    ),
              style: const TextStyle(
                color: skyBlueColor,
                decoration: TextDecoration.underline,
              ),
            ),
          ],
        ),
      ),
    );
  }

  GetBuilder<OfferUpgradeBankSelectionLogic> _mobileTextField() {
    return GetBuilder<OfferUpgradeBankSelectionLogic>(
      id: logic.MOBILE_TEXT_FIELD_ID,
      builder: (logic) {
        return TextFormField(
          controller: logic.mobileNumberController,
          validator: logic.validatePhoneNumber,
          maxLength: 10,
          autofocus: true,
          onChanged: (value) => logic.setNumber = value,
          keyboardType: TextInputType.number,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
          ],
          cursorColor: const Color(0xff002F7D).withOpacity(0.31),
          style: _textFieldTextStyle(),
          decoration: _mobileNumberTextFieldInputDecoration(),
        );
      },
    );
  }

  InputDecoration _mobileNumberTextFieldInputDecoration() {
    return InputDecoration(
      hintStyle: _mobileNumberHintTextStyle(),
      contentPadding: const EdgeInsets.symmetric(
        vertical: 0,
        horizontal: 10,
      ),
      counterText: '',
      prefix: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Text(
          '+91',
          style: TextStyle(
            fontSize: 14,
            letterSpacing: 1.4,
            fontWeight: FontWeight.w500,
            color: const Color(0xff1D478E).withOpacity(0.5),
          ),
        ),
      ),
      errorText: logic.mobileErrorText,
      border: OutlineInputBorder(
        borderSide: BorderSide(
          color: const Color(0xff002F7D).withOpacity(0.31),
          width: 1,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: const Color(0xff002F7D).withOpacity(0.31),
          width: 1,
        ),
      ),
    );
  }

  TextStyle _mobileNumberHintTextStyle() {
    return const TextStyle(
      fontSize: 14,
    );
  }

  TextStyle _textFieldTextStyle() {
    return const TextStyle(
      fontSize: 14,
      letterSpacing: 1.4,
      fontWeight: FontWeight.w500,
    );
  }
}
