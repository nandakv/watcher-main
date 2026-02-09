import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:privo/app/common_widgets/common_text_fields/text_field_decoration.dart';
import 'package:privo/app/common_widgets/forms/base_field_validator.dart';
import 'package:privo/app/common_widgets/forms/model/form_field_attributes.dart';
import 'package:privo/app/common_widgets/forms/personal_details_field_validators.dart';
import 'package:privo/app/common_widgets/privo_text_form_field/privo_text_form_field.dart';
import 'package:privo/app/utils/no_leading_space_formatter.dart';
import 'package:privo/res.dart';

class PincodeField extends StatelessWidget
    with PersonalDetailsFieldValidators {
  final FormFieldAttributes formFieldAttributes;
  final String labelText;

  const PincodeField({
    Key? key,
    required this.formFieldAttributes,
    this.labelText = "Correspondence Address Pincode",
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PrivoTextFormField(
      id: 'PINCODE_FIELD',
      autovalidateMode: AutovalidateMode.onUserInteraction,
      enabled: formFieldAttributes.isEnabled,
      controller: formFieldAttributes.controller,
      validator: pinCodeValidator,
      onChanged: formFieldAttributes.onChanged,
      textInputAction: TextInputAction.next,
      keyboardType: TextInputType.number,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        LengthLimitingTextInputFormatter(6),
        NoLeadingSpaceFormatter()
      ],
      prefixSVGIcon: Res.pdLocation,
      decoration: textFieldDecoration(label: labelText),
    );
  }
}
