import 'package:get/get.dart';
import 'package:privo/app/api/api_error_mixin.dart';
import 'package:privo/app/api/response_model.dart';
import 'package:privo/app/data/repository/on_boarding_repository/final_offer_polling_repository.dart';
import 'package:privo/app/mixin/app_analytics_mixin.dart';
import 'package:privo/app/models/co_applicant_list_model.dart';
import 'package:privo/app/models/document_type_list_model.dart';
import 'package:privo/app/models/final_offer_polling/untagged_doc_model.dart';
import 'package:privo/app/models/home_screen_model.dart';
import 'package:privo/app/modules/on_boarding/mixins/on_boarding_mixin.dart';
import 'package:privo/app/modules/on_boarding/widgets/about_co_applicant/add_co_applicant_abstract_class.dart';
import 'package:privo/app/modules/on_boarding/widgets/about_co_applicant/add_co_applicant_logic.dart';
import 'package:privo/app/modules/on_boarding/widgets/final_offer_polling/final_offer_polling_navigation.dart';
import 'package:privo/app/services/lpc_service.dart';

import '../../../../models/check_app_form_model.dart';
import '../../mixins/app_form_mixin.dart';
import 'final_offer_polling_analytics.dart';

enum FinalOfferPollingState {
  finalOfferInProgress,
  additionalDetails,
  coApplicant,
  loading
}

class FinalOfferPollingLogic extends GetxController
    with
        OnBoardingMixin,
        ApiErrorMixin,
        AppFormMixin,
        AppAnalyticsMixin,
        FinalOfferPollingAnalytics
    implements AddCoApplicantHandler {
  List<String> bodyTexts = const [
    "Your final offer will be ready in 24-48 hrs. We will email you or you can check your loan status in the app"
  ];

  List<String> titleTexts = const ["Final offer in Progress"];

  late final String FINAL_OFFER_POLLING_SCREEN = 'FINAL_OFFER_POLLING_SCREEN';

  onClosePressed() {
    Get.back();
  }

  late DocSection docSection;

  late DocumentTypeListModel documentTypeListModel;

  late final String BUTTON_ID = 'BUTTON_ID';
  bool _buttonEnabled = false;

  bool get buttonEnabled => _buttonEnabled;

  set buttonEnabled(bool value) {
    _buttonEnabled = value;
    update([BUTTON_ID]);
  }

  bool _isScreenLoading = false;

  bool get isScreenLoading => _isScreenLoading;

  set isScreenLoading(bool value) {
    _isScreenLoading = value;
    update();
  }

  bool _isButtonLoading = false;

  bool get isButtonLoading => _isButtonLoading;

  set isButtonLoading(bool value) {
    _isButtonLoading = value;
    navigation?.toggleBack(isBackDisabled: value);
    update([BUTTON_ID]);
  }

  late final String applicantPan;
  late final String applicantNumber;

  FinalOfferPollingState _finalOfferPollingState =
      FinalOfferPollingState.loading;

  FinalOfferPollingState get finalOfferPollingState => _finalOfferPollingState;

  set finalOfferPollingState(FinalOfferPollingState value) {
    _finalOfferPollingState = value;
    update();
  }

  List<CoApplicantDetail> coApplicantDetailsList = [];

  FinalOfferPollingNavigation? navigation;

  FinalOfferPollingLogic({this.navigation});

  void onAfterLayout() {
    logFinalOfferInProgress();
    navigation?.toggleAppBarVisibility(false);
    getAppForm(
        onApiError: _onGetAppFormError,
        onRejected: _onRejected,
        onSuccess: _onAppFormSuccess);
  }

  _onGetAppFormError(ApiResponse error) {
    handleAPIError(error,
        screenName: FINAL_OFFER_POLLING_SCREEN, retry: onAfterLayout);
  }

  _onRejected(CheckAppFormModel appFormModel) {}

  _onAppFormSuccess(AppForm appform) {
    Get.log("PAN - ${appform.applicantPan}, ${appform.applicantNumber}");
    applicantPan = appform.applicantPan;
    applicantNumber = appform.applicantNumber;
    finalOfferPollingState = FinalOfferPollingState.finalOfferInProgress;
  }

  @override
  void onInit() {
    Get.put(AddCoApplicantLogic(addCoApplicantAbstractClass: this));
  }

  validateForm() {
    buttonEnabled =
        coApplicantDetailsList.isNotEmpty || docSection.taggedDocs.isNotEmpty;
  }

  void onTapAddCoApplicant() async {
    navigation?.toggleAppBarVisibility(false);
    finalOfferPollingState = FinalOfferPollingState.coApplicant;
  }

  void onAdditionalDetailsClicked() async {
    finalOfferPollingState = FinalOfferPollingState.loading;
    UnTaggedDocModel unTaggedDocModel =
        await FinalOfferPollingRepository().getUnTaggedDocs();
    switch (unTaggedDocModel.apiResponse.state) {
      case ResponseState.success:
        docSection = DocSection.fromJson({});
        docSection.taggedDocs.addAll(unTaggedDocModel.docs);
        logAdditionalDetailsLoaded();
        finalOfferPollingState = FinalOfferPollingState.additionalDetails;
        validateForm();
        break;
      default:
        handleAPIError(unTaggedDocModel.apiResponse,
            screenName: "FINAL_OFFER_POLLING");
    }
    navigation?.toggleAppBarVisibility(true);
  }

  onFinalOfferAddCoApplicant() async {
    isButtonLoading = true;
    if (coApplicantDetailsList.isNotEmpty) {
      ApiResponse apiResponse = await FinalOfferPollingRepository()
          .addFinalOfferCoApplicant(coApplicantDetailsList.first.toJson());
      switch (apiResponse.state) {
        case ResponseState.success:
          _onFinalOfferSuccess();
          break;
        default:
          isButtonLoading = false;
          handleAPIError(apiResponse,
              screenName: 'FINAL_OFFER_POLLING_DETAILS',
              retry: onFinalOfferAddCoApplicant);
      }
    } else if (docSection.taggedDocs.isNotEmpty) {
      _onFinalOfferSuccess();
    }
  }

  void _onFinalOfferSuccess() {
    isButtonLoading = false;
    navigation?.toggleAppBarVisibility(false);
    coApplicantDetailsList = [];
    buttonEnabled = false;
    finalOfferPollingState = FinalOfferPollingState.finalOfferInProgress;
  }

  onCoApplicantEdit(CoApplicantDetail detail, int index) {
    update();
    finalOfferPollingState = FinalOfferPollingState.coApplicant;
  }

  Future<bool> onPopInvoked() async {
    switch (finalOfferPollingState) {
      case FinalOfferPollingState.finalOfferInProgress:
        return true;
      case FinalOfferPollingState.additionalDetails:
        navigation?.toggleAppBarVisibility(false);
        finalOfferPollingState = FinalOfferPollingState.finalOfferInProgress;
        return false;
      case FinalOfferPollingState.coApplicant:
        navigation?.toggleAppBarVisibility(true);
        finalOfferPollingState = FinalOfferPollingState.additionalDetails;
        return false;
      case FinalOfferPollingState.loading:
        return false;
    }
  }

  @override
  onSavePressed(List<CoApplicantDetail> coApplicantDetailsList) {
    this.coApplicantDetailsList = coApplicantDetailsList;
    navigation?.toggleAppBarVisibility(true);
    validateForm();
    finalOfferPollingState = FinalOfferPollingState.additionalDetails;
  }

  @override
  onClosed() {
    navigation?.toggleAppBarVisibility(true);
    finalOfferPollingState = FinalOfferPollingState.additionalDetails;
  }

  bool shouldShowCoApplicantDetails() {
    LPCCardType cardType =
        LPCService.instance.activeCard?.lpcCardType ?? LPCCardType.loan;
    return cardType == LPCCardType.loan;
  }
}
