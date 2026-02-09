import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:privo/app/modules/additional_business_details/additional_business_details_logic.dart';
import 'package:privo/app/utils/app_text_styles.dart';
import '../../common_widgets/common_text_fields/address_field.dart';
import '../../common_widgets/forms/address_form.dart';
import '../../common_widgets/forms/model/address_form_controller.dart';
import '../../common_widgets/forms/model/form_field_attributes.dart';
import '../../common_widgets/spacer_widgets.dart';
import '../../theme/app_colors.dart';

class NewAddressScreen extends StatelessWidget {
  NewAddressScreen({super.key});

  final logic = Get.find<AdditionalBusinessDetailsLogic>();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SingleChildScrollView(
          child: GetBuilder<AdditionalBusinessDetailsLogic>(
              id: logic.NEW_ADDRESS_WIDGET,
              builder: (logic) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildAddressSection(
                      title: "Enter New Registered Address",
                      formKey: logic.correspondenceAddressFormKey,
                      addressController: logic.correspondenceAddressController,
                      formId: logic.CORRESPONDENCE_ADDRESS_FORM_ID,
                      onChanged: () =>
                          logic.onSelectedCorrespondenceAddressChanged(),
                    ),
                    VerticalSpacer(56.h), // Consistent spacing
                    _buildAddressSection(
                      title: "Enter New Operational Address",
                      formKey: logic.operationalAddressFormKey,
                      addressController: logic.operationalAddressController,
                      formId: logic.OPERATIONAL_ADDRESS_FORM_ID,
                      onChanged: () =>
                          logic.onSelectedCorrespondenceAddressChanged(),
                    ),
                    VerticalSpacer(32.h),
                  ],
                );
              }),
        ),
      ],
    );
  }

  Widget _buildAddressSection({
    required String title,
    required GlobalKey<FormState> formKey,
    required AddressFormController addressController,
    required String formId,
    required VoidCallback onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _heading(title),
        VerticalSpacer(12.h), // Consistent spacing
        AddressForm(
          addressLineOneField: AddressField(
            formId: formId,
            addressFieldAttributes: FormFieldAttributes(
              controller: addressController.addressLine1Controller,
              labelText: "Address Line 1",
              onChanged: (_) => onChanged(),
            ),
          ),
          addressLineTwoField: AddressField(
            formId: formId,
            addressFieldAttributes: FormFieldAttributes(
              controller: addressController.addressLine2Controller,
              labelText: "Address Line 2",
              onChanged: (_) => onChanged(),
            ),
          ),
          addressPincodeField: AddressPincodeField(
            formId: formId,
            formFieldAttributes: FormFieldAttributes(
              controller: addressController.pincodeController,
              labelText: "Pincode",
              isEnabled: addressController.isPincodeEditable,
              onChanged: (_) => onChanged(),
            ),
          ),
          formKey: formKey,
        ),
      ],
    );
  }

  Text _heading(String title) {
    return Text(
      title,
      style: AppTextStyles.headingSMedium(color: primaryDarkColor),
    );
  }
}
