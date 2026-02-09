import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:privo/app/common_widgets/forms/personal_details_field_validators.dart';
import 'package:privo/app/common_widgets/forms/sbd_field_validators.dart';
import 'package:privo/app/mixin/app_analytics_mixin.dart';
import 'package:privo/app/modules/on_boarding/mixins/on_boarding_mixin.dart';
import 'package:privo/app/modules/on_boarding/widgets/co_applicant_details/co_applicant_details_analytics.dart';
import 'package:privo/app/modules/on_boarding/widgets/co_applicant_details/co_applicant_details_navigation.dart';
import 'package:privo/app/modules/on_boarding/widgets/personal_details/widgets/personal_details_dob_field/personal_details_dob_field_logic.dart';

import '../../../../api/api_error_mixin.dart';
import '../../../../api/response_model.dart';
import '../../../../common_widgets/forms/base_field_validator.dart';
import '../../../../common_widgets/privo_text_editing_controller.dart';
import '../../../../data/repository/on_boarding_repository/sequence_engine_repository.dart';
import '../../../../models/check_app_form_model.dart';
import '../../../../models/co_applicant_list_model.dart';
import '../../../../models/sequence_engine_model.dart';
import '../../mixins/app_form_mixin.dart';

enum CoApplicantState { loading, businessDetails, coApplicant }

class CoApplicantDetailsLogic extends GetxController
    with
        BaseFieldValidators,
        SBDFieldValidators,
        PersonalDetailsFieldValidators,
        OnBoardingMixin,
        ApiErrorMixin,
        AppFormMixin,
        AppAnalyticsMixin,
        CoApplicantDetailsAnalytics {
  CoApplicantDetailsNavigation? navigation;

  CoApplicantDetailsLogic({this.navigation});

  late SequenceEngineModel sequenceEngineModel;

  late final String BUTTON_ID = 'BUTTON_ID';
  late final String PAGE_ID = 'PAGE_ID';
  late final String CO_APPLICANT_BUTTON_ID = 'CO_APPLICANT_BUTTON_ID';
  late final String OWNERSHIP_DETAILS_FORM = 'OWNERSHIP_DETAILS_FORM';
  late final String CO_APPLICANT_DETAILS_SCREEN = 'CO_APPLICANT_DETAILS_SCREEN';
  late final String CO_APPLICANT_DETAILS_DOB_ID = 'CO_APPLICANT_DETAILS_DOB_ID';

  String? _shareHoldingErrorText;

  String? get shareHoldingErrorText => _shareHoldingErrorText;

  set shareHoldingErrorText(String? value) {
    _shareHoldingErrorText = value;
    update([PAGE_ID]);
  }

  List<String> otherApplicantsPanNumbers = [];
  List<String> otherApplicantsMobileNumbers = [];

  List<CoApplicantDetail> coApplicantDetailsList = [];

  PrivoTextEditingController designationController =
      PrivoTextEditingController();

  PrivoTextEditingController shareHoldingController =
      PrivoTextEditingController();

  PrivoTextEditingController coApplicantDesignationController =
      PrivoTextEditingController();

  PrivoTextEditingController coApplicantShareHoldingController =
      PrivoTextEditingController();

  PrivoTextEditingController fullNameController = PrivoTextEditingController();
  PrivoTextEditingController dobController = PrivoTextEditingController();
  PrivoTextEditingController panController = PrivoTextEditingController();
  PrivoTextEditingController phoneNumberController =
      PrivoTextEditingController();
  PrivoTextEditingController pinCodeController = PrivoTextEditingController();
  PrivoTextEditingController emailController = PrivoTextEditingController();

  int? coApplicantEditSelectedIndex;

  bool _buttonEnabled = false;

  bool get buttonEnabled => _buttonEnabled;

  set buttonEnabled(bool value) {
    _buttonEnabled = value;
    update([BUTTON_ID]);
  }

  bool _isLoading = true;

  bool get isLoading => _isLoading;

  set isLoading(bool value) {
    _isLoading = value;
    update();
  }

  bool _buttonLoading = false;

  bool get buttonLoading => _buttonLoading;

  set buttonLoading(bool value) {
    _buttonLoading = value;
    navigation?.toggleBack(isBackDisabled: value);
    update([BUTTON_ID, OWNERSHIP_DETAILS_FORM]);
  }

  bool _coApplicantButtonEnabled = false;

  bool get coApplicantButtonEnabled => _coApplicantButtonEnabled;

  set coApplicantButtonEnabled(bool value) {
    _coApplicantButtonEnabled = value;
    update();
    update([CO_APPLICANT_BUTTON_ID]);
  }

  CoApplicantState _coApplicantState = CoApplicantState.loading;

  CoApplicantState get coApplicantState => _coApplicantState;

  set coApplicantState(CoApplicantState value) {
    _coApplicantState = value;
    update([PAGE_ID]);
  }

  void onAfterLayout() {
    logSbdPartnershipLlpCoApplicantLoaded();
    if (navigation != null) {
      sequenceEngineModel = navigation!.getSequenceEngineDetails();
    } else {
      onNavigationDetailsNull(CO_APPLICANT_DETAILS_SCREEN);
    }
    getAppForm(
      onApiError: _onGetAppFormError,
      onRejected: _onRejected,
      onSuccess: _onAppFormSuccess,
    );
  }

  _onGetAppFormError(ApiResponse error) {
    handleAPIError(error,
        screenName: CO_APPLICANT_DETAILS_SCREEN, retry: onAfterLayout);
  }

  _onRejected(CheckAppFormModel appFormModel) {}

  _onAppFormSuccess(AppForm appform) {
    Get.log("${appform.applicantPan}, ${appform.applicantNumber}");
    otherApplicantsPanNumbers.add(appform.applicantPan);
    otherApplicantsMobileNumbers.add(appform.applicantNumber);
    coApplicantState = CoApplicantState.businessDetails;
  }

  validateForm() {
    buttonEnabled =
        isFieldValid(designationValidator(designationController.text)) &&
            isFieldValid(shareHoldingValidator(shareHoldingController.text)) &&
            _checkShareHoldingPercentGreaterThan100() &&
            coApplicantDetailsList.isNotEmpty;
  }

  validateCoApplicantForm() {
    coApplicantButtonEnabled = isFieldValid(
            nameValidator(fullNameController.text)) &&
        isFieldValid(dobValidator(dobController.text)) &&
        isFieldValid(
            panValidator(panController.text, otherApplicantsPanNumbers)) &&
        isFieldValid(phoneNumberValidator(
            phoneNumberController.text, otherApplicantsMobileNumbers)) &&
        isFieldValid(emailValidator(emailController.text)) &&
        isFieldValid(pinCodeValidator(pinCodeController.text)) &&
        isFieldValid(
            designationValidator(coApplicantDesignationController.text)) &&
        isFieldValid(
            shareHoldingValidator(coApplicantShareHoldingController.text)) &&
        _checkShareHoldingPercentGreaterThan100();
    Get.log("coApplicantButtonEnabled - $coApplicantButtonEnabled");
  }

  void onTapAddCoApplicant() {
    navigation?.toggleAppBarVisibility(false);
    coApplicantEditSelectedIndex = null;
    logSbdCoapplicantPageLoaded();
    coApplicantState = CoApplicantState.coApplicant;
  }

  void onCloseAddCoApplicantPage() {
    _resetCoApplicantControllers();
    coApplicantButtonEnabled = false;
    navigation?.toggleAppBarVisibility(true);
    coApplicantEditSelectedIndex = null;
    coApplicantState = CoApplicantState.businessDetails;
  }

  void onTapMoreCoApplicant() {
    if (coApplicantDetailsList.isNotEmpty) {
      logSbdAddMoreCoApplicantClicked(false);
      onTapAddCoApplicant();
    }
  }

  onCoApplicantSavePressed() {
    CoApplicantDetail coApplicantDetail = CoApplicantDetail(
        pan: panController.text,
        firstName: fullNameController.text.split(" ").first,
        middleName: "",
        lastName: fullNameController.text.split(" ").sublist(1).join(" "),
        dob: dobController.text,
        email: emailController.text,
        phone: phoneNumberController.text,
        pincode: pinCodeController.text,
        designation: coApplicantDesignationController.text,
        shareholding: coApplicantShareHoldingController.text);

    if (coApplicantEditSelectedIndex != null) {
      coApplicantDetailsList[coApplicantEditSelectedIndex!] = coApplicantDetail;

      /// Adding 1 to index bcoz the list will have 1st applicant's value
      otherApplicantsPanNumbers[coApplicantEditSelectedIndex! + 1] =
          panController.text;
      otherApplicantsMobileNumbers[coApplicantEditSelectedIndex! + 1] =
          phoneNumberController.text;
    } else {
      logSbdCoapplicantAdded(false);
      coApplicantDetailsList.add(coApplicantDetail);
      otherApplicantsPanNumbers.add(panController.text);
      otherApplicantsMobileNumbers.add(phoneNumberController.text);
    }
    _resetCoApplicantControllers();
    coApplicantButtonEnabled = false;
    navigation?.toggleAppBarVisibility(true);
    coApplicantEditSelectedIndex = null;
    coApplicantState = CoApplicantState.businessDetails;
    validateForm();
  }

  void _resetCoApplicantControllers() {
    panController.text = "";
    fullNameController.text = "";
    dobController.text = "";
    emailController.text = "";
    phoneNumberController.text = "";
    pinCodeController.text = "";
    coApplicantDesignationController.text = "";
    coApplicantShareHoldingController.text = "";
  }

  onTapCoApplicantEdit(CoApplicantDetail detail, int index) {
    panController.text = detail.pan;
    fullNameController.text = "${detail.firstName} ${detail.lastName}";
    dobController.text = detail.dob;
    _prefillDob();
    emailController.text = detail.email;
    phoneNumberController.text = detail.phone;
    pinCodeController.text = detail.pincode;
    coApplicantDesignationController.text = detail.designation;
    coApplicantShareHoldingController.text = detail.shareholding;
    navigation?.toggleAppBarVisibility(false);
    coApplicantEditSelectedIndex = index;
    coApplicantState = CoApplicantState.coApplicant;

    validateCoApplicantForm();
  }

  DateFormat format = DateFormat("dd/MM/yyyy");

  _prefillDob() {
    final personalDetailsDOBFieldLogic =
        Get.find<PersonalDetailsDOBFieldLogic>();
    final DateTime datetime = format.parse(
      dobController.text,
    );
    personalDetailsDOBFieldLogic.dobManager.dayManager
        .setText(datetime.day.toString());
    personalDetailsDOBFieldLogic.dobManager.monthManager
        .setText(datetime.month.toString());
    personalDetailsDOBFieldLogic.dobManager.yearManager
        .setText(datetime.year.toString());
  }

  bool _checkShareHoldingPercentGreaterThan100() {
    int ownerShare = int.tryParse(shareHoldingController.text) ?? 0;
    int coApplicantShare = 0;
    if (coApplicantState == CoApplicantState.coApplicant) {
      coApplicantShare =
          int.tryParse(coApplicantShareHoldingController.text) ?? 0;
    }

    int otherApplicantShares = 0;
    if (coApplicantDetailsList.isNotEmpty) {
      for (int i = 0; i < coApplicantDetailsList.length; i++) {
        if (coApplicantEditSelectedIndex == null) {
          otherApplicantShares = otherApplicantShares +
              int.parse(coApplicantDetailsList[i].shareholding);
        } else if (coApplicantEditSelectedIndex != i) {
          otherApplicantShares = otherApplicantShares +
              int.parse(coApplicantDetailsList[i].shareholding);
        }
      }
    }
    if ((ownerShare + coApplicantShare + otherApplicantShares) > 100) {
      shareHoldingErrorText =
          "Total Shareholding should be equal or less than 100%";
      return false;
    }
    shareHoldingErrorText = null;
    return true;
  }

  onNextTapped() async {
    buttonLoading = true;

    logInputEvents(false);

    Map<String, dynamic> body = {
      "ownerShipDetails": {
        "designation": designationController.text,
        "shareholding": shareHoldingController.text,
      }
    }..addAll(
        CoApplicantList(
          coApplicantDetails: coApplicantDetailsList,
        ).toJson(),
      );

    CheckAppFormModel model =
        await SequenceEngineRepository(sequenceEngineModel)
            .makeHttpRequest(body: body);
    switch (model.apiResponse.state) {
      case ResponseState.success:
        logSbdCoApplicantPageSaved(coApplicantDetailsList.length, false);
        _checkIfAppFormRejected(model);
        break;
      default:
        handleAPIError(
          model.apiResponse,
          screenName: CO_APPLICANT_DETAILS_SCREEN,
          retry: onNextTapped,
        );
    }
  }

  _checkIfAppFormRejected(CheckAppFormModel model) {
    if (model.appFormRejectionModel.isRejected) {
      _navigateToRejectedScreen(model);
    } else {
      _navigateToNextScreen(model);
    }
  }

  void _navigateToRejectedScreen(CheckAppFormModel model) {
    buttonLoading = false;
    if (navigation != null) {
      navigation!.onAppFormRejected(
        model: model.appFormRejectionModel,
      );
    } else {
      onNavigationDetailsNull(CO_APPLICANT_DETAILS_SCREEN);
    }
  }

  void _navigateToNextScreen(CheckAppFormModel model) {
    if (navigation != null && model.sequenceEngine != null) {
      navigation!
          .navigateUserToAppStage(sequenceEngineModel: model.sequenceEngine!);
    } else {
      onNavigationDetailsNull(CO_APPLICANT_DETAILS_SCREEN);
    }
  }
}
