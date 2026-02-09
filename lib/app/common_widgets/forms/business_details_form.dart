import 'package:flutter/material.dart';
import 'package:privo/app/common_widgets/common_text_fields/business_entity_name_field.dart';
import 'package:privo/app/common_widgets/common_text_fields/business_pan_field.dart';
import 'package:privo/app/common_widgets/common_text_fields/ownership_type_field.dart';
import 'package:privo/app/common_widgets/common_text_fields/pincode_field.dart';
import 'package:privo/app/common_widgets/common_text_fields/registration_date_form_field.dart';
import 'package:privo/app/common_widgets/forms/model/form_field_attributes.dart';
import 'package:privo/app/common_widgets/privo_text_editing_controller.dart';

class BusinessDetailsForm extends StatelessWidget {
  const BusinessDetailsForm({
    Key? key,
    required this.businessName,
    required this.businessPan,
    required this.ownerShipType,
    required this.pincode,
    required this.registrationDate,
    required this.showBusinessPan,
  }) : super(key: key);

  final FormFieldAttributes businessName;
  final FormFieldAttributes businessPan;
  final FormFieldAttributes registrationDate;
  final FormFieldAttributes pincode;
  final FormFieldAttributes ownerShipType;
  final bool showBusinessPan;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(
          height: 20,
        ),
        BusinessEntityNameField(
          businessEntityFieldAttributes: businessName,
        ),
        if (showBusinessPan) ...[
          const SizedBox(
            height: 20,
          ),
          BusinessPanField(
            formFieldAttributes: businessPan,
          ),
        ],
        const SizedBox(
          height: 20,
        ),
        RegistrationDateFormField(
          formFieldAttributes: registrationDate,
        ),
        const SizedBox(
          height: 20,
        ),
        OwnerShipTypeField(
          formFieldAttributes: ownerShipType,
        ),
        const SizedBox(
          height: 20,
        ),
        PincodeField(
          formFieldAttributes: pincode,
          labelText: "Operational Business Pincode",
        ),
      ],
    );
  }
}
