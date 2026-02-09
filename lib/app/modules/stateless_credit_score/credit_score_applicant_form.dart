import 'package:flutter/cupertino.dart';

import '../../common_widgets/common_text_fields/email_field.dart';
import '../../common_widgets/common_text_fields/full_name_field.dart';
import '../../common_widgets/common_text_fields/pan_field.dart';
import '../../common_widgets/vertical_spacer.dart';

class CreditScoreApplicantForm extends StatelessWidget {
  final FullNameField fullNameField;
  final PanField panField;
  final EmailField emailField;

  const CreditScoreApplicantForm(
      {Key? key,
      required this.fullNameField,
      required this.panField,
      required this.emailField})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        fullNameField,
        verticalSpacer(18),
        panField,
        verticalSpacer(18),
        emailField,
      ],
    );
  }
}
