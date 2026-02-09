import 'package:flutter/material.dart';
import 'package:privo/app/common_widgets/common_text_fields/text_field_decoration.dart';
import 'package:privo/app/common_widgets/forms/sbd_field_validators.dart';

import '../../../res.dart';
import '../forms/base_field_validator.dart';
import '../forms/model/form_field_attributes.dart';
import '../privo_text_form_field/privo_text_form_field.dart';

class BusinessPanField extends StatelessWidget
    with BaseFieldValidators, SBDFieldValidators {
  final FormFieldAttributes formFieldAttributes;

  const BusinessPanField({
    Key? key,
    required this.formFieldAttributes,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PrivoTextFormField(
      id: "BUSINESS_PAN_TEXT_FIELD_ID",
      enabled: formFieldAttributes.isEnabled,
      controller: formFieldAttributes.controller,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      prefixSVGIcon: Res.businessPanTFSvg,
      decoration: textFieldDecoration(label: "Business PAN"),
      validator: businessPanValidator,
      onChanged: formFieldAttributes.onChanged,
    );
  }
}
