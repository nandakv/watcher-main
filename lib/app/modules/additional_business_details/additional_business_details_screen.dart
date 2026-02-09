import 'package:after_layout/after_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:privo/app/common_widgets/common_text_fields/text_field_decoration.dart';
import 'package:privo/app/common_widgets/privo_button.dart';
import 'package:privo/app/common_widgets/privo_text_form_field/privo_text_form_field.dart';
import 'package:privo/app/common_widgets/spacer_widgets.dart';
import 'package:privo/app/modules/additional_business_details/additional_business_details_logic.dart';
import 'package:privo/app/modules/additional_business_details/widgets/address_details_tile.dart';
import 'package:privo/app/modules/additional_business_details/widgets/address_filled_widget.dart';
import 'package:privo/app/modules/additional_business_details/widgets/address_with_proof_text_widget.dart';
import 'package:privo/app/modules/additional_business_details/widgets/document_section.dart';
import 'package:privo/app/theme/app_colors.dart';
import 'package:privo/app/utils/no_leading_space_formatter.dart';
import 'package:privo/res.dart';

class AdditionalBusinessDetailsScreen extends StatefulWidget {
  const AdditionalBusinessDetailsScreen({Key? key}) : super(key: key);

  @override
  State<AdditionalBusinessDetailsScreen> createState() =>
      _AdditionalBusinessDetailsScreenState();
}

class _AdditionalBusinessDetailsScreenState
    extends State<AdditionalBusinessDetailsScreen> {
  final logic = Get.find<AdditionalBusinessDetailsLogic>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: GetBuilder<AdditionalBusinessDetailsLogic>(
        builder: (logic) {
          return Column(
            children: [
              Expanded(child: _body()),
              _saveCTA(),
            ],
          );
        },
      ),
    );
  }

  Widget _saveCTA() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
      child: GetBuilder<AdditionalBusinessDetailsLogic>(
        id: logic.BUTTON_ID,
        builder: (logic) {
          return PrivoButton(
            onPressed: logic.postAdditionalBusinessDetails,
            enabled: logic.isButtonEnabled,
            title: "Continue",
            isLoading: logic.isButtonLoading,
          );
        },
      ),
    );
  }

  Widget _titleWidget() {
    return Text(
      "Additional Business Details",
      style: GoogleFonts.poppins(
        color: darkBlueColor,
        fontSize: 16,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  Widget _udyamTextField() {
    return PrivoTextFormField(
      id: logic.UDYAM_FIELD_ID,
      maxLength: 13,
      controller: logic.udyamController,
      prefixSVGIcon: Res.pdPan,
      inputFormatters: [
        UdyamHyphenFormatter()
      ],
      enabled: !logic.isButtonLoading,
      onChanged: (_) => logic.isFormValid(),
      validator: logic.udyamValidation,
      textCapitalization: TextCapitalization.characters,
      decoration: _udyamTextFieldDecoration(),
    );
  }

  InputDecoration _udyamTextFieldDecoration() {
    return textFieldDecoration(
      label: "Udyam No. (Optional)",
      counterWidget: const SizedBox(),
      prefix: const Padding(
        padding: EdgeInsets.symmetric(horizontal: 0),
        child: Text(
          'UDYAM-',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: primaryDarkColor,
          ),
        ),
      ),
      suffixIcon: InkWell(
          onTap: logic.onUdyamInfoTapped,
          child: SvgPicture.asset(Res.infoIconSVG)),
    );
  }

  Widget _natureOfBusinessField() {
    return PrivoTextFormField(
      readOnly: true,
      id: logic.NATURE_OF_BUSINESS_ID,
      controller: logic.natureOfBusinessController,
      values: const [
        "Manufacturing",
        "Service",
        "Trader - Retail",
        "Trader - Wholesale",
      ],
      dropDownTitle: "Nature of Business",
      enabled: logic.isNatureOfBusinessEnabled,
      onChanged: (_) => logic.isFormValid(),
      prefixSVGIcon: Res.businessNatureIcon,
      type: PrivoTextFormFieldType.dropDown,
      decoration: textFieldDecoration(
        label: "Nature of Business",
      ),
    );
  }

  Widget _businessSectorField() {
    return PrivoTextFormField(
      readOnly: true,
      onTap: logic.onBusinessSectorFieldTapped,
      id: logic.BUSINESS_SECTOR_ID,
      prefixSVGIcon: Res.businessSectorIcon,
      onChanged: (_) => logic.isFormValid(),
      controller: logic.businessSectorController,
      enabled: logic.isBusinessSectorEnabled,
      decoration: textFieldDecoration(
          label: "Business Sector",
          suffixIcon: const Icon(
            Icons.chevron_right,
            size: 20,
          )),
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

  Widget _body() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 16),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            logic.isTopUp
                ? _topupAddressSectionInfo()
                : _additionalBusinessDetailsForm(),
            const VerticalSpacer(24),
            _sectionHeader(logic.isTopUp ? "Residence" : "Address Details"),
            const VerticalSpacer(12),
            _residenceAddressTile(),
            const VerticalSpacer(16),
            logic.isTopUp ? _businessSectionHeader() : const SizedBox(),
            _officeAddressTile(),
            const VerticalSpacer(52),
            _computeDocSection(),
          ],
        ),
      ),
    );
  }

  Widget _businessSectionHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: _sectionHeader("Business"),
    );
  }

  Widget _topupAddressSectionInfo() {
    return const Text(
      "Please update and verify your address if it has changed since you applied for your current Small Business Loan",
      style: TextStyle(
        color: darkBlueColor,
        fontSize: 12,
      ),
    );
  }

  Widget _additionalBusinessDetailsForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _titleWidget(),
        const VerticalSpacer(40),
        _udyamTextField(),
        const VerticalSpacer(40),
        _natureOfBusinessField(),
        const VerticalSpacer(40),
        _businessSectorField(),
        const VerticalSpacer(32),
      ],
    );
  }

  Widget _computeDocSection() {
    return logic.isTopUp ? _topupDocSection() : _sbdDocSection();
  }

  Widget _officeAddressTile() {
    return GetBuilder<AdditionalBusinessDetailsLogic>(
        id: logic.OFFICE_ADDRESS_ID,
        builder: (logic) {
          if (logic.isOfficeAddressFormValid) {
            return _filledOfficeAddressWidget();
          }
          return AddressDetailsTile(
            title: "Business",
            subTitle: "Operational & Registered Address",
            onTap: logic.onOfficeAddressTileTapped,
            isPending: logic.isOfficeAddressPending(),
          );
        });
  }

  Widget _residenceAddressTile() {
    return GetBuilder<AdditionalBusinessDetailsLogic>(
        id: logic.RESIDENCE_ADDRESS_ID,
        builder: (logic) {
          if (logic.isResidenceAddressValid) {
            return _filledResidenceAddressWidget();
          }
          return AddressDetailsTile(
            title: "Residence",
            subTitle: "Corresponding Address",
            onTap: logic.onResidenceAddressTileTapped,
            isPending: logic.isResidenceAddressPending(),
          );
        });
  }

  Widget _filledResidenceAddressWidget() {
    return AddressFilledWidget(
      onEditTapped: logic.onResidenceAddressTileTapped,
      addressList: [
        AddressWithProofWidget(
          title: "Corresponding Address",
          address: logic.correspondingAddress,
          taggedDocs: logic.isTopUp
              ? []
              : logic.documentTypeListModel.linkedIndividual
                  .correspondenceAddress.taggedDocs,
        ),
      ],
    );
  }

  Widget _filledOfficeAddressWidget() {
    return AddressFilledWidget(
      onEditTapped: logic.onOfficeAddressTileTapped,
      addressList: [
        AddressWithProofWidget(
          title: "Registered Address",
          address: logic.submittedRegisteredAddress,
          taggedDocs: logic.isTopUp
              ? []
              : logic.documentTypeListModel.linkedBusiness.registeredAddress
                  .taggedDocs,
        ),
        AddressWithProofWidget(
          title: "Operational Address",
          address: logic.operationalAddress,
          taggedDocs: logic.isTopUp
              ? []
              : logic.documentTypeListModel.linkedBusiness.registeredAddress
                  .taggedDocs,
        ),
      ],
      showIcon: logic.showOrHideIcon(),
    );
  }

  Widget _sbdDocSection() {
    return DocumentSection(
      isEnabled: !logic.isButtonLoading,
      documentUploadTileDetailsList: [
        logic.ownershipDocumentUploadTileDetails,
        logic.gstDocumentUploadTileDetails,
        logic.udyamDocumentUploadTileDetails,
      ],
    );
  }

  Widget _topupDocSection() {
    return DocumentSection(
      isEnabled: !logic.isButtonLoading,
      infoText:
          "Upload files PDF, JPEG, PNG formats under 20 MB. Ensure clarity and name files descriptively. Please upload the latest documents that are not more than 60 days old.",
      documentUploadTileDetailsList: [
        logic.correspondenceAddressDocumentUploadTileDetails,
        logic.registeredAddressDocumentUploadTileDetails,
        logic.operationalAddressDocumentUploadTileDetails,
      ],
    );
  }
}
