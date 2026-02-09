import 'package:after_layout/after_layout.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:privo/app/common_widgets/common_text_fields/address_field.dart';
import 'package:privo/app/common_widgets/consent_text_widget.dart';
import 'package:privo/app/common_widgets/forms/address_form.dart';
import 'package:privo/app/common_widgets/forms/model/form_field_attributes.dart';
import 'package:privo/app/common_widgets/privo_button.dart';
import 'package:privo/app/common_widgets/spacer_widgets.dart';
import 'package:privo/app/modules/additional_business_details/additional_business_details_logic.dart';
import 'package:privo/app/modules/document_upload_tile/document_upload_tile.dart';
import 'package:privo/app/theme/app_colors.dart';
import 'package:privo/app/theme/app_text_theme.dart';

class AddressDetailsScreen extends StatefulWidget {
  const AddressDetailsScreen({Key? key}) : super(key: key);

  @override
  State<AddressDetailsScreen> createState() => _AddressDetailsScreenState();
}

class _AddressDetailsScreenState extends State<AddressDetailsScreen>
    with AfterLayoutMixin {
  final logic = Get.find<AdditionalBusinessDetailsLogic>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            _appbar(),
            Expanded(child: _body()),
            _saveButton(),
          ],
        ),
      ),
    );
  }

  _titleWidget() {
    return Text(
      logic.computeAddressScreenTitle(),
      style: GoogleFonts.poppins(
          fontSize: 16, fontWeight: FontWeight.w500, color: navyBlueColor),
    );
  }

  Widget _body() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _titleWidget(),
            const VerticalSpacer(40),
            _computeAddressSection(),
            const VerticalSpacer(56),
            logic.isTopUp ? const SizedBox() : _documentSection(),
          ],
        ),
      ),
    );
  }

  Widget _computeAddressSection() {
    switch (logic.addressDetailsState) {
      case AddressDetailsState.residence:
        return _correspondingAddressSection();
      default:
        return _officeAddressSection();
    }
  }

  Widget _officeAddressSection() {
    return Column(
      children: [
        _operationalAddressSection(),
        const VerticalSpacer(56),
        _registeredAddressSection(),
      ],
    );
  }

  Widget _registeredAddressSection() {
    return GetBuilder<AdditionalBusinessDetailsLogic>(
        id: logic.REGISTERED_ADDRESS_ID,
        builder: (logic) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Registered Address",
                style: sectionHeaderTextStyle(color: primaryDarkColor),
              ),
              const VerticalSpacer(6),
              ConsentTextWidget(
                value: logic.isRegisteredAddSameAsOperationsAddr,
                onChanged: (value) {
                  if (value != null) {
                    logic.isRegisteredAddSameAsOperationsAddr = value;
                  }
                },
                letterSpacing: 0.14,
                horizontalGap: 5,
                horizontalPadding: 0,
                consentText: 'Same as operational address',
                checkBoxState: CheckBoxState.postRegCheckBox,
              ),
              logic.isRegisteredAddSameAsOperationsAddr
                  ? _regAddrSameOperAddressForm()
                  : _registeredAddressForm(),
            ],
          );
        });
  }

  Widget _regAddrSameOperAddressForm() {
    return AddressForm(
      addressLineOneField: AddressField(
        formId: logic.REGISTERED_ADDRESS_SAME_AS_OP_ADDRESS_FORM_ID,
        addressFieldAttributes: FormFieldAttributes(
          controller: logic.operationalAddressController.addressLine1Controller,
          isEnabled: false,
          labelText: "Address Line 1",
        ),
      ),
      addressLineTwoField: AddressField(
        formId: logic.REGISTERED_ADDRESS_SAME_AS_OP_ADDRESS_FORM_ID,
        addressFieldAttributes: FormFieldAttributes(
          controller: logic.operationalAddressController.addressLine2Controller,
          isEnabled: false,
          labelText: "Address Line 2",
        ),
      ),
      addressPincodeField: AddressPincodeField(
        formId: logic.REGISTERED_ADDRESS_SAME_AS_OP_ADDRESS_FORM_ID,
        formFieldAttributes: FormFieldAttributes(
          controller: logic.operationalAddressController.pincodeController,
          isEnabled: false,
          labelText: "Pincode",
        ),
      ),
      formKey: logic.registeredAddressSameAsOpAddFormKey,
    );
  }

  Widget _registeredAddressForm() {
    return AddressForm(
      addressLineOneField: AddressField(
        formId: logic.REGISTERED_ADDRESS_FORM_ID,
        addressFieldAttributes: FormFieldAttributes(
          controller: logic.registeredAddressController.addressLine1Controller,
          labelText: "Address Line 1",
          onChanged: (_) => logic.onOfficeAddressChanged(),
        ),
      ),
      addressLineTwoField: AddressField(
          formId: logic.REGISTERED_ADDRESS_FORM_ID,
          addressFieldAttributes: FormFieldAttributes(
            controller:
                logic.registeredAddressController.addressLine2Controller,
            labelText: "Address Line 2",
            onChanged: (_) => logic.onOfficeAddressChanged(),
          )),
      addressPincodeField: AddressPincodeField(
        formId: logic.REGISTERED_ADDRESS_FORM_ID,
        formFieldAttributes: FormFieldAttributes(
          controller: logic.registeredAddressController.pincodeController,
          labelText: "Pincode",
          onChanged: (_) => logic.onOfficeAddressChanged(),
        ),
      ),
      formKey: logic.registeredAddressFormKey,
    );
  }

  Widget _operationalAddressSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Operational Address",
          style: sectionHeaderTextStyle(color: primaryDarkColor),
        ),
        const VerticalSpacer(12),
        AddressForm(
          addressLineOneField: AddressField(
            formId: logic.OPERATIONAL_ADDRESS_FORM_ID,
            addressFieldAttributes: FormFieldAttributes(
              controller:
                  logic.operationalAddressController.addressLine1Controller,
              labelText: "Address Line 1",
              onChanged: (_) => logic.onOfficeAddressChanged(),
            ),
          ),
          addressLineTwoField: AddressField(
              formId: logic.OPERATIONAL_ADDRESS_FORM_ID,
              addressFieldAttributes: FormFieldAttributes(
                controller:
                    logic.operationalAddressController.addressLine2Controller,
                labelText: "Address Line 2",
                onChanged: (_) => logic.onOfficeAddressChanged(),
              )),
          addressPincodeField: AddressPincodeField(
            formId: logic.OPERATIONAL_ADDRESS_FORM_ID,
            formFieldAttributes: FormFieldAttributes(
              controller: logic.operationalAddressController.pincodeController,
              labelText: "Pincode",
              isEnabled: logic.operationalAddressController.isPincodeEditable,
              onChanged: (_) => logic.onOfficeAddressChanged(),
            ),
          ),
          formKey: logic.operationalAddressFormKey,
        ),
      ],
    );
  }

  Widget _correspondingAddressSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Correspondence Address",
          style: sectionHeaderTextStyle(color: primaryDarkColor),
        ),
        const VerticalSpacer(12),
        AddressForm(
          addressLineOneField: AddressField(
            formId: logic.CORRESPONDENCE_ADDRESS_FORM_ID,
            addressFieldAttributes: FormFieldAttributes(
              controller:
                  logic.correspondenceAddressController.addressLine1Controller,
              labelText: "Address Line 1",
              onChanged: (_) => logic.onCorrespondenceAddressChanged(),
            ),
          ),
          addressLineTwoField: AddressField(
              formId: logic.CORRESPONDENCE_ADDRESS_FORM_ID,
              addressFieldAttributes: FormFieldAttributes(
                controller: logic
                    .correspondenceAddressController.addressLine2Controller,
                labelText: "Address Line 2",
                onChanged: (_) => logic.onCorrespondenceAddressChanged(),
              )),
          addressPincodeField: AddressPincodeField(
              formId: logic.CORRESPONDENCE_ADDRESS_FORM_ID,
              formFieldAttributes: FormFieldAttributes(
                controller:
                    logic.correspondenceAddressController.pincodeController,
                labelText: "Pincode",
                isEnabled:
                    logic.correspondenceAddressController.isPincodeEditable,
                onChanged: (_) => logic.onCorrespondenceAddressChanged(),
              )),
          formKey: logic.correspondenceAddressFormKey,
        ),
      ],
    );
  }

  Widget _sectionHeader(String title) {
    return Text(
      title,
      style: const TextStyle(
        color: navyBlueColor,
        fontSize: 14,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  Widget _documentSection() {
    return GetBuilder<AdditionalBusinessDetailsLogic>(builder: (context) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionHeader("Upload Proof"),
          const VerticalSpacer(6),
          _documentsInfoText(),
          const VerticalSpacer(16),
          _computeDocumentUploadSection(),
          const VerticalSpacer(40),
        ],
      );
    });
  }

  Widget _computeDocumentUploadSection() {
    switch (logic.addressDetailsState) {
      case AddressDetailsState.residence:
        return DocumentUploadTile(
          documentUploadTileDetails:
              logic.correspondenceAddressDocumentUploadTileDetails,
        );
      default:
        return Column(
          children: [
            DocumentUploadTile(
              documentUploadTileDetails:
                  logic.registeredAddressDocumentUploadTileDetails,
            ),
            const VerticalSpacer(16),
            DocumentUploadTile(
              documentUploadTileDetails:
                  logic.operationalAddressDocumentUploadTileDetails,
            ),
          ],
        );
    }
  }

  Widget _documentsInfoText() {
    return const Text(
      "Upload files PDF, JPEG, PNG formats under 20 MB. Ensure clarity and name files descriptively",
      style: TextStyle(fontSize: 10, height: 1.3, color: darkBlueColor),
    );
  }

  Widget _saveButton() {
    return GetBuilder<AdditionalBusinessDetailsLogic>(
        id: logic.ADDRESS_BUTTON_ID,
        builder: (context) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 18),
            child: logic.addressDetailsState == AddressDetailsState.residence
                ? _residenceSaveButton()
                : _officeSaveButton(),
          );
        });
  }

  Widget _officeSaveButton() {
    return PrivoButton(
      onPressed: logic.onOfficeAddressSaved,
      title: "Save",
      enabled: logic.isOfficeAddressCTAEnabled,
    );
  }

  Widget _residenceSaveButton() {
    return PrivoButton(
      onPressed: logic.onResidenceAddressSaved,
      title: "Save",
      enabled: logic.isResidenceAddressCTAEnabled,
    );
  }

  Widget _appbar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        IconButton(
          onPressed: Get.back,
          icon: const Icon(
            Icons.clear_rounded,
            color: appBarTitleColor,
          ),
        ),
      ],
    );
  }

  @override
  void afterFirstLayout(BuildContext context) {
    logic.preValidateAddressFieldsForTopUp();
  }
}
