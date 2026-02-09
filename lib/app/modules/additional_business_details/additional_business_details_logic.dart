// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:privo/app/api/api_error_mixin.dart';
import 'package:privo/app/api/response_model.dart';
import 'package:privo/app/common_widgets/bottom_sheet_widget.dart';
import 'package:privo/app/common_widgets/forms/model/address_form_controller.dart';
import 'package:privo/app/data/provider/auth_provider.dart';
import 'package:privo/app/data/repository/on_boarding_repository/additional_business_details_repository.dart';
import 'package:privo/app/data/repository/on_boarding_repository/sequence_engine_repository.dart';
import 'package:privo/app/firebase/analytics.dart';
import 'package:privo/app/mixin/app_analytics_mixin.dart';
import 'package:privo/app/models/additional_business_details_model.dart';
import 'package:privo/app/models/check_app_form_model.dart';
import 'package:privo/app/models/document_type_list_model.dart';
import 'package:privo/app/models/sequence_engine_model.dart';
import 'package:privo/app/modules/additional_business_details/additional_business_details_analytics_mixin.dart';
import 'package:privo/app/modules/additional_business_details/additional_business_details_navigation.dart';
import 'package:privo/app/modules/additional_business_details/model/address_details.dart';
import 'package:privo/app/modules/additional_business_details/widgets/address_details_screen.dart';
import 'package:privo/app/modules/additional_business_details/widgets/document_consent_bottom_sheet.dart';
import 'package:privo/app/modules/document_upload_tile/document_upload_tile_logic.dart';
import 'package:privo/app/modules/document_upload_tile/model/document_upload_tile_details.dart';
import 'package:privo/app/modules/know_more_and_get_started/helper/document_info_helper_mixin.dart';
import 'package:privo/app/modules/know_more_and_get_started/model/document_info_bottom_sheet_model.dart';
import 'package:privo/app/modules/know_more_and_get_started/widgets/document_info_tile.dart';
import 'package:privo/app/modules/know_more_and_get_started/widgets/document_info_tile_with_image.dart';
import 'package:privo/app/modules/on_boarding/mixins/app_form_mixin.dart';
import 'package:privo/app/modules/on_boarding/mixins/on_boarding_mixin.dart';
import 'package:privo/app/modules/on_boarding/widgets/search_screen/search_screen_logic.dart';
import 'package:privo/app/routes/app_pages.dart';
import 'package:privo/app/services/lpc_service.dart';
import 'package:privo/app/utils/error_logger_mixin.dart';

import 'new_address_screen.dart';

enum AddressDetailsState { residence, business }

enum UploadState { uploading, uploaded, failed }
enum VerifyState { screenLoading, verifyPersonalDetails, additionalBdScreen }

enum AddressSameOption { yes, no }

enum ConsentState { declaration, docConsent,topUpDocConsent, none }

class AdditionalBusinessDetailsLogic extends GetxController
    with
        DocumentInfoHelperMixin,
        OnBoardingMixin,
        ApiErrorMixin,
        AppFormMixin,
        ErrorLoggerMixin,
        AppAnalyticsMixin,
        AdditionalBusinessDetailsAnalyticsMixin {
  late final String UDYAM_FIELD_ID = "udyam_field_id";
  late final String NATURE_OF_BUSINESS_ID = "nature_of_business_id";
  late final String BUSINESS_SECTOR_ID = "business_sector_id";

  late final String BUTTON_ID = "button_id";
  late final String ADDRESS_BUTTON_ID = "address_button_id";
  late final String CONSENT_BUTTON_ID = "consent_button_id";
  late final String DOCUMENT_SECTION_ID = "document_section_id";
  late final String RESIDENCE_ADDRESS_ID = "residence_address_id";
  late final String CORRESPONDENCE_ADDRESS_FORM_ID =
      "correspondence_address_form";
  late final String REGISTERED_ADDRESS_ID = "registered_address_id";
  late final String REGISTERED_ADDRESS_FORM_ID =
      "registered_address_form_same_oper_addr";
  late final String REGISTERED_ADDRESS_SAME_AS_OP_ADDRESS_FORM_ID =
      "registered_address_form";
  late final String OPERATIONAL_ADDRESS_FORM_ID = "operational_address_form";
  late final String OFFICE_ADDRESS_ID = "office_address_id";
  late final String UPLOAD_PROGRESS_ID = "upload_progress_id";
  late final String NEW_ADDRESS_BUTTON_ID = "NEW_ADDRESS_BUTTON_ID";
  late final String NEW_ADDRESS_WIDGET = "NEW_ADDRESS_WIDGET";

  late final String ADDITIONAL_BUSINESS_DETAILS_SCREEN =
      "additional_business_details_screen";

  late String loanAppFormId = AppAuthProvider.appFormID;
  late String loanAppFormLpc;
  late String loanApplicantId;

  bool _isPrefilled = false;

  VerifyState verifyState = VerifyState.screenLoading;

  AddressSameOption? selectedOption = AddressSameOption.yes;

  ConsentState consentState = ConsentState.docConsent;

  AddressDetailsState _addressDetailsState = AddressDetailsState.residence;

  AddressDetailsState get addressDetailsState => _addressDetailsState;

  OnboardingNavigationAdditionalBusinessDetails?
      onBoardingAdditionalBusinessDetailsNavigation;

  AdditionalBusinessDetailsLogic(
      {this.onBoardingAdditionalBusinessDetailsNavigation});

  final AdditionalBusinessDetailsRepository
      _additionalBusinessDetailsRepository =
      AdditionalBusinessDetailsRepository();

  late SequenceEngineModel sequenceEngineModel;

  final TextEditingController udyamController = TextEditingController();
  final TextEditingController natureOfBusinessController =
      TextEditingController();
  final TextEditingController businessSectorController =
      TextEditingController();

  final AddressFormController correspondenceAddressController =
      AddressFormController();
  final AddressFormController registeredAddressController =
      AddressFormController();
  final AddressFormController operationalAddressController =
      AddressFormController();

  late final AddressDetails correspondingAddress;
  late final AddressDetails operationalAddress;
  late final AddressDetails registeredAddress;

  AddressDetails get submittedRegisteredAddress =>
      isRegisteredAddSameAsOperationsAddr
          ? operationalAddress
          : registeredAddress;

  final GlobalKey<FormState> correspondenceAddressFormKey =
      GlobalKey<FormState>();
  final GlobalKey<FormState> registeredAddressFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> registeredAddressSameAsOpAddFormKey =
      GlobalKey<FormState>();
  final GlobalKey<FormState> operationalAddressFormKey = GlobalKey<FormState>();

  bool _newAddressButtonEnabled = true;

  bool get newAddressButtonEnabled => _newAddressButtonEnabled;

  set newAddressButtonEnabled(bool value) {
    _newAddressButtonEnabled = value;
    if (selectedOption == AddressSameOption.no) {
      _newAddressButtonEnabled = isResidenceAddressCTAEnabled;
      update([CORRESPONDENCE_ADDRESS_FORM_ID, NEW_ADDRESS_BUTTON_ID]);
    }
    update([NEW_ADDRESS_BUTTON_ID, NEW_ADDRESS_WIDGET]);
  }

  bool _isNewAddressButtonLoading = false;

  bool get isNewAddressButtonLoading => _isNewAddressButtonLoading;

  set isNewAddressButtonLoading(bool value) {
    _isNewAddressButtonLoading = value;
    update([NEW_ADDRESS_BUTTON_ID]);
  }

  bool _isButtonEnabled = false;

  bool get isButtonEnabled => _isButtonEnabled;

  set isButtonEnabled(bool value) {
    _isButtonEnabled = value;
    update([BUTTON_ID]);
  }

  bool _isButtonLoading = false;

  bool get isButtonLoading => _isButtonLoading;

  set isButtonLoading(bool value) {
    _isButtonLoading = value;
    onBoardingAdditionalBusinessDetailsNavigation?.toggleBack(
        isBackDisabled: value);
    update(); // Need to rebuild complete screen to disable/enable other user actions
  }

  bool _isResidenceAddressCTAEnabled = false;

  bool get isResidenceAddressCTAEnabled => _isResidenceAddressCTAEnabled;

  set isResidenceAddressCTAEnabled(bool value) {
    _isResidenceAddressCTAEnabled = value;
    update([ADDRESS_BUTTON_ID, NEW_ADDRESS_BUTTON_ID, NEW_ADDRESS_WIDGET]);
  }

  bool _isOfficeAddressCTAEnabled = false;

  bool get isOfficeAddressCTAEnabled => _isOfficeAddressCTAEnabled;

  set isOfficeAddressCTAEnabled(bool value) {
    _isOfficeAddressCTAEnabled = value;
    update([ADDRESS_BUTTON_ID]);
  }

  bool isConsentButtonLoading = false;

  bool get consentButtonLoading => isConsentButtonLoading;

  set consentButtonLoading(bool value) {
    isConsentButtonLoading = value;
    update([CONSENT_BUTTON_ID]);
  }

  int _uploadProgress = 0;

  int get uploadProgress => _uploadProgress;

  set uploadProgress(int value) {
    _uploadProgress = value;
    update([UPLOAD_PROGRESS_ID]);
  }

  bool get isTopUp => LPCService.instance.isLpcCardTopUp;

  bool _isRegisteredAddSameAsOperationsAddr = false;

  bool get isRegisteredAddSameAsOperationsAddr =>
      _isRegisteredAddSameAsOperationsAddr;

  set isRegisteredAddSameAsOperationsAddr(bool value) {
    _isRegisteredAddSameAsOperationsAddr = value;
    onOfficeAddressChanged();
    logSameAsOperationalClicked();
    update([REGISTERED_ADDRESS_ID]);
  }

  late DocumentTypeListModel documentTypeListModel;
  late AdditionalBusinessDetailsModel additionalBusinessDetailsModel;

  onCorrespondenceAddressChanged() {
    isResidenceAddressCTAEnabled = correspondenceAddressController.isValid() &&
        (isResidenceAddressUploaded || isTopUp);
    isFormValid();
  }

  onOfficeAddressChanged() {
    isOfficeAddressCTAEnabled = operationalAddressController.isValid() &&
        isRegisteredAddressValid() &&
        (isRegisteredOfficeAddressUploaded || isTopUp) &&
        (isOperationalAddressUploaded || isTopUp);
    isFormValid();
  }

  bool isRegisteredAddressValid() {
    if (_isRegisteredAddSameAsOperationsAddr) {
      return true;
    }
    return registeredAddressController.isValid();
  }

  onSelectedCorrespondenceAddressChanged() {
    _isPrefilled = false;
    _updateAddressButtonStates();
  }

  void _updateAddressButtonStates() {
    final bool isCorrespondenceAddressValid =
        correspondenceAddressController.isValid();
    final bool isOperationalAddressValid =
        operationalAddressController.isValid();

    isResidenceAddressCTAEnabled =
        isCorrespondenceAddressValid && isOperationalAddressValid && isTopUp;

    newAddressButtonEnabled =
        _areAllAddressFieldsFilled(correspondenceAddressController) &&
            _areAllAddressFieldsFilled(operationalAddressController) &&
            isTopUp;
  }

  bool _areAllAddressFieldsFilled(AddressFormController controller) {
    return controller.addressLine1Controller.text.isNotEmpty &&
        controller.addressLine2Controller.text.isNotEmpty &&
        controller.pincodeController.text.isNotEmpty;
  }

  onAfterLayout() {
    onBoardingAdditionalBusinessDetailsNavigation?.toggleBack(
        isBackDisabled: false);
    _getAdditionalBusinessDetails();
  }

  _getAdditionalBusinessDetails() async {
    verifyState = VerifyState.screenLoading;
    AdditionalBusinessDetailsModel _additionalBusinessDetails =
        await _additionalBusinessDetailsRepository
            .getAdditionalBusinessDetails();
    switch (_additionalBusinessDetails.apiResponse.state) {
      case ResponseState.success:
        additionalBusinessDetailsModel = _additionalBusinessDetails;
        if (isTopUp && additionalBusinessDetailsModel.reKycToBeDone) {
          verifyState = VerifyState.verifyPersonalDetails;
        } else {
          await _fetchDocumentTypeListData();
        }
        update();
        break;
      default:
        handleAPIError(
          _additionalBusinessDetails.apiResponse,
          screenName: ADDITIONAL_BUSINESS_DETAILS_SCREEN,
          retry: _getAdditionalBusinessDetails,
        );
    }
  }

  prefillData() {
    if (_isPrefilled) return;

    correspondenceAddressController.prefillAddressData(
        additionalBusinessDetailsModel.correspondingAddress);
    correspondingAddress = additionalBusinessDetailsModel.correspondingAddress;
    correspondenceAddressController.isPincodeEditable = isTopUp;

    operationalAddressController
        .prefillAddressData(additionalBusinessDetailsModel.operationalAddress);
    operationalAddress = additionalBusinessDetailsModel.operationalAddress;
    operationalAddressController.isPincodeEditable = isTopUp;

    registeredAddressController
        .prefillAddressData(additionalBusinessDetailsModel.registeredAddress);
    registeredAddress = additionalBusinessDetailsModel.registeredAddress;

    udyamController.text = additionalBusinessDetailsModel.udyamNumber;
    natureOfBusinessController.text =
        additionalBusinessDetailsModel.natureOfBusiness;
    businessSectorController.text = additionalBusinessDetailsModel.sector;

    onCorrespondenceAddressChanged();
    onOfficeAddressChanged();
    _isPrefilled = true;
  }

  onConsentAgreed() async {
    consentButtonLoading = true;
    if (selectedOption == AddressSameOption.no &&
        additionalBusinessDetailsModel.reconfirmAddressNo == false) {
      _updateAddress();
    }
    await prefillData();
    logDocumentConsentSubmitted();
    additionalBusinessDetailsModel.isConsentAgreed = true;
    Map<String, dynamic> body = _computeSelectedDocBody();

    ApiResponse apiResponse =
        await _additionalBusinessDetailsRepository.postDocumentConsent(body);

    switch (apiResponse.state) {
      case ResponseState.success:
        consentButtonLoading = false;
        Get.back();
        if (isTopUp) {
          verifyState = VerifyState.additionalBdScreen;
        }
        update();
        break;
      default:
        handleAPIError(
          apiResponse,
          screenName: ADDITIONAL_BUSINESS_DETAILS_SCREEN,
          retry: onConsentAgreed,
        );
    }
  }

  void _updateAddress() {
     additionalBusinessDetailsModel.correspondingAddress
        .updateAddressData(correspondenceAddressController);
    additionalBusinessDetailsModel.operationalAddress
        .updateAddressData(operationalAddressController);
  }

  Map<String, dynamic> _computeSelectedDocBody() {
    Map<String, dynamic> body;
    if (!isTopUp) {
      body = {
        "isAgreed": true,
      };
    } else {
      body = {
        "confirmAddress": selectedOption == AddressSameOption.yes &&
                additionalBusinessDetailsModel.reKycToBeDone
            ? "Yes"
            : "No",
        "isAgreed": true,
      };
    }
    return body;
  }

  closeBottomSheet()  {
    Get.back();
    Get.back();
  }

  bool isResidenceAddressPending() {
    final bool isDocNotAdded = isTopUp ||
        documentTypeListModel
            .linkedIndividual.correspondenceAddress.taggedDocs.isEmpty;
    final bool isAddressEmpty = correspondenceAddressController.isEmpty();

    return !(isAddressEmpty && isDocNotAdded);
  }

  bool isOfficeAddressPending() {
    final bool isOpDocNotAdded = documentTypeListModel
        .linkedBusiness.registeredAddress.taggedDocs.isEmpty;
    final bool isRegDocNotAdded = documentTypeListModel
        .linkedBusiness.registeredAddress.taggedDocs.isEmpty;
    final bool isOpAddressEmpty = operationalAddressController.isEmpty();
    final bool isRegAddressEmpty = isRegisteredAddressEmpty();

    return !(isOpAddressEmpty &&
        isOpDocNotAdded &&
        isRegAddressEmpty &&
        isRegDocNotAdded);
  }

  bool isRegisteredAddressEmpty() {
    if (_isRegisteredAddSameAsOperationsAddr) {
      return true;
    }
    return registeredAddressController.isEmpty();
  }

  _computeConstateWidget() async {
    switch (_computeConsentState()) {
      case ConsentState.declaration:
        _showConsentBottomSheet(
            "Declaration",
            "I hereby confirm that there are no changes in the entity's KYC proof, including address as submitted at the time of the first loan processing.",
            Get.back);
        break;
      case ConsentState.docConsent:
        _showConsentBottomSheet(
          "Document Consent",
          "I/We am/are providing digital / soft copies of my KYC documents (including Bank Account Statement, Income Tax Return) as required to Kisetsu Saison Finance (India) Private Limited and confirm that such digital documents cannot be physically self-attested by me",
          closeBottomSheet,
        );
        break;
      case ConsentState.topUpDocConsent:
        _showConsentBottomSheet(
          "Document Consent",
          "I/We am/are providing digital / soft copies of my KYC documents (including Bank Account Statement, Income Tax Return) as required to Kisetsu Saison Finance (India) Private Limited and confirm that such digital documents cannot be physically self-attested by me",
          Get.back,
        );
        break;
      case ConsentState.none:
        if (selectedOption == AddressSameOption.no &&
            additionalBusinessDetailsModel.reconfirmAddressNo) {
          _updateAddress();
        }
        await prefillData();
        verifyState = VerifyState.additionalBdScreen;
        break;
    }
  }

  ConsentState _computeConsentState() {
    isNewAddressButtonLoading = false;
    final reKycCondition = additionalBusinessDetailsModel.reKycToBeDone;
    final reconfirmYes = additionalBusinessDetailsModel.reconfirmAddressYes;
    final reconfirmNo = additionalBusinessDetailsModel.reconfirmAddressNo;

    if ((!isTopUp && !additionalBusinessDetailsModel.isConsentAgreed) ||
        (isTopUp && !reKycCondition && !reconfirmNo)) {
      return ConsentState.docConsent;
    }

    if (isTopUp) {
      if ((selectedOption == AddressSameOption.no) && !reconfirmNo) {
        return ConsentState.topUpDocConsent;
      } else if (selectedOption == AddressSameOption.yes &&
          !reconfirmYes &&
          reKycCondition) {
        return ConsentState.declaration;
      }
    }
    return ConsentState.none;
  }

  void _showConsentBottomSheet(String title, String consentText,Function() onBackClicked) {
    Get.bottomSheet(
      DocumentConsentBottomSheet(
        title: title,
        consentText: consentText,
        onBackClicked: () => onBackClicked()
      ),
      enableDrag: false,
      isDismissible: false,
    );
  }

  preValidateAddressFieldsForTopUp() {
    if (isTopUp) {
      correspondenceAddressFormKey.currentState?.validate();
      operationalAddressFormKey.currentState?.validate();
      registeredAddressFormKey.currentState?.validate();
    }
  }

  Future _fetchDocumentTypeListData(
      {bool showConsent = true, bool showPreFilledValue = true}) async {
    _computeLoanId();
    DocumentTypeListModel model = await _additionalBusinessDetailsRepository
        .getDocumentTypeList(loanApplicantId, loanAppFormLpc, loanAppFormId);
    switch (model.apiResponse.state) {
      case ResponseState.success:
        documentTypeListModel = model;
        if (!isTopUp || !additionalBusinessDetailsModel.reKycToBeDone) {
          await prefillData();
        }
        logAddBusinessLoaded();
        if (showConsent) _computeScreen(showPreFilledValue: showPreFilledValue);
        break;
      default:
        handleAPIError(model.apiResponse,
            screenName: ADDITIONAL_BUSINESS_DETAILS_SCREEN,
            retry: _fetchDocumentTypeListData);
    }
  }

  void _computeLoanId() {
    if (!isTopUp) {
      _reKycNotRequired();
    } else {
      _topUpLoanIds();
    }
  }

  void _topUpLoanIds() {
    if (additionalBusinessDetailsModel.reKycToBeDone == false) {
      _reKycNotRequired();
    } else {
      _computeReKycFields();
    }
  }

  void _computeReKycFields() {
    switch (selectedOption) {
      case AddressSameOption.yes:
        loanAppFormId = additionalBusinessDetailsModel.loanAppFormId;
        loanAppFormLpc = additionalBusinessDetailsModel.loanAppFormLpc;
        loanApplicantId = additionalBusinessDetailsModel.oldApplicantId;
        break;
      case AddressSameOption.no:
      default:
        _reKycNotRequired();
        break;
    }
  }

  void _reKycNotRequired() {
    loanAppFormId = AppAuthProvider.appFormID;
    loanAppFormLpc = additionalBusinessDetailsModel.lpc;
    loanApplicantId = additionalBusinessDetailsModel.applicantId;
  }

  Future<void> _computeScreen({bool showPreFilledValue = false}) async {
    if (!isTopUp || additionalBusinessDetailsModel.reKycToBeDone == false) {
      verifyState = VerifyState.additionalBdScreen;
      update();
      _computeConstateWidget();
    } else {
      _computeConstateWidget();
      update();
    }
  }

  Future onAllFileDeleted() async {
    await _fetchDocumentTypeListData(showConsent: false );
    update();
  }

  String computeAddressScreenTitle() {
    switch (addressDetailsState) {
      case AddressDetailsState.residence:
        return "Residence Address Details";
      case AddressDetailsState.business:
        return "Business Address Details";
    }
  }

  onResidenceAddressTileTapped() async {
    if (isButtonLoading) return;
    _addressDetailsState = AddressDetailsState.residence;
    logAddressSection(AddressDetailsState.residence);
    await Get.to(() => const AddressDetailsScreen());
    isFormValid();
    update([RESIDENCE_ADDRESS_ID]);
  }

  onOfficeAddressTileTapped() async {
    if (isButtonLoading) return;
    _addressDetailsState = AddressDetailsState.business;
    logAddressSection(AddressDetailsState.business);
    await Get.to(() => const AddressDetailsScreen());
    isFormValid();
    update([OFFICE_ADDRESS_ID]);
  }

  onUdyamInfoTapped() {
    showDocumentInfoWithImage(udyamCertificateInfo);
  }

  showDocumentInfoWithImage(DocumentTypeInfoModelWithImage docInfo) {
    Get.bottomSheet(BottomSheetWidget(
      child: DocumentInfoTileWithImage(
        docInfo: docInfo,
      ),
    ));
  }

  showDocumentInfo(DocumentTypeInfoModel docInfo) {
    Get.bottomSheet(BottomSheetWidget(
      child: DocumentInfoTile(
        showDocIcon: true,
        docInfo: docInfo,
      ),
    ));
  }

  onRegisteredOfficeInfoTapped() {
    showDocumentInfo(registeredOfficeAddressProofInfo);
  }

  onOperationalOfficeInfoTapped() {
    showDocumentInfo(operationalAddressProofInfo);
  }

  onGstInfoTapped() {
    showDocumentInfoWithImage(gstCertificateInfo);
  }

  onOwnershipInfoTapped() {
    showDocumentInfo(ownershipProofInfo);
  }

  onCorrespondenceProofInfoTapped() {
    showDocumentInfo(correspondenceProofInfo);
  }

  String computeGSTTitle() {
    if (additionalBusinessDetailsModel.isGstDocumentMandatory) {
      return "GST Certificate";
    } else {
      return "GST Certificate (Optional)";
    }
  }

  void onBusinessSectorFieldTapped() async {
    if (isButtonLoading) return;
    Get.focusScope!.unfocus();
    var searchResult = await Get.toNamed(
      Routes.SEARCH_SCREEN,
      arguments: {'search_type': SearchType.businessSector},
    );
    if (searchResult != null) {
      Get.log("searchResult = ${searchResult.toString()}");
      businessSectorController.text = searchResult;
      isFormValid();
    }
    removeCurrentFocus();
  }

  ///To remove focus from the field
  void removeCurrentFocus() {
    if (Get.focusScope != null) Get.focusScope!.unfocus();
  }

  Future<void> postAdditionalBusinessDetails() async {
    isButtonLoading = true;
    logAddBusinessSubmitted();
    late CheckAppFormModel checkAppFormModel;
    _getSequenceEngineModel();
    checkAppFormModel =
        await SequenceEngineRepository(sequenceEngineModel).makeHttpRequest(
      body: _computeBody(),
    );

    switch (checkAppFormModel.apiResponse.state) {
      case ResponseState.success:
        await _onAdditionalBusinessDetailsSuccess(checkAppFormModel);
        break;
      default:
        isButtonLoading = false;
        handleAPIError(
          checkAppFormModel.apiResponse,
          screenName: ADDITIONAL_BUSINESS_DETAILS_SCREEN,
          retry: postAdditionalBusinessDetails,
        );
    }
  }

  bool get isNatureOfBusinessEnabled => !isButtonLoading;

  bool get isBusinessSectorEnabled => !isButtonLoading;

  DocumentUploadTileDetails get registeredAddressDocumentUploadTileDetails =>
      DocumentUploadTileDetails(
        tag: DocumentUploadTileLogic.REGISTERED_ADDRESS_TAG,
        title: "Registered Address Proof",
        docSection: documentTypeListModel.linkedBusiness.registeredAddress,
        onInfoTapped: onRegisteredOfficeInfoTapped,
        onAllFileDeleted: onAllFileDeleted,
        onChanged: onOfficeAddressChanged,
        entityId: documentTypeListModel.linkedBusiness.entityId,
          hideAddDeleteIcon: showOrHideIcon());

  DocumentUploadTileDetails
      get correspondenceAddressDocumentUploadTileDetails =>
          DocumentUploadTileDetails(
            tag: DocumentUploadTileLogic.CORRESPONDENCE_ADDRESS_TAG,
            docSection:
                documentTypeListModel.linkedIndividual.correspondenceAddress,
            onAllFileDeleted: onAllFileDeleted,
            entityId: documentTypeListModel.linkedIndividual.entityId,
            title: "Correspondence Address Proof",
            onInfoTapped: onCorrespondenceProofInfoTapped,
            onChanged: onCorrespondenceAddressChanged,
              hideAddDeleteIcon: showOrHideIcon());

  DocumentUploadTileDetails get operationalAddressDocumentUploadTileDetails =>
      DocumentUploadTileDetails(
        tag: DocumentUploadTileLogic.OPERATIONAL_ADDRESS_TAG,
        docSection: documentTypeListModel.linkedBusiness.operationalAddress,
        title: "Operational Address Proof",
        onAllFileDeleted: onAllFileDeleted,
        onInfoTapped: onOperationalOfficeInfoTapped,
        onChanged: onOfficeAddressChanged,
        entityId: documentTypeListModel.linkedBusiness.entityId,
          hideAddDeleteIcon: showOrHideIcon());

  DocumentUploadTileDetails get ownershipDocumentUploadTileDetails =>
      DocumentUploadTileDetails(
        tag: DocumentUploadTileLogic.OWNERSHIP_PROOF_TAG,
        title: "Ownership Proof",
        onInfoTapped: onOwnershipInfoTapped,
        onAllFileDeleted: onAllFileDeleted,
        docSection: documentTypeListModel.linkedBusiness.ownershipProof,
        entityId: documentTypeListModel.linkedBusiness.entityId,
        onChanged: isFormValid,
          hideAddDeleteIcon: showOrHideIcon());

  DocumentUploadTileDetails get gstDocumentUploadTileDetails =>
      DocumentUploadTileDetails(
        tag: DocumentUploadTileLogic.GST_CERTIFICATE_TAG,
        docSection: documentTypeListModel.linkedBusiness.gst,
        onInfoTapped: onGstInfoTapped,
        entityId: documentTypeListModel.linkedBusiness.entityId,
        title: computeGSTTitle(),
        onAllFileDeleted: onAllFileDeleted,
        onChanged: isFormValid,
          hideAddDeleteIcon: showOrHideIcon());

  DocumentUploadTileDetails get udyamDocumentUploadTileDetails =>
      DocumentUploadTileDetails(
        tag: DocumentUploadTileLogic.UDYAM_TAG,
        docSection: documentTypeListModel.linkedBusiness.udyamCertificate,
        entityId: documentTypeListModel.linkedBusiness.entityId,
        onInfoTapped: onUdyamInfoTapped,
        title: "Udhyam Certificate (Optional)",
        onAllFileDeleted: onAllFileDeleted,
          onChanged: isFormValid,
          hideAddDeleteIcon: showOrHideIcon());

  Future<void> _onAdditionalBusinessDetailsSuccess(
      CheckAppFormModel checkAppFormModel) async {
    isButtonLoading = false;
    if (onBoardingAdditionalBusinessDetailsNavigation != null) {
      navigateToNextScreen(checkAppFormModel);
    } else {
      await AppAnalytics.navigationObjectNull(
          ADDITIONAL_BUSINESS_DETAILS_SCREEN);
    }
  }

  navigateToNextScreen(CheckAppFormModel checkAppFormModel) {
    if (onBoardingAdditionalBusinessDetailsNavigation != null &&
        checkAppFormModel.sequenceEngine != null) {
      onBoardingAdditionalBusinessDetailsNavigation!.navigateUserToAppStage(
          sequenceEngineModel: checkAppFormModel.sequenceEngine!);
    } else {
      onNavigationDetailsNull(ADDITIONAL_BUSINESS_DETAILS_SCREEN);
    }
  }

  _getSequenceEngineModel() {
    if (onBoardingAdditionalBusinessDetailsNavigation != null) {
      sequenceEngineModel = onBoardingAdditionalBusinessDetailsNavigation!
          .getSequenceEngineDetails();
    } else {
      onNavigationDetailsNull(ADDITIONAL_BUSINESS_DETAILS_SCREEN);
    }
  }

  Map<String, dynamic> _computeBody() {
    Map<String, dynamic> body = {
      "nature": natureOfBusinessController.text,
      "sector": businessSectorController.text,
      "addressDetails": [
        correspondingAddress.toJson(),
        operationalAddress.toJson(),
        _getRegisteredAddressBody(),
      ]
    };

    if (udyamController.text.isNotEmpty) {
      body['udyam'] = "UDYAM-${udyamController.text}";
    }

    return body;
  }

  Map _getRegisteredAddressBody() {
    if (isRegisteredAddSameAsOperationsAddr) {
      Map address = operationalAddress.toJson();
      address['type'] = "Registered";
      return address;
    }
    return registeredAddress.toJson();
  }

  onResidenceAddressSaved() {
    correspondingAddress.updateAddressData(correspondenceAddressController);
    logAddressLineInput("correspondence address");
    Get.back();
  }

  onOfficeAddressSaved() {
    operationalAddress.updateAddressData(operationalAddressController);
    registeredAddress.updateAddressData(registeredAddressController);
    logAddressLineInput("registered business address");
    Get.back();
  }

  String? udyamValidation(String? value) {
    if (value == null || value.isEmpty) {
      return null;
    }
    if (!RegExp(r'^[A-Za-z]{2}-\d{2}-\d{7}$').hasMatch(value)) {
      return "Enter a valid Udyam number";
    }
    return null;
  }

  isFormValid() {
    switch (isTopUp) {
      case true:
        if (additionalBusinessDetailsModel.reKycToBeDone) {
          _computeReKycCTAEnable();
        } else {
          isButtonEnabled = isTopUpDetailsValid;
        }
        break;
      default:
        isButtonEnabled = isSBDDetailsValid;
    }
  }

  void _computeReKycCTAEnable() {
    isButtonEnabled =
        selectedOption == AddressSameOption.yes ? true : isTopUpDetailsValid;
  }

  bool get isTopUpDetailsValid =>
      isResidenceAddressValid &&
      isOfficeAddressFormValid &&
      isAddressDocsUploaded;

  bool get isSBDDetailsValid =>
      isFormFieldsValid &&
      isResidenceAddressValid &&
      isOfficeAddressFormValid &&
      isOwnershipProofUploaded &&
      isGstProofUploaded;

  bool get isAddressDocsUploaded =>
      isResidenceAddressUploaded &&
      isRegisteredOfficeAddressUploaded &&
      isOperationalAddressUploaded;

  bool get isOfficeAddressFormValid =>
      operationalAddress.isCompleted() &&
      isRegisteredAddressValid() &&
      (isRegisteredOfficeAddressUploaded || isTopUp) &&
      (isOperationalAddressUploaded || isTopUp);

  bool get isFormFieldsValid =>
      businessSectorController.text.isNotEmpty &&
      natureOfBusinessController.text.isNotEmpty &&
      udyamValidation(udyamController.text) == null;

  bool get isResidenceAddressValid =>
      correspondingAddress.isCompleted() &&
      (isResidenceAddressUploaded || isTopUp);

  bool get isResidenceAddressUploaded => documentTypeListModel
      .linkedIndividual.correspondenceAddress.taggedDocs.isNotEmpty;

  bool get isRegisteredOfficeAddressUploaded => documentTypeListModel
      .linkedBusiness.registeredAddress.taggedDocs.isNotEmpty;

  bool get isOperationalAddressUploaded => documentTypeListModel
      .linkedBusiness.operationalAddress.taggedDocs.isNotEmpty;

  bool get isGstProofUploaded {
    if (additionalBusinessDetailsModel.isGstDocumentMandatory) {
      return documentTypeListModel.linkedBusiness.gst.taggedDocs.isNotEmpty;
    }
    return true;
  }

  bool get isOwnershipProofUploaded =>
      documentTypeListModel.linkedBusiness.ownershipProof.taggedDocs.isNotEmpty;

  void onChangeSelectedYes(AddressSameOption val) {
    selectedOption = val;
    newAddressButtonEnabled = true;
    update();
  }

  void onChangeSelectedNo(AddressSameOption val) {
    correspondenceAddressController.reset();
    operationalAddressController.reset();
    isResidenceAddressCTAEnabled = false;
    newAddressButtonEnabled = isResidenceAddressCTAEnabled;
    selectedOption = val;
    NewAddressScreen();
    update();
  }

  onReKycButtonPressed() {
    isNewAddressButtonLoading = true;
    if (selectedOption == AddressSameOption.no) {
      _fetchDocumentTypeListData(showPreFilledValue: false);
    } else {
      _fetchDocumentTypeListData();
    }
  }

  bool showOrHideIcon() {
    if (!isTopUp || additionalBusinessDetailsModel.reKycToBeDone == false) {
      return true;
    } else {
      switch (selectedOption) {
        case AddressSameOption.yes:
          return false;
        case AddressSameOption.no:
          return true;
        default:
          return true;
      }
    }
  }
}
