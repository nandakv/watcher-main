import 'package:flutter/material.dart';
import 'package:privo/app/common_widgets/common_text_fields/text_field_decoration.dart';
import 'package:privo/app/common_widgets/forms/base_field_validator.dart';
import 'package:privo/app/common_widgets/forms/sbd_field_validators.dart';
import 'package:privo/app/utils/no_leading_space_formatter.dart';

import '../../../res.dart';
import '../forms/model/form_field_attributes.dart';
import '../privo_text_form_field/privo_text_form_field.dart';

class BusinessEntityNameField extends StatelessWidget
    with BaseFieldValidators, SBDFieldValidators {
  final FormFieldAttributes businessEntityFieldAttributes;

  const BusinessEntityNameField({
    Key? key,
    required this.businessEntityFieldAttributes,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PrivoTextFormField(
      id: "BUSINESS_ENTITY_NAME_TEXT_FIELD_ID",
      enabled: businessEntityFieldAttributes.isEnabled,
      controller: businessEntityFieldAttributes.controller,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      prefixSVGIcon: Res.businessEntityTFSvg,
      inputFormatters: [
        NoLeadingSpaceFormatter(),
      ],
      decoration: textFieldDecoration(label: "Business Entity Name"),
      validator: businessEntityNameValidator,
      onChanged: businessEntityFieldAttributes.onChanged,
    );
  }
}