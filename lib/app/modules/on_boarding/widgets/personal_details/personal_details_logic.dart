import 'dart:core';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:privo/app/common_widgets/forms/base_field_validator.dart';
import 'package:privo/app/common_widgets/forms/personal_details_field_validators.dart';
import 'package:privo/app/data/repository/credit_report_repository.dart';
import 'package:privo/app/data/repository/on_boarding_repository/sequence_engine_repository.dart';
import 'package:privo/app/data/repository/on_boarding_repository/personal_detail_repository.dart';
import 'package:privo/app/mixin/app_analytics_mixin.dart';
import 'package:privo/app/mixin/personal_details_polling_mixin.dart';
import 'package:privo/app/models/app_form_rejection_model.dart';
import 'package:privo/app/models/check_app_form_model.dart';
import 'package:privo/app/models/experian_consent_model.dart';
import 'package:privo/app/models/home_screen_model.dart';
import 'package:privo/app/models/sequence_engine_model.dart';
import 'package:privo/app/modules/on_boarding/mixins/app_form_mixin.dart';
import 'package:privo/app/modules/on_boarding/user_state_maps.dart';
import 'package:privo/app/modules/on_boarding/widgets/personal_details/personal_details_analytics_mixin.dart';
import 'package:privo/app/modules/on_boarding/widgets/personal_details/personal_details_navigation.dart';
import 'package:privo/app/modules/on_boarding/widgets/personal_details/user_personal_details.dart';
import 'package:privo/app/modules/on_boarding/widgets/personal_details/widgets/experian_consent_widget.dart';
import 'package:privo/app/modules/on_boarding/widgets/personal_details_polling/personal_details_polling_analytics_mixin.dart';
import 'package:privo/app/services/lpc_service.dart';
import 'package:privo/app/services/preprocessor_service/preprocessor_service.dart';
import 'package:privo/app/utils/apps_flyer_constants.dart';
import 'package:privo/app/utils/error_logger_mixin.dart';
import 'package:privo/app/utils/firebase_constants.dart';
import 'package:privo/flavors.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:webengage_flutter/webengage_flutter.dart';
import '../../../../api/api_error_mixin.dart';
import '../../../../api/response_model.dart';
import '../../../../common_widgets/privo_text_editing_controller.dart';
import '../../../../data/provider/auth_provider.dart';
import '../../../../firebase/analytics.dart';
import '../../../../utils/app_functions.dart';
import '../../mixins/on_boarding_mixin.dart';
import '../../mixins/user_details_mixin.dart';
import 'widgets/personal_details_dob_field/personal_details_dob_field_logic.dart';

class PersonalDetailsLogic extends GetxController
    with
        ApiErrorMixin,
        ErrorLoggerMixin,
        OnBoardingMixin,
        UserDetailsMixin,
        AppFormMixin,
        PersonalDetailsPollingMixin,
        AppAnalyticsMixin,
        PersonalDetailsPollingAnalyticsMixin,
        PersonalDetailsAnalyticsMixin,
        BaseFieldValidators,
        PersonalDetailsFieldValidators {
  //PrivoTextEditingControllers for personal details screen

  final UserPersonalDetails _userPersonalDetails = UserPersonalDetails();

  PrivoTextEditingController get fullNameController =>
      _userPersonalDetails.fullNameController;

  PrivoTextEditingController get panController =>
      _userPersonalDetails.panController;

  PrivoTextEditingController get pinCodeController =>
      _userPersonalDetails.pinCodeController;

  PrivoTextEditingController get emailController =>
      _userPersonalDetails.emailController;

  PrivoTextEditingController get residenceTypeController =>
      _userPersonalDetails.residenceTypeController;

  // PrivoTextEditingController get employmentTypeController =>
  //     _userPersonalDetails.employmentTypeController;

  PrivoTextEditingController get dobController =>
      _userPersonalDetails.dobController;

  // String dobActualFormat = '';

  static const String PERSONAL_DETAILS = 'personal_details';

  static const String PERSONAL_DETAILS_POLLING_SCREEN =
      'personal_details_polling';

  // late final String EMPLOYMENT_TYPE_ID = "employment_type_id";

  OnboardingNavigationPersonalDetails? navigationPersonalDetails;

  PersonalDetailsLogic({this.navigationPersonalDetails});

  PersonalDetailRepository personalDetailRepository =
      PersonalDetailRepository();

  CreditReportRepository creditReportRepository = CreditReportRepository();

  bool get isPartnerFlow => navigationPersonalDetails?.isPartnerFlow() ?? false;

  late SequenceEngineModel sequenceEngineModel;

  ///loading state
  bool _isLoading = false;

  /// When Appfrom is loading, to show skeletons
  bool _isDataLoading = true;

  bool get isLoading => _isLoading;

  bool get isDataLoading => _isDataLoading;

  set isLoading(bool value) {
    _isLoading = value;
    update();
    if (navigationPersonalDetails != null) {
      navigationPersonalDetails!.toggleBack(isBackDisabled: isLoading);
    } else {
      onNavigationDetailsNull(PERSONAL_DETAILS);
    }
  }

  // int? get employmentTypeIndex => _userPersonalDetails.employmentTypeIndex;
  //
  // set employmentTypeIndex(int? value) {
  //   _userPersonalDetails.employmentTypeIndex = value;
  //   logEmploymentType(_userPersonalDetails.getEmploymentSelectionType());
  //   employmentTypeController.text =
  //       value == 1 ? "$SALARIED_INDEX" : "$SELF_EMPLOYED_INDEX";
  //   update([EMPLOYMENT_TYPE_ID]);
  // }

  set isDataLoading(bool value) {
    _isDataLoading = value;
    update();
  }

  final personalDetailsFormKey = GlobalKey<FormState>();
  var isPersonalDetailsFormFilled = false;

  ///Function called when personal details text form fields are changed
  void areFieldsValid() {
    isPersonalDetailsFormFilled =
        isFieldValid(nameValidator(fullNameController.text.trim())) &&
            isFieldValid(dobValidator(dobController.text)) &&
            isFieldValid(panValidator(panController.text.trim())) &&
            isFieldValid(pinCodeValidator(pinCodeController.text.trim())) &&
            isFieldValid(emailValidator(emailController.text.trim())) &&
            residenceTypeController.text.isNotEmpty;
    update();
  }

  // Info: For dunamically updating the keyboard type
  // void panNoOnChanged() {
  //   panController.value = TextEditingValue(
  //       text: panController.text.toUpperCase(),
  //       selection: panController.selection);
  //   if (panController.text.length == 5 || panController.text.length == 9) {
  //     panFocusNode.unfocus();
  //     Future.delayed(Duration(milliseconds: 50)).then((value) {
  //       panFocusNode.requestFocus();
  //     });
  //   }
  // }

  onPersonalDetailsContinueTapped() async {
    if (personalDetailsFormKey.currentState!.validate()) {
      await postPersonalInfo();
    }
  }

  // onTapEmploymentType(int index) {
  //   employmentTypeIndex = index;
  //   areFieldsValid();
  // }

  // Info: For dunamically updating the keyboard type
  // TextInputType getTextInputTypeForPan() {
  //   if (panController.text.length >= 5) {
  //     if (panController.text.length >= 9) {
  //       return TextInputType.name;
  //     } else {
  //       return TextInputType.number;
  //     }
  //   }
  //   return TextInputType.name;
  // }

  ///Splits the first and last name for sending to pan verification

  ///Post personal details app form to the server
  postPersonalInfo() async {
    // isLoading = true;
    Get.focusScope!.unfocus();
    logAllFieldsInput();

    if (isPartnerFlow) {
      logPartnerPersonalDetailsContinueCTA();
    } else {
      logPersonalDetailsContinueCTA();
    }
    logPersonalDetailsSubmitted();

    _checkConsentStatus();
  }

  Future _checkConsentStatus() async {
    isLoading = true;
    ExperianConsentModel experianConsentModel =
        await creditReportRepository.checkConsentStatus();

    switch (experianConsentModel.apiResponse.state) {
      case ResponseState.success:
        isLoading = false;
        switch (experianConsentModel.status) {
          case ExperianConsentStatus.absent:
            _openExperianConsentBottomSheet(
              "Consent Updated",
              "There has been a recent update to the existing consent",
            );
            break;
          case ExperianConsentStatus.active:
          case ExperianConsentStatus.expired:
            postPersonalDetails();
            break;
        }
        break;
      default:
        isLoading = false;
        logCreditScoreBCConditionFailed();
        handleAPIError(
          experianConsentModel.apiResponse,
          screenName: PERSONAL_DETAILS,
          retry: _checkConsentStatus,
        );
    }
  }

  _openExperianConsentBottomSheet(String title, String consentInfo) {
    Get.bottomSheet(
      ExperianConsentWidget(
        onContinue: () {
          Get.back();
          postPersonalDetails(sendExperianConsent: true);
        },
        onTnCClicked: onExperianTnCClicked,
        title: title,
        consentInfo: consentInfo,
      ),
    );
  }

  onExperianTnCClicked() {
    launchUrlString(
      F.envVariables.experianTnCUrl,
      mode: LaunchMode.inAppWebView,
    );
  }

  _getSequenceEngineModel() {
    if (navigationPersonalDetails != null) {
      sequenceEngineModel =
          navigationPersonalDetails!.getSequenceEngineDetails();
    } else {
      onNavigationDetailsNull(PERSONAL_DETAILS);
    }
  }

  Future<void> postPersonalDetails({bool sendExperianConsent = false}) async {
    ///Splits name into first name middle name and last name
    isLoading = true;
    Get.log("Posting personal info");

    await AppAuthProvider.setFullName(fullNameController.text);
    await AppAuthProvider.setEmail(emailController.text);
    late CheckAppFormModel checkAppFormModel;
    _getSequenceEngineModel();
    checkAppFormModel =
        await SequenceEngineRepository(sequenceEngineModel).makeHttpRequest(
      body: await computePersonalDetailsApiBody(
        personalDetails: _userPersonalDetails,
        leadDetails: navigationPersonalDetails?.getLeadDetails(),
        sendExperianConsent: sendExperianConsent,
      ),
    );

    switch (checkAppFormModel.apiResponse.state) {
      case ResponseState.success:
        await AppAuthProvider.deleteUTMData();
        AppAnalytics.logAppsFlyerEvent(
            eventName: AppsFlyerConstants.personalDetails);
        AppAnalytics.logFirebaseEvents(eventName: FirebaseConstants.cpcSuccess);

        _setActiveLPC(checkAppFormModel);
        await onAppFormPostSuccess(checkAppFormModel);
        break;
      default:
        isLoading = false;
        handleAPIError(checkAppFormModel.apiResponse,
            screenName: PERSONAL_DETAILS);
    }
  }

  void _setActiveLPC(CheckAppFormModel checkAppFormModel) {
    String lpcString = checkAppFormModel.responseBody['loanProduct'];
    LpcCard lpcCard = LpcCard.decodeResponse({
      "customer_cif": "",
      "loan_product_code": lpcString,
      "loan_product_name": "Credit Saison - Credit Line",
      "appform_created_at":
          DateFormat("yyyy-MM-dd HH:mm:ss").format(DateTime.now()),
      "app_form_id": checkAppFormModel.appFormId,
      "applicant_type": "LinkedIndividual",
      "applicant_party_type": "",
      "applicant_id": "0",
      "appform_status": "",
      "appform_status_numeric": "",
      "visible": true,
      "priority": "0"
    });
    LPCService.instance.activeCard = lpcCard;
    if (navigationPersonalDetails != null) {
      navigationPersonalDetails!.setLoanProductCode(
        AppFunctions().computeLoanProductCode(lpcString),
      );
    } else {
      onNavigationDetailsNull(PERSONAL_DETAILS);
    }
    logAppsFlyerEvent(
      eventName: "PD_Complete_${checkAppFormModel.responseBody['loanProduct']}",
    );
  }

  Future<void> onAppFormPostSuccess(CheckAppFormModel checkAppFormModel) async {
    await AppAuthProvider.setAppFormID(checkAppFormModel.appFormId);
    PreprocessorService(triggerCustomerDeviceDetails: false)
        .checkPreprocessorData(checkAppFormModel: checkAppFormModel);
    // await updateAppVersionNumber(checkAppFormModel.appFormId);

    String firstName =
        getFirstLastName(fullNameController.text.trim())[Name.first] ?? "";
    String email = emailController.text;

    WebEngagePlugin.setUserEmail(emailController.text);
    WebEngagePlugin.setUserFirstName(
        getFirstLastName(fullNameController.text.trim())[Name.first]!);

    logUserAttributes(
      appId: checkAppFormModel.appFormId,
      email: emailController.text,
      firstName: firstName,
      lastname:
          getFirstLastName(fullNameController.text.trim())[Name.last] ?? "",
      phone: await AppAuthProvider.phoneNumber,
    );

    logAppFormStatus();

    if (checkAppFormModel.appFormRejectionModel.isRejected) {
      isLoading = false;
      logPersonalDetailsRejected(firstName, email);
      _navigateToAppFormRejection(checkAppFormModel);
    } else {
      logPersonalDetailsVerified(firstName, email);
      _onDeviceDetailsSuccess(checkAppFormModel);
    }
  }

  void _navigateToAppFormRejection(CheckAppFormModel requestModel) {
    isLoading = false;
    if (navigationPersonalDetails != null) {
      navigationPersonalDetails!.onAppFormRejected(
        model: requestModel.appFormRejectionModel,
      );
    } else {
      onNavigationDetailsNull(PERSONAL_DETAILS);
    }
  }

  Future<void> _onDeviceDetailsSuccess(
      CheckAppFormModel checkAppFormModel) async {
    if (navigationPersonalDetails != null &&
        checkAppFormModel.sequenceEngine != null) {
      if (checkAppFormModel.sequenceEngine!.appState ==
          "$PERSONAL_DETAILS_POLLING") {
        logPersonalDetailsPollingStarted();
        _personalDetailsPolling(checkAppFormModel.sequenceEngine!);
      } else {
        isLoading = false;
        navigateToNextScreen(checkAppFormModel);
      }
    } else {
      await AppAnalytics.navigationObjectNull(PERSONAL_DETAILS);
    }
  }

  updateAppVersionNumber(String appFormId) async {
    await personalDetailRepository.updateAppVersionNumber();
  }

  _personalDetailsPolling(SequenceEngineModel sequenceEngineModel) async {
    await getPersonalDetailsStatus(
        onApiError: (ApiResponse apiResponse) =>
            _onPersonalDetailsPollingError(apiResponse, sequenceEngineModel),
        onRejected: _onAppFormRejectionNavigation,
        onSuccess: _onPersonalDetailsPollingSuccess,
        sequenceEngineModel: sequenceEngineModel,
        requestPayload: sequenceEngineModel.onPolling?.requestPayload ?? {});
  }

  _onPersonalDetailsPollingError(
      ApiResponse apiResponse, SequenceEngineModel sequenceEngineModel) {
    stopPolling();
    handleAPIError(ApiResponse(state: ResponseState.failure, apiResponse: ""),
        screenName: PERSONAL_DETAILS_POLLING_SCREEN,
        retry: () => _personalDetailsPolling(sequenceEngineModel));
  }

  _onPersonalDetailsPollingSuccess(CheckAppFormModel checkAppFormModel) {
    if (navigationPersonalDetails != null) {
      navigationPersonalDetails!.navigateUserToAppStage(
          sequenceEngineModel: checkAppFormModel.sequenceEngine!);
    } else {
      onNavigationDetailsNull(PERSONAL_DETAILS_POLLING_SCREEN);
    }
  }

  void onAfterFirstLayout() {
    _userPersonalDetails.isPartnerFlow =
        navigationPersonalDetails?.isPartnerFlow() ?? false;

    if (isPartnerFlow) {
      getDataAndPrefill();
    } else {
      isDataLoading = false;
      logPersonalDetailsLoaded();
    }
    personalDetailRepository = PersonalDetailRepository();
    logCustomerStatus();
  }

  void _onAppFormRejectionNavigation(
      AppFormRejectionModel appFormRejectionModel) {
    if (navigationPersonalDetails != null) {
      navigationPersonalDetails!
          .onAppFormRejected(model: appFormRejectionModel);
    } else {
      onNavigationDetailsNull(PERSONAL_DETAILS_POLLING_SCREEN);
    }
  }

  getDataAndPrefill() {
    isDataLoading = true;
    getAppForm(
      onApiError: _onAppFormApiError,
      onRejected: (_) {}, // DO nothing
      onSuccess: _onAppFormSuccess,
    );
  }

  _onAppFormApiError(ApiResponse apiResponse) {
    handleAPIError(apiResponse,
        screenName: PERSONAL_DETAILS, retry: getDataAndPrefill);
  }

  _onAppFormSuccess(AppForm appform) {
    if (isPartnerFlow) {
      Get.log(appform.responseBody.toString());
      fullNameController.prefilledValue =
          appform.responseBody['applicant']?['fullName'] ?? "";
      panController.prefilledValue =
          appform.responseBody['applicant']?['panCardId'] ?? "";
      pinCodeController.prefilledValue =
          appform.responseBody['applicant']?['pinCode'] ?? "";
      emailController.prefilledValue =
          appform.responseBody['applicant']?['personalEmail'] ?? "";
      residenceTypeController.prefilledValue =
          appform.responseBody['applicant']?['ownership'] ?? "";
      // employmentTypeController.prefilledValue =
      //     "${appform.responseBody['applicant']?['type'] ?? appform.responseBody['applicant']?['employmentType'] ?? ""}";
      // if (employmentTypeController.prefilledValue.isNotEmpty) {
      //   employmentTypeIndex =
      //       int.parse(employmentTypeController.prefilledValue) ==
      //               SELF_EMPLOYED_INDEX
      //           ? 0
      //           : 1;
      // }

      if (appform.responseBody['applicant']?['dob'] != null &&
          appform.responseBody['applicant']?['dob'] != '') {
        DateTime? datetime =
            DateTime.tryParse(appform.responseBody['applicant']['dob']);
        if (datetime != null) {
          dobController.prefilledValue =
              AppFunctions().getSlashDobFormate(datetime);
          _setDOBDate(datetime);
        }
      }
      areFieldsValid();
      logPartnerPersonalDetailsInterfaceLoaded();
    }
    Get.log(appform.toString());
    isDataLoading = false;
  }

  _setDOBDate(DateTime datetime) {
    final personalDetailsDOBFieldLogic =
        Get.find<PersonalDetailsDOBFieldLogic>();
    personalDetailsDOBFieldLogic.dobManager.dayManager
        .setText(datetime.day.toString());
    personalDetailsDOBFieldLogic.dobManager.monthManager
        .setText(datetime.month.toString());
    personalDetailsDOBFieldLogic.dobManager.yearManager
        .setText(datetime.year.toString());
  }

  bool _userNameValidCharactersCheck(String value) {
    return RegExp(r'^[a-z A-Z]+$').hasMatch(value);
  }

  bool isEmail(String value) {
    String pattern = r'^[a-zA-Z0-9._%+-]+@[a-z0-9.-]+\.[a-z]{2,6}$';
    return RegExp(pattern).hasMatch(value);
  }

  _sendWebengageEvents(CheckAppFormModel checkAppFormModel) {
    late String partnerId;
    late String journeyType;
    try {
      partnerId = checkAppFormModel.responseBody['partnerId'] ?? '';
      journeyType = checkAppFormModel.responseBody['journeyType'] ?? '';
      logFlowTypeAndPartnerId(
        journeyType: journeyType,
        partnerId: partnerId,
        isPartnerFlow: _userPersonalDetails.isPartnerFlow,
      );
    } catch (e) {
      handleAPIError(
          ApiResponse(
              state: ResponseState.jsonParsingError,
              apiResponse: checkAppFormModel.apiResponse.apiResponse),
          screenName: PERSONAL_DETAILS,
          retry: () => _sendWebengageEvents(checkAppFormModel));
    }
  }

  navigateToNextScreen(CheckAppFormModel checkAppFormModel) {
    Get.log("appform - ${checkAppFormModel.appFormId}");
    _sendWebengageEvents(checkAppFormModel);

    if (navigationPersonalDetails != null &&
        checkAppFormModel.sequenceEngine != null) {
      navigationPersonalDetails!.navigateUserToAppStage(
          sequenceEngineModel: checkAppFormModel.sequenceEngine!);
    } else {
      onNavigationDetailsNull(PERSONAL_DETAILS);
    }
  }

  onDobChanged(String value) {
    dobController.text = value;
    areFieldsValid();
  }
}
