import 'package:flutter/material.dart';
import 'package:privo/app/common_widgets/common_text_fields/text_field_decoration.dart';
import 'package:privo/app/common_widgets/forms/sbd_field_validators.dart';
import 'package:privo/app/common_widgets/forms/model/form_field_attributes.dart';

import '../../../res.dart';
import '../forms/base_field_validator.dart';
import '../privo_text_form_field/privo_text_form_field.dart';

class OwnerShipTypeField extends StatelessWidget with BaseFieldValidators, SBDFieldValidators {
  const OwnerShipTypeField({
    Key? key,
    required this.formFieldAttributes,
  }) : super(key: key);

  final FormFieldAttributes formFieldAttributes;

  @override
  Widget build(BuildContext context) {
    return PrivoTextFormField(
      id: "OWNERSHIP_TYPE_TEXT_FIELD_ID",
      enabled: formFieldAttributes.isEnabled,
      controller: formFieldAttributes.controller,
      values: const [
        "Self Owned",
        "Company Owned",
        "Family Owned",
        "Rented",
      ],
      dropDownTitle: "Ownership Type",
      prefixSVGIcon: Res.ownershipTypeTFSvg,
      decoration: textFieldDecoration(label: "Ownership Type"),
      validator: ownerShipTypeValidator,
      onTap: formFieldAttributes.onTap,
      type: PrivoTextFormFieldType.dropDown,
      onChanged: formFieldAttributes.onChanged,
    );
  }

}
