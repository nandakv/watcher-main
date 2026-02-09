import 'package:flutter/material.dart';
import 'package:privo/app/common_widgets/common_text_fields/text_field_decoration.dart';
import 'package:privo/app/common_widgets/forms/sbd_field_validators.dart';
import 'package:privo/app/common_widgets/forms/model/form_field_attributes.dart';
import 'package:privo/app/utils/no_leading_space_formatter.dart';

import '../../../res.dart';
import '../forms/base_field_validator.dart';
import '../privo_text_form_field/privo_text_form_field.dart';

class SBDDesignationField extends StatelessWidget
    with BaseFieldValidators, SBDFieldValidators {
  const SBDDesignationField({
    Key? key,
    required this.attributes,
  }) : super(key: key);
  final FormFieldAttributes attributes;

  @override
  Widget build(BuildContext context) {
    return PrivoTextFormField(
      id: "DESIGNATION_TEXT_FIELD_ID",
      controller: attributes.controller,
      enabled: attributes.isEnabled,
      onChanged: attributes.onChanged,
      prefixSVGIcon: Res.designationTFSVG,
      values: const [
        "Individual",
        "Proprietor",
        "Partner",
        "Co-Applicant",
        "Director",
      ],
      inputFormatters: [
        NoLeadingSpaceFormatter(),
      ],
      dropDownTitle: "Designation",
      type: PrivoTextFormFieldType.dropDown,
      validator: designationValidator,
      decoration: textFieldDecoration(label: "Designation"),
      onTap: attributes.onTap,
    );
  }
}
