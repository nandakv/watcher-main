import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:privo/app/common_widgets/privo_text_editing_controller.dart';
import 'package:privo/app/common_widgets/privo_text_form_field/privo_text_form_field.dart';
import 'package:privo/app/data/repository/app_parameter_repository.dart';
import 'package:privo/app/data/repository/on_boarding_repository/sequence_engine_repository.dart';
import 'package:privo/app/data/repository/on_boarding_repository/work_details_repository.dart';
import 'package:privo/app/firebase/analytics.dart';
import 'package:privo/app/models/app_parameter_model.dart';
import 'package:privo/app/models/sequence_engine_model.dart';
import 'package:privo/app/modules/on_boarding/mixins/app_form_mixin.dart';
import 'package:privo/app/modules/on_boarding/mixins/on_boarding_mixin.dart';
import 'package:privo/app/modules/on_boarding/widgets/personal_details/user_personal_details.dart';
import 'package:privo/app/modules/on_boarding/widgets/work_details/user_work_details.dart';
import 'package:privo/app/modules/on_boarding/widgets/work_details/widgets/work_details_field_validator.dart';
import 'package:privo/app/modules/on_boarding/widgets/work_details/work_details_navigation.dart';
import 'package:privo/app/utils/app_functions.dart';
import 'package:privo/app/utils/apps_flyer_constants.dart';

import '../../../../api/api_error_mixin.dart';
import '../../../../api/response_model.dart';
import '../../../../common_widgets/bottom_sheet_radio_button/bottom_sheet_radio_button_widget.dart';
import '../../../../common_widgets/forms/base_field_validator.dart';
import '../../../../data/provider/auth_provider.dart';
import '../../../../models/check_app_form_model.dart';
import '../../../../routes/app_pages.dart';
import '../../../../utils/web_engage_constant.dart';
import '../../mixins/user_details_mixin.dart';
import '../offer/offer_navigation.dart';
import '../search_screen/search_result.dart';
import '../search_screen/search_screen_logic.dart';

class WorkDetailsLogic extends GetxController
    with
        OnBoardingMixin,
        ApiErrorMixin,
        AppFormMixin,
        UserDetailsMixin,
        BaseFieldValidators,
        WorkDetailsFieldValidators {
  OnBoardingOfferNavigation? onBoardingOfferNavigation;

  int COMPANY_NAME_LENGTH = 3;

  ///Employement Type vaiables

  String SALARIED_TEXT = "Salaried";
  String SELF_EMPLOYED_TEXT = "Self Employed";
  String EMPLOYMENT_TYPE_TITLE = "Employment Type";

  late SequenceEngineModel sequenceEngineModel;

  final String INCOME_TYPE_WIDGET_ID = "income_type_widget_id";

  final String WORKDETAILS_CHECK_BOX_KEY = 'check_box_one_key';

  late String WORK_DETAILS_SCREEN = "work_details";

  OnboardingNavigationWorkDetails? navigationWorkDetails;

  WorkDetailsRepository workDetailsRepository = WorkDetailsRepository();

  late String BUTTON_ID = "BUTTON_ID";
  late String FORM_WIDGET_ID = 'FORM_WIDGET_ID';
  late String EMPLOYMENT_TYPE_WIDGET_ID = 'EMPLOYMENT_TYPE_WIDGET_ID';
  late String INCOME_TEXT_FIELD_ID = 'INCOME_TEXT_FIELD_ID';
  late String COMPANY_NAME_TEXT_FIELD_ID = 'COMPANY_NAME_TEXT_FIELD_ID';

  bool get isPartnerFlow => navigationWorkDetails?.isPartnerFlow() ?? false;

  WorkDetailsLogic({this.navigationWorkDetails});

  //TextEditingControllers for work details screen
  final UserWorkDetails _userWorkDetails = UserWorkDetails();

  PrivoTextEditingController get employmentTypeController =>
      _userWorkDetails.employmentTypeController;

  PrivoTextEditingController get incomeController =>
      _userWorkDetails.incomeController;

  PrivoTextEditingController get companyNameController =>
      _userWorkDetails.companyNameController;

  int? get selectedIncomeType => _userWorkDetails.selectedIncomeType;

  onIncomeChanged(int? value) {
    _userWorkDetails.selectedIncomeType = value;
    update([INCOME_TYPE_WIDGET_ID]);
    workDetailsOnChange();
  }

  SearchResult get searchResult => _userWorkDetails.searchResult;

  static const String WORK_DETAILS = 'work_details';
  int EMPLOYER_NAME_MAX_LENGTH = 256;
  bool _isEmploymentError = false;
  final workDetailsFormKey = GlobalKey<FormState>();
  var isWorkDetailsFormFilled = false;

  List<String> invalidDomainList = [
    "gmail",
    "yahoo",
    "hotmail",
    "rediff",
    "msn",
    "live",
    "aol",
    "outlook",
    "mailinator"
  ];

  ///loading state
  bool _isLoading = true;

  bool get isLoading => _isLoading;

  set isLoading(bool value) {
    _isLoading = value;
    update();
    update([INCOME_TYPE_WIDGET_ID, EMPLOYMENT_TYPE_TITLE]);
    if (navigationWorkDetails != null) {
      navigationWorkDetails!.toggleBack(isBackDisabled: isLoading);
    } else {
      onNavigationDetailsNull(WORK_DETAILS);
    }
  }

  FocusNode workDetailsFocusNode = FocusNode();

  int? selectedEmploymentType;

  EmploymentType get employmentType => _userWorkDetails.employmentType;

  onSelectedEmploymentTypeIndex(int value) {
    selectedEmploymentType = value;
    if (value == 0) {
      employmentType = EmploymentType.selfEmployed;
    } else {
      employmentType = EmploymentType.salaried;
    }
    onEmploymentTypeSelected(employmentType);
    update([FORM_WIDGET_ID]);
  }

  set employmentType(EmploymentType value) {
    _userWorkDetails.employmentType = value;
    update([EMPLOYMENT_TYPE_WIDGET_ID]);
  }

  bool get isEmploymentError => _isEmploymentError;

  set isEmploymentError(bool value) {
    _isEmploymentError = value;
    update([EMPLOYMENT_TYPE_WIDGET_ID]);
  }

  bool _isButtonLoading = false;

  bool get isButtonLoading => _isButtonLoading;

  set isButtonLoading(bool value) {
    _isButtonLoading = value;
    update();
    if (navigationWorkDetails != null) {
      navigationWorkDetails!.toggleBack(isBackDisabled: isLoading);
    } else {
      onNavigationDetailsNull(WORK_DETAILS);
    }
  }

  bool _isConsentChecked = false;

  bool get isConsentChecked => _isConsentChecked;

  set isConsentChecked(bool value) {
    _isConsentChecked = value;
    update([WORKDETAILS_CHECK_BOX_KEY]);
  }

  void onAfterFirstLayout() {
    isLoading = true;
    _userWorkDetails.isPartnerFlow =
        navigationWorkDetails?.isPartnerFlow() ?? false;
    getDataAndPrefill();
  }

  getDataAndPrefill() {
    getAppForm(
      onApiError: _onAppFormApiError,
      onRejected: (_) {}, // DO nothing
      onSuccess: _onAppFormSuccess,
    );
  }

  _onAppFormApiError(ApiResponse apiResponse) {
    handleAPIError(apiResponse,
        screenName: WORK_DETAILS_SCREEN, retry: getDataAndPrefill);
  }

  _onAppFormSuccess(AppForm appform) {
    _userWorkDetails.isPartnerFlow =
        appform.responseBody['partnerFlow'] ?? false;
    if (isPartnerFlow) {
      _prefillData(appform);
      AppAnalytics.trackWebEngageEventWithAttribute(
          eventName: WebEngageConstants.partnerWorkDetailsInterfaceLoaded);
    } else {
      int? employmentTypeIndex =
          _getEmploymentTypeIndexFromAppFormResponse(appform);
      _prefillEmploymentData(employmentTypeIndex);
      Get.log("employment type = $employmentType");
    }
    Get.log(appform.toString());
    isLoading = false;
  }

  int? _getEmploymentTypeIndexFromAppFormResponse(AppForm appform) =>
      appform.responseBody['applicant']?['type'] ??
      appform.responseBody['applicant']?['employmentType'];

  _prefillData(AppForm appform) {
    int? employmentTypeIndex =
        _getEmploymentTypeIndexFromAppFormResponse(appform);
    String? applicantIncome = appform.responseBody['applicant']?['income'];

    _prefillEmploymentData(employmentTypeIndex);
    _prefillIncome(applicantIncome);

    companyNameController.prefilledValue =
        appform.responseBody['applicant']?["employerName"] ?? "";
    _userWorkDetails.searchResult = SearchResult(
        companyName: appform.responseBody['applicant']?["employerName"] ?? "");
    incomeController.text = incomeController.text;
    workDetailsOnChange();
  }

  _prefillIncome(String? applicantIncome) {
    if (applicantIncome != null) {
      incomeController.prefilledValue =
          AppFunctions().parseIntoCommaFormat(applicantIncome);
    }
  }

  _prefillEmploymentData(int? employmentTypeIndex) {
    if (employmentTypeIndex != null) {
      String employmentTypeString =
          _computeEmploymentIntToString(employmentTypeIndex);
      employmentType = _employmentTypeStringToEnum(employmentTypeString);
      onEmploymentTypeSelected(employmentType);
    }
  }

  String _computeEmploymentIntToString(int employmentTypeValue) {
    switch (employmentTypeValue) {
      case 6:
        return SALARIED_TEXT;
      case 8:
        return SELF_EMPLOYED_TEXT;
      default:
        return "0";
    }
  }

  ///toggles the check box value to true or false
  toggleIsChecked(bool val) {
    isConsentChecked = val;
    workDetailsOnChange();
  }

  ///checks if the check box are enabled
  onPressComplete() async {
    if (!isConsentChecked) {
      Fluttertoast.showToast(msg: "Please Accept the Consent");
    }
  }

  ///Triggers work details on change
  void workDetailsOnChange({String value = ""}) {
    verifyIsFormFilled();
    update([BUTTON_ID]);
  }

  void verifyIsFormFilled() {
    if (employmentType == EmploymentType.selfEmployed) {
      isWorkDetailsFormFilled = isSelfEmployedFormFilled;
    } else {
      isWorkDetailsFormFilled =
          isFieldValid(validateCompanyName(companyNameController.text)) &&
              selectedIncomeType != null &&
              isSelfEmployedFormFilled;
    }
  }

  bool get validateIncome {
    try {
      return incomeController.text.isNotEmpty &&
          (double.parse(incomeController.text.replaceAll(',', '')) >= 10000 &&
              double.parse(incomeController.text.replaceAll(',', '')) <
                  1000000);
    } catch (e) {
      Get.log("error at parsing");
      return false;
    }
  }

  bool get isSelfEmployedFormFilled {
    return validateIncome && !isEmploymentError && selectedIncomeType != null;
  }

  onWorkDetailsContinueTapped() async {
    if (workDetailsFormKey.currentState != null &&
        workDetailsFormKey.currentState!.validate() &&
        !isEmploymentError &&
        isConsentChecked) {
      isButtonLoading = true;
      _computeWorkDetailsOnClickEvents();
      Get.focusScope!.unfocus();
      postWorkDetails();
    }
    if (employmentType != EmploymentType.none) isEmploymentError = false;
  }

  void _computeWorkDetailsOnClickEvents() {
    AppAnalytics.trackWebEngageEventWithAttribute(
        eventName: WebEngageConstants.employmentTypeInput);
    _computeSalariedAndSelfEmployedCTAEvents();
    if (isPartnerFlow) {
      AppAnalytics.trackWebEngageEventWithAttribute(
          eventName: WebEngageConstants.partnerWorkDetailsContinueCTA);
    } else {
      AppAnalytics.trackWebEngageEventWithAttribute(
          eventName: WebEngageConstants.employmentDetailsContinueCTA);
    }
  }

  void _computeSalariedAndSelfEmployedCTAEvents() {
    if (employmentType == EmploymentType.salaried) {
      AppAnalytics.trackWebEngageEventWithAttribute(
          eventName: WebEngageConstants.employerNameInput,
          attributeName: {'Status': true});
      AppAnalytics.trackWebEngageEventWithAttribute(
          eventName: WebEngageConstants.netMonthlyIncomeInputSalaried,
          attributeName: {'Status': true});
      AppAnalytics.trackWebEngageUser(
          userAttributeName: "EmploymentType", userAttributeValue: "Salaried");
      AppAnalytics.logAppsFlyerEvent(
          eventName: AppsFlyerConstants.edCompleteSalaried);
    } else {
      AppAnalytics.trackWebEngageEventWithAttribute(
          eventName: WebEngageConstants.netMonthlyIncomeInputSelfEmployed,
          attributeName: {'Status': true});
      AppAnalytics.logAppsFlyerEvent(
          eventName: AppsFlyerConstants.edCompleteSelfEmployed);
    }
  }

  _fetchSequenceEngine() {
    if (navigationWorkDetails != null) {
      sequenceEngineModel = navigationWorkDetails!.getSequenceEngineDetails();
    }
  }

  Future<void> postWorkDetails() async {
    CheckAppFormModel appFormModel;
    Map body = computeWorkDetailsApiBody(_userWorkDetails);
    // Get.log(body.toString());
    if (navigationWorkDetails != null) {
      _fetchSequenceEngine();
      appFormModel = await SequenceEngineRepository(sequenceEngineModel)
          .makeHttpRequest(body: body);
      switch (appFormModel.apiResponse.state) {
        case ResponseState.success:
          AppAnalytics.logAppsFlyerEvent(
              eventName: AppsFlyerConstants.employmentDetails);
          _onWorkDetailsSuccess(appFormModel);
          break;
        default:
          handleAPIError(
            appFormModel.apiResponse,
            screenName: WORK_DETAILS_SCREEN,
            retry: postWorkDetails,
          );
      }
    }
  }

  void _onWorkDetailsSuccess(CheckAppFormModel appFormModel) async {
    if (appFormModel.appFormRejectionModel.isRejected) {
      isButtonLoading = false;
      computeRejectionAndNavigate(appFormModel);
      AppAnalytics.trackWebEngageEventWithAttribute(
          eventName: WebEngageConstants.employmentDetailsRejected);
    } else {
      AppAnalytics.trackWebEngageEventWithAttribute(
          eventName: WebEngageConstants.employmentDetailsVerified);
      _onAppFormNotRejected(appFormModel);
    }
  }

  computeRejectionAndNavigate(CheckAppFormModel appFormModel) {
    if (navigationWorkDetails != null) {
      navigationWorkDetails!
          .onAppFormRejected(model: appFormModel.appFormRejectionModel);
    } else {
      onNavigationDetailsNull(WORK_DETAILS);
    }
  }

  _onAppFormNotRejected(CheckAppFormModel checkAppFormModel) {
    isLoading = false;
    isButtonLoading = false;
    if (navigationWorkDetails != null &&
        checkAppFormModel.sequenceEngine != null) {
      navigationWorkDetails!.navigateUserToAppStage(
          sequenceEngineModel: checkAppFormModel.sequenceEngine!);
    } else {
      onNavigationDetailsNull(WORK_DETAILS);
    }
  }

  ///validate [email] with the list of
  ///domains which is listed as invalidDomains
  bool isInValidDomain(String email) {
    bool result = false;
    String domain = email.split("@").last;
    for (var element in invalidDomainList) {
      var list = domain.split('.');
      if (list
          .map((e) => e.toLowerCase())
          .toList()
          .contains(element.toLowerCase())) {
        result = true;
        break;
      }
    }
    return result;
  }

  ///Email validator lo gic
  ///used in WorkEmail TextField
  String? validateWorkEmail(String? value) {
    if (value != null && value.isEmpty) return null;
    if (value != null && !value.trim().isEmail) {
      return "Enter Proper Email";
    } else if (value != null && isInValidDomain(value)) {
      return "Please input your work email";
    } else {
      return null;
    }
  }

  onCompanyNameNotFound() {
    if (companyNameController.text.length > 3 &&
        companyNameController.text.length < EMPLOYER_NAME_MAX_LENGTH) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 10),
          child: SizedBox(
            height: 30,
            width: 30,
            child: CircularProgressIndicator(
              strokeWidth: 2,
            ),
          ),
        ),
      );
    } else {
      return const SizedBox();
    }
  }

  void onTapCompanyNameField() async {
    companyNameController.clear();
    var searchResult = await Get.toNamed(Routes.SEARCH_SCREEN,
        arguments: {'search_type': SearchType.employerSearch});
    if (searchResult != null) {
      Get.log("searchResult = ${searchResult.toString()}");
      companyNameController.text = searchResult.companyName;
      _userWorkDetails.searchResult = searchResult;
    }
    removeCurrentFocus();
    workDetailsOnChange();
  }

  onEmploymentTypeSelected(EmploymentType employmentType) {
    this.employmentType = employmentType;
    isEmploymentError = false;
    if (Get.context != null) removeCurrentFocus();
    update([EMPLOYMENT_TYPE_WIDGET_ID]);
    computeAndClearData();
  }

  computeAndClearData() {
    incomeController.text = "";
    companyNameController.text = "";
    isConsentChecked = false;
    _userWorkDetails.selectedIncomeType = null;
    workDetailsOnChange();
  }

  ///To remove focus(Keyboard from screen) if employment type is changed
  void removeCurrentFocus() {
    if (Get.focusScope != null) Get.focusScope!.unfocus();
  }

  EmploymentType _employmentTypeStringToEnum(String type) {
    switch (type) {
      case "Salaried":
        return EmploymentType.salaried;
      case "Self Employed":
        return EmploymentType.selfEmployed;
      default:
        return EmploymentType.none;
    }
  }

  bool computeIncomeTypeMandetory() {
    return isPartnerFlow;
  }

  String? employmentTypeValidator(String? value) {
    if (value!.trim().isEmpty) {
      return "Please select your employment type to proceed.";
    }
    return null;
  }
}
