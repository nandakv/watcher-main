import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:privo/app/common_widgets/common_text_fields/text_field_decoration.dart';
import 'package:privo/app/common_widgets/forms/model/form_field_attributes.dart';
import 'package:privo/app/common_widgets/privo_text_form_field/privo_text_form_field.dart';
import 'package:privo/app/utils/no_leading_space_formatter.dart';
import 'package:privo/res.dart';

import '../../modules/withdrawal_screen/withdrawal_field_validator.dart';
import '../forms/base_field_validator.dart';

class CorrespondenceAddressTypeField extends StatelessWidget with WithdrawalFieldValidator{
  final FormFieldAttributes formFieldAttributes;

  const CorrespondenceAddressTypeField({Key? key, required this.formFieldAttributes})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PrivoTextFormField(
      id: 'CORRES_ADDRESS_TYPE_FIELD',
      autovalidateMode: AutovalidateMode.onUserInteraction,
      enabled: formFieldAttributes.isEnabled,
      controller: formFieldAttributes.controller,
      validator: validateAddressTextField,
      onChanged: formFieldAttributes.onChanged,
      onTap: formFieldAttributes.onTap,
      inputFormatters: [
        NoLeadingSpaceFormatter(),
      ],
      prefixSVGIcon: Res.pdResidence,
      decoration: textFieldDecoration(
        label: "Current Residential Address",
        isMandatory: formFieldAttributes.isMandatory,
      ),
    );
  }
}
