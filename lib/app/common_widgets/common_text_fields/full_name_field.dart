import 'package:flutter/material.dart';
import 'package:privo/app/common_widgets/common_text_fields/text_field_decoration.dart';
import 'package:privo/app/common_widgets/forms/base_field_validator.dart';
import 'package:privo/app/common_widgets/forms/model/form_field_attributes.dart';
import 'package:privo/app/common_widgets/forms/personal_details_field_validators.dart';
import 'package:privo/app/common_widgets/privo_text_form_field/privo_text_form_field.dart';
import 'package:privo/app/utils/no_leading_space_formatter.dart';
import 'package:privo/res.dart';

class FullNameField extends StatelessWidget
    with PersonalDetailsFieldValidators {
  final FormFieldAttributes formFieldAttributes;

  const FullNameField({
    Key? key,
    required this.formFieldAttributes,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PrivoTextFormField(
      id: "PERSONAL_DETAILS_FULL_NAME",
      autovalidateMode: AutovalidateMode.onUserInteraction,
      textInputAction: TextInputAction.next,
      controller: formFieldAttributes.controller,
      validator: nameValidator,
      textCapitalization: TextCapitalization.words,
      enabled: formFieldAttributes.isEnabled,
      onChanged: formFieldAttributes.onChanged,
      inputFormatters: [
        NoLeadingSpaceFormatter(),
        NoSpecialCharacterFormatter(),
      ],
      prefixSVGIcon: Res.pdName,
      decoration:
          textFieldDecoration(hint: "eg. Suresh Kumar", label: "Full Name (As per PAN)"),
    );
  }
}
