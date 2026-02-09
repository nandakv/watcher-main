import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:privo/app/common_widgets/common_text_fields/text_field_decoration.dart';
import 'package:privo/app/common_widgets/forms/model/form_field_attributes.dart';
import 'package:privo/app/common_widgets/privo_text_form_field/privo_text_form_field.dart';
import 'package:privo/app/utils/no_leading_space_formatter.dart';

class AddressField extends StatelessWidget {
  final FormFieldAttributes addressFieldAttributes;
  final String formId;

  const AddressField({
    Key? key,
    required this.addressFieldAttributes,
    required this.formId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PrivoTextFormField(
      id: "Address_${formId}_${addressFieldAttributes.labelText}",
      autovalidateMode: addressFieldAttributes.isEnabled
          ? AutovalidateMode.onUserInteraction
          : AutovalidateMode.disabled,
      textInputAction: TextInputAction.next,
      controller: addressFieldAttributes.controller,
      validator: addressValidator,
      textCapitalization: TextCapitalization.words,
      enabled: addressFieldAttributes.isEnabled,
      onChanged: addressFieldAttributes.onChanged,
      decoration:
          textFieldDecoration(label: addressFieldAttributes.labelText ?? ""),
    );
  }

  String? addressValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "Address is required";
    } else if (value.trim().length < 5) {
      return "Minimum of 5 characters";
    } else if (value.trim().length > 40) {
      return "Maximum of 40 characters";
    }
    // allow only aphanumeric
    if (!RegExp(r'^[a-zA-Z0-9 ]+$').hasMatch(value)) {
      return "Special characters are not allowed";
    }

    return null;
  }
}

class AddressPincodeField extends StatelessWidget {
  final FormFieldAttributes formFieldAttributes;
  final String formId;
  const AddressPincodeField(
      {Key? key, required this.formFieldAttributes, required this.formId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PrivoTextFormField(
      id: "Address_${formId}_${formFieldAttributes.labelText}",
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
      decoration: textFieldDecoration(
          label: formFieldAttributes.labelText ?? "Current Address Pincode"),
    );
  }

  String? pinCodeValidator(String? value) {
    if (value!.trim().isEmpty) return "Empty Field: Pincode is required.";
    if (value.length != 6) {
      return "Incomplete Pincode: Complete your pincode.";
    } else if (!RegExp(r'^[1-9][0-9]{5}$').hasMatch(value.trim())) {
      return "Invalid Format: Enter a valid pincode.";
    }
    return null;
  }
}
