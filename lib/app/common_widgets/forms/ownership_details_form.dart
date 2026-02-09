import 'package:flutter/material.dart';
import 'package:privo/app/common_widgets/common_text_fields/ownership_type_field.dart';
import 'package:privo/app/common_widgets/common_text_fields/sbd_desingation_field.dart';
import 'package:privo/app/common_widgets/common_text_fields/sbd_shareholding_field.dart';
import 'package:privo/app/common_widgets/forms/model/form_field_attributes.dart';
import 'package:privo/app/common_widgets/spacer_widgets.dart';
import 'package:privo/app/theme/app_colors.dart';

class OwnerShipDetailsForm extends StatelessWidget {
  const OwnerShipDetailsForm({
    Key? key,
    required this.designationField,
    required this.shareHoldingField,
  }) : super(key: key);

  final SBDDesignationField designationField;
  final SBDShareHoldingField shareHoldingField;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text(
          "Ownership Details",
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 14,
            color: primaryDarkColor,
          ),
        ),
        const VerticalSpacer(20),
        designationField,
        const VerticalSpacer(20),
        shareHoldingField,
        const VerticalSpacer(20),
      ],
    );
  }
}
