import 'package:flutter/material.dart';
import 'package:privo/app/common_widgets/common_text_fields/email_field.dart';
import 'package:privo/app/common_widgets/common_text_fields/full_name_field.dart';
import 'package:privo/app/common_widgets/common_text_fields/pan_field.dart';
import 'package:privo/app/common_widgets/common_text_fields/phone_number_field.dart';
import 'package:privo/app/common_widgets/vertical_spacer.dart';
import 'package:privo/app/modules/on_boarding/widgets/personal_details/widgets/personal_details_dob_field/personal_details_dob_field.dart';

class ApplicantForm extends StatelessWidget {
  final FullNameField fullNameField;
  final PersonalDetailsDOBField dobField;
  final PanField panField;
  final PhoneNumberField? phoneNumberField;
  final EmailField emailField;

  const ApplicantForm({
    Key? key,
    required this.fullNameField,
    required this.dobField,
    required this.panField,
    this.phoneNumberField,
    required this.emailField,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        fullNameField,
        verticalSpacer(40),
        dobField,
        verticalSpacer(18),
        panField,
        verticalSpacer(18),
        if (phoneNumberField != null) ...[
          phoneNumberField!,
          verticalSpacer(18),
        ],
        emailField,
      ],
    );
  }
}
