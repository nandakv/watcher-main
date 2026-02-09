import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:privo/app/common_widgets/forms/base_field_validator.dart';
import 'package:privo/app/common_widgets/forms/model/form_field_attributes.dart';
import 'package:privo/app/common_widgets/forms/personal_details_field_validators.dart';
import 'package:privo/app/common_widgets/privo_text_form_field/privo_text_form_field.dart';
import 'package:privo/app/theme/app_colors.dart';
import 'package:privo/app/utils/no_leading_space_formatter.dart';
import 'package:privo/res.dart';

class PanField extends StatelessWidget
    with BaseFieldValidators, PersonalDetailsFieldValidators {
  final FormFieldAttributes formFieldAttributes;
  final List<String>? otherApplicantsPanNumbers;

  const PanField(
      {Key? key,
      required this.formFieldAttributes,
      this.otherApplicantsPanNumbers})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PrivoTextFormField(
      id: 'PAN_CARD_FIELD',
      autovalidateMode: AutovalidateMode.onUserInteraction,
      controller: formFieldAttributes.controller,
      enabled: formFieldAttributes.isEnabled,
      validator: (val) => panValidator(val, otherApplicantsPanNumbers),
      textInputAction: TextInputAction.next,
      inputFormatters: [
        NoLeadingSpaceFormatter(),
        LengthLimitingTextInputFormatter(10),
      ],
      bottomInfoImage: Res.panFieldInfo,
      textCapitalization: TextCapitalization.characters,
      onChanged: formFieldAttributes.onChanged,
      prefixSVGIcon: Res.pdPan,
      decoration: textFieldPANDecoration(label: "PAN "),
    );
  }
}

InputDecoration textFieldPANDecoration({
  required String label,
  String hint = "",
}) {
  return InputDecoration(
    hintText: hint,
    label: RichText(
      text: TextSpan(
          text: label,
          style: const TextStyle(
            fontFamily: 'Figtree',
            fontSize: 14,
            fontWeight: FontWeight.normal,
            color: secondaryDarkColor,
            letterSpacing: 0.16,
          ),
          children: [
            TextSpan(
              text: "(eg AAAPB1234B)",
              style: _hintTextStyle(),
            )
          ]),
    ),
    errorMaxLines: 2,
    contentPadding: const EdgeInsets.only(bottom: 5),
    border: const UnderlineInputBorder(
      borderSide: BorderSide(
        color: secondaryDarkColor,
      ),
    ),
  );
}

TextStyle _hintTextStyle() {
  return const TextStyle(
    fontSize: 10,
    fontWeight: FontWeight.w300,
    color: secondaryDarkColor,
    letterSpacing: 0.14,
  );
}
