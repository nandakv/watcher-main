import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:privo/app/theme/app_colors.dart';
import 'package:privo/res.dart';
import '../../../../../common_widgets/forms/base_field_validator.dart';
import '../../../../../common_widgets/privo_text_form_field/privo_text_form_field.dart';
import '../../../withdrawal_field_validator.dart';
import '../withdrawal_logic.dart';

class PurposeSelector extends StatelessWidget with WithdrawalFieldValidator {
  PurposeSelector({Key? key}) : super(key: key);

  final logic = Get.find<WithdrawalLogic>();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: logic.purposeFormKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          PrivoTextFormField(
            id: logic.PURPOSE_TEXT_FIELD_ID,
            controller: logic.purposeController,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            validator: validatePurpose,
            readOnly: true,
            onTap: logic.onTapPurposeTextField,
            decoration: _purposeInputDecoration(),
          ),
          GetBuilder<WithdrawalLogic>(
            id: logic.OTHER_PURPOSE_TEXT_FIELD_ID,
            builder: (logic) {
              return logic.showOtherPurposeTextField
                  ? Column(
                      children: [
                        const SizedBox(
                          height: 10,
                        ),
                        PrivoTextFormField(
                          id: logic.PURPOSE_TEXT_FIELD,
                          controller: logic.otherPurposeTextController,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          decoration: _otherPurposeInputDecoration(),
                          maxLength: 250,
                          onChanged: logic.onOtherPurposeChanged,
                          validator: logic.validatePurposeTextField,
                        ),
                      ],
                    )
                  : const SizedBox();
            },
          ),
        ],
      ),
    );
  }

  InputDecoration _purposeInputDecoration() {
    return InputDecoration(
        isDense: true,
        label: RichText(
          text: TextSpan(
            text: 'Purpose',
            style: _labelTextStyle,
            children: const [
              TextSpan(
                text: " *",
                style: TextStyle(
                  color: Color(0xffEE3D4B),
                ),
              ),
            ],
          ),
        ),
        suffixIcon: Padding(
          padding: const EdgeInsets.only(left: 8, right: 8, top: 10),
          child: RotatedBox(
            quarterTurns: 3,
            child: SvgPicture.asset(
              Res.chevron_down_svg,
            ),
          ),
        ),
        suffixIconConstraints: const BoxConstraints(
          maxWidth: 32,
        ),
        alignLabelWithHint: true,
        labelStyle: _labelTextStyle,
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(
            width: 0.5,
            color: primaryDarkColor,
          ),
        ));
  }

  InputDecoration _otherPurposeInputDecoration() {
    return InputDecoration(
        isDense: true,
        label: const Text("Mention the purpose"),
        alignLabelWithHint: true,
        labelStyle: _labelTextStyle,
        counterStyle: const TextStyle(
          fontWeight: FontWeight.w400,
          fontSize: 8,
        ));
  }

  TextStyle get _labelTextStyle => const TextStyle(
        fontSize: 14,
        letterSpacing: 0.22,
        fontFamily: 'Figtree',
        color: Color(0xff404040),
        fontWeight: FontWeight.w400,
      );
}
