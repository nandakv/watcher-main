import 'package:flutter/material.dart';
import 'package:privo/app/common_widgets/common_text_fields/text_field_decoration.dart';
import 'package:privo/app/common_widgets/forms/model/form_field_attributes.dart';
import 'package:privo/app/common_widgets/privo_text_form_field/privo_text_form_field.dart';
import 'package:privo/app/utils/no_leading_space_formatter.dart';
import 'package:privo/res.dart';

class ResidenceTypeField extends StatelessWidget {
  final FormFieldAttributes formFieldAttributes;

  const ResidenceTypeField({Key? key, required this.formFieldAttributes})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PrivoTextFormField(
      id: 'RESIDENCE_TYPE_FIELD',
      autovalidateMode: AutovalidateMode.onUserInteraction,
      enabled: formFieldAttributes.isEnabled,
      controller: formFieldAttributes.controller,
      validator: residenceTypeValidator,
      onChanged: formFieldAttributes.onChanged,
      onTap: formFieldAttributes.onTap,
      readOnly: true,
      inputFormatters: [
        NoLeadingSpaceFormatter(),
      ],
      dropDownTitle: 'Residence Type',
      values: const [
        "PG / Working People Hostel",
        "Self Owned",
        "Family Owned",
        "Rented",
        "Company Accommodation",
      ],
      prefixSVGIcon: Res.pdResidence,
      type: PrivoTextFormFieldType.dropDown,
      decoration: textFieldDecoration(
        label: "Residence Type",
        isMandatory: formFieldAttributes.isMandatory,
      ),
    );
  }

  String? residenceTypeValidator(String? value) {
    if (value == null || (value != null && value!.trim().isEmpty)) {
      return "Not Selected: Select your residence type.";
    }
    return null;
  }
}
