import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:privo/app/common_widgets/blue_background.dart';
import 'package:privo/app/common_widgets/gradient_button.dart';

import 'package:privo/app/theme/app_text_theme.dart';

import 'mobile_screen_logic.dart';

class MobileScreenPage extends StatelessWidget {
  final logic = Get.find<MobileScreenLogic>();

  MobileScreenPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlueBackground(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Form(
            key: logic.formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 120,
                ),
                Text(
                  "Enter your mobile number",
                  style: signUpHeadingTextStyle,
                ),
                const SizedBox(
                  height: 25,
                ),
                GetBuilder<MobileScreenLogic>(
                  id: logic.TEXTFIELD_KEY,
                  builder: (logic) {
                    return TextFormField(
                      controller: logic.mobileNoController,
                      validator: logic.validatePhoneNumber,
                      maxLength: 10,
                      autofocus: true,
                      onFieldSubmitted: (value) => logic.onContinueTapped(),
                      onChanged: (value) => logic.setNumber = value,
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                      style: _textFieldTextStyle(),
                      cursorColor: Colors.white,
                      decoration: _mobileNumberTextFieldInputDecoration(),
                    );
                  },
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 8,
                  ),
                  child: Text(
                    "Please ensure your mobile number is linked to Aadhaar",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 10,
                      letterSpacing: 0.16,
                      fontStyle: FontStyle.italic,
                      fontWeight: FontWeight.w300,
                      color: Color(0xffffffff),
                    ),
                  ),
                ),
                // GetBuilder<MobileScreenLogic>(
                //   id: logic.HELPER_TEXT_KEY,
                //   builder: (logic) {
                //     return AnimatedSwitcher(
                //       duration: const Duration(milliseconds: 300),
                //       transitionBuilder: (child, animation) =>
                //           SizeTransition(
                //         sizeFactor: animation,
                //         child: child,
                //       ),
                //       child: logic.showHelperText
                //           ? const Padding(
                //               padding: EdgeInsets.symmetric(
                //                 horizontal: 10,
                //                 vertical: 8,
                //               ),
                //               child: Text(
                //                 "Please ensure your mobile number is linked to Aadhaar",
                //                 textAlign: TextAlign.center,
                //                 style: TextStyle(
                //                   fontSize: 10,
                //                   letterSpacing: 0.16,
                //                   fontStyle: FontStyle.italic,
                //                   fontWeight: FontWeight.w300,
                //                   color: Color(0xffffffff),
                //                 ),
                //               ),
                //             )
                //           : const SizedBox(),
                //     );
                //   },
                // ),
                const SizedBox(
                  height: 30,
                ),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: ConsentCheckBox(
                    checkBoxKey: logic.PAN_CHECK_BOX_KEY,
                    message:
                        "I authorise Kisetsu Saison Finance (India) Private Limited to perform my Credit check & run a PAN validation through NSDL and use 3rd party systems for any additional verification.",
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                GetBuilder<MobileScreenLogic>(
                  id: logic.BUTTON_KEY,
                  builder: (logic) {
                    return GradientButton(
                      title: "Get OTP",
                      onPressed: logic.onContinueTapped,
                      isLoading: logic.isLoading,
                      buttonTheme: AppButtonTheme.light,
                      enabled: logic.isButtonEnabled,
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
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
            color: Colors.white.withOpacity(0.5),
          ),
        ),
      ),
      errorText: logic.errorText,
      filled: true,
      fillColor: const Color(0xff385789).withOpacity(0.31),
      border: const OutlineInputBorder(
        borderSide: BorderSide.none,
      ),
    );
  }

  TextStyle _mobileNumberHintTextStyle() {
    return const TextStyle(
      color: Color(0xff93A5C7),
      fontSize: 14,
    );
  }

  TextStyle _textFieldTextStyle() {
    return const TextStyle(
      fontSize: 14,
      color: Colors.white,
      letterSpacing: 1.4,
      fontWeight: FontWeight.w500,
    );
  }
}

class ConsentCheckBox extends StatelessWidget {
  ConsentCheckBox({Key? key, required this.checkBoxKey, required this.message})
      : super(key: key);

  final logic = Get.find<MobileScreenLogic>();

  final String checkBoxKey;
  final String message;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GetBuilder<MobileScreenLogic>(
          id: checkBoxKey,
          builder: (logic) {
            return Checkbox(
              visualDensity: const VisualDensity(
                horizontal: -4.0,
                vertical: -4.0,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(2),
              ),
              checkColor: const Color(0xff284689),
              side: const BorderSide(color: Colors.white, width: 2),
              value: logic.panConsentCheckBoxValue,
              onChanged: (value) => logic.panConsentCheckBoxValue = value!,
              activeColor: Colors.white,
            );
          },
        ),
        const SizedBox(
          width: 10,
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: 3),
            child: Text(
              message,
              style: _messageTextStyle(),
              textAlign: TextAlign.start,
            ),
          ),
        ),
      ],
    );
  }

  TextStyle _messageTextStyle() {
    return const TextStyle(
      fontSize: 10,
      letterSpacing: 0.16,
      fontWeight: FontWeight.normal,
      color: Colors.white,
    );
  }
}
