import 'package:flutter/material.dart';
import 'package:privo/app/common_widgets/common_text_fields/text_field_decoration.dart';
import 'package:privo/app/common_widgets/forms/sbd_field_validators.dart';
import 'package:privo/app/common_widgets/forms/model/form_field_attributes.dart';

import '../../../res.dart';
import '../forms/base_field_validator.dart';
import '../privo_text_form_field/privo_text_form_field.dart';

class RegistrationDateFormField extends StatelessWidget
    with BaseFieldValidators, SBDFieldValidators {
  const RegistrationDateFormField({
    Key? key,
    required this.formFieldAttributes,
  }) : super(key: key);
  final FormFieldAttributes formFieldAttributes;

  @override
  Widget build(BuildContext context) {
    return PrivoTextFormField(
      id: "REGISTRATION_DATE_TEXT_FIELD_ID",
      enabled: formFieldAttributes.isEnabled,
      values: const [
        "Less than 12 months ago",
        "12-24 months ago",
        "24-48 months ago",
        "48-60 months ago",
        "More than 60 months ago",
      ],
      dropDownTitle: "Registration Date (Select Range)",
      controller: formFieldAttributes.controller,
      prefixSVGIcon: Res.registrationDateTFSvg,
      decoration: textFieldDecoration(
        label: "Registration Date (Select Range)",
      ),
      validator: registrationDateValidator,
      onTap: formFieldAttributes.onTap,
      type: PrivoTextFormFieldType.dropDown,
      onChanged: formFieldAttributes.onChanged,
    );
  }
}
