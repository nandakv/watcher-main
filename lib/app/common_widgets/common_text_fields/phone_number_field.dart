import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:privo/app/common_widgets/common_text_fields/text_field_decoration.dart';
import 'package:privo/app/common_widgets/forms/base_field_validator.dart';
import 'package:privo/app/common_widgets/forms/model/form_field_attributes.dart';
import 'package:privo/app/common_widgets/privo_text_form_field/privo_text_form_field.dart';
import 'package:privo/app/utils/no_leading_space_formatter.dart';
import 'package:privo/res.dart';

import '../forms/personal_details_field_validators.dart';

class PhoneNumberField extends StatelessWidget
    with PersonalDetailsFieldValidators {
  final FormFieldAttributes formFieldAttributes;
  final List<String>? otherApplicantsMobileNumbers;

  const PhoneNumberField({
    Key? key,
    required this.formFieldAttributes,
    this.otherApplicantsMobileNumbers,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PrivoTextFormField(
      id: 'PHONE_NUMBER_FIELD',
      autovalidateMode: AutovalidateMode.onUserInteraction,
      enabled: formFieldAttributes.isEnabled,
      controller: formFieldAttributes.controller,
      validator: (value) =>
          phoneNumberValidator(value, otherApplicantsMobileNumbers),
      onChanged: formFieldAttributes.onChanged,
      textInputAction: TextInputAction.done,
      maxLength: 10,
      keyboardType: TextInputType.phone,
      inputFormatters: [
        PhoneNumberInputFormatter(),
        NoLeadingSpaceFormatter(),
        FilteringTextInputFormatter.digitsOnly,
      ],
      prefixSVGIcon: Res.phoneIconTFSVG,
      decoration: textFieldDecoration(
        label: "Phone  No.",
        counterWidget: const SizedBox.shrink(),
      ),
    );
  }
}
