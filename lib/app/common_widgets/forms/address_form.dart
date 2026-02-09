import 'package:flutter/material.dart';
import 'package:privo/app/common_widgets/common_text_fields/address_field.dart';
import 'package:privo/app/common_widgets/spacer_widgets.dart';

class AddressForm extends StatelessWidget {
  final AddressField addressLineOneField;
  final AddressField addressLineTwoField;
  final AddressPincodeField addressPincodeField;
  final GlobalKey<FormState> formKey;

  const AddressForm({
    Key? key,
    required this.addressLineOneField,
    required this.addressLineTwoField,
    required this.addressPincodeField,
    required this.formKey,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        children: [
          addressLineOneField,
          const VerticalSpacer(40),
          addressLineTwoField,
          const VerticalSpacer(40),
          addressPincodeField,
        ],
      ),
    );
  }
}
