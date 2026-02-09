import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:privo/app/common_widgets/common_text_fields/text_field_decoration.dart';
import 'package:privo/app/common_widgets/forms/sbd_field_validators.dart';
import 'package:privo/app/common_widgets/forms/model/form_field_attributes.dart';

import '../../../res.dart';
import '../forms/base_field_validator.dart';
import '../privo_text_form_field/privo_text_form_field.dart';

class SBDShareHoldingField extends StatelessWidget
    with BaseFieldValidators, SBDFieldValidators {
  const SBDShareHoldingField({
    Key? key,
    required this.attributes,
  }) : super(key: key);
  final FormFieldAttributes attributes;

  @override
  Widget build(BuildContext context) {
    return PrivoTextFormField(
      id: "SHAREHOLDING_TEXT_FIELD_ID",
      controller: attributes.controller,
      enabled: attributes.isEnabled,
      onChanged: attributes.onChanged,
      prefixSVGIcon: Res.shareHoldingTFSVG,
      validator: shareHoldingValidator,
      decoration: textFieldDecoration(label: "Shareholding (%)").copyWith(
        counterText: "",
        errorText: attributes.errorText,
      ),
      keyboardType: TextInputType.number,
      maxLength: 3,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
      ],

    );
  }
}
