import 'package:get/get.dart';
import 'package:privo/app/api/api_error_mixin.dart';
import 'package:privo/app/api/response_model.dart';
import 'package:privo/app/data/repository/on_boarding_repository/processing_bank_details_repository.dart';
import 'package:privo/app/firebase/analytics.dart';
import 'package:privo/app/mixin/penny_testing_polling_mixin.dart';
import 'package:privo/app/models/app_form_rejection_model.dart';
import 'package:privo/app/models/check_app_form_model.dart';
import 'package:privo/app/models/penny_success_model_response_model.dart';
import 'package:privo/app/models/penny_testing_data_transfer_model.dart';
import 'package:privo/app/models/sequence_engine_model.dart';
import 'package:privo/app/modules/app_rating/app_rating_view.dart';
import 'package:privo/app/modules/on_boarding/mixins/on_boarding_mixin.dart';
import 'package:privo/app/modules/on_boarding/widgets/bank_details/bank_details_logic.dart';
import 'package:privo/app/modules/on_boarding/widgets/processing_bank_details/processing_bank_details_navigation.dart';
import 'package:privo/app/services/polling_service.dart';
import 'package:privo/app/utils/apps_flyer_constants.dart';

import '../../../../../flavors.dart';
import '../../../../utils/web_engage_constant.dart';
import '../../mixins/app_form_mixin.dart';

enum PennyTestingState { pending, success, failure, loading }

class ProcessingBankDetailsLogic extends GetxController
    with
        OnBoardingMixin,
        ApiErrorMixin,
        AppFormMixin,
        PennyTestingPollingMixin {
  OnboardingNavigationProcessingBankDetails?
      onboardingNavigationProcessingBankDetails;
  late SequenceEngineModel sequenceEngineModel;
  String? ifscCode;
  String? accountNumber;
  String? bankName;
  String failureMessage = "";

  final String STATUS_COMPLETE = "COMPLETED";
  final String STATUS_FAILED = "FAILED";

  ProcessingBankDetailsRepository? processingBankDetailsRepository;

  ProcessingBankDetailsLogic({this.onboardingNavigationProcessingBankDetails});

  static const String PROCESSING_BANK_DETAILS = 'processing_bank_details';

  final String DEPOSITED_WIDGET = 'deposited_widget';


  ///loading state
  bool _isLoading = false;

  bool get isLoading => _isLoading;

  set isLoading(bool value) {
    _isLoading = value;
    update();
    if (onboardingNavigationProcessingBankDetails != null) {
      onboardingNavigationProcessingBankDetails!
          .toggleBack(isBackDisabled: isLoading);
    } else {
      onNavigationDetailsNull(PROCESSING_BANK_DETAILS);
    }
  }

  PennyTestingState _pennyTestingState = PennyTestingState.loading;

  late PennyTestingDataTransferModel pennyTestingData;

  PennyTestingState get pennyTestingState => _pennyTestingState;

  set pennyTestingState(PennyTestingState value) {
    _pennyTestingState = value;
    update([DEPOSITED_WIDGET]);
  }

  ///when user enters the screen collect the bank details
  ///from onboarding logic
  onAfterLayout() async {
    AppAnalytics.trackWebEngageEventWithAttribute(
        eventName: WebEngageConstants.pennyTestWaitScreenLoaded);
    _fetchSequenceEngine();
    processingBankDetailsRepository = ProcessingBankDetailsRepository();
    getPennyTestingType();
    onboardingNavigationProcessingBankDetails!.toggleAppBarVisibility(false);
    _startPennyTestingPolling();
  }

  _startPennyTestingPolling() async {
    startPennyTestingPolling(
        onApiError: _onPennyTestingError,
        onRejected: _appFormRejectNavigation,
        onSuccess: _onPennySuccess,
        sequenceEngineModel: sequenceEngineModel,
        requestPayload: _fetchRequestPayload(),
        onFailed: _onPennyFailed);
  }

  _onPennyTestingError(ApiResponse apiResponse) {
    handleAPIError(apiResponse,
        screenName: PROCESSING_BANK_DETAILS, retry: _startPennyTestingPolling);
  }

  _fetchRequestPayload() {
    if (onboardingNavigationProcessingBankDetails != null) {
      sequenceEngineModel =
          onboardingNavigationProcessingBankDetails!.getSequenceEngineDetails();
      return sequenceEngineModel.onPolling!.requestPayload;
    }
  }

  _fetchSequenceEngine() {
    if (onboardingNavigationProcessingBankDetails != null) {
      sequenceEngineModel =
          onboardingNavigationProcessingBankDetails!.getSequenceEngineDetails();
    }
  }

  void _onPennyFailed(CheckAppFormModel pennyStatusModel) {
    isLoading = false;
    failureMessage =
        pennyStatusModel.responseBody["pennyTesting"]["failureReason"];
    if (pennyStatusModel.sequenceEngine != null) {
      sequenceEngineModel = pennyStatusModel.sequenceEngine!;
      AppAnalytics.trackWebEngageEventWithAttribute(
          eventName: WebEngageConstants.pennyTestFailureScreenLoaded);
      AppAnalytics.logAppsFlyerEvent(
          eventName: AppsFlyerConstants.pennyDropFailed);
      pennyTestingState = PennyTestingState.failure;
    }
  }

  Future<void> _onPennySuccess(CheckAppFormModel checkAppFormModel) async {
    isLoading = false;
    AppAnalytics.trackWebEngageEventWithAttribute(
        eventName: WebEngageConstants.pennyTestSuccessScreenLoaded);
    pennyTestingState = PennyTestingState.success;
    await Future.delayed(const Duration(seconds: 3));
    isLoading = false;
    navigateToNextScreen(checkAppFormModel);
  }

  void navigateToNextScreen(CheckAppFormModel checkAppFormModel) {
    if (onboardingNavigationProcessingBankDetails != null &&
        checkAppFormModel.sequenceEngine != null) {
      onboardingNavigationProcessingBankDetails!.toggleAppBarVisibility(true);
      onboardingNavigationProcessingBankDetails!.toggleAppBarTitle(true);
      onboardingNavigationProcessingBankDetails!.navigateUserToAppStage(
          sequenceEngineModel: checkAppFormModel.sequenceEngine!);
    } else {
      onNavigationDetailsNull(PROCESSING_BANK_DETAILS);
    }
  }

  getPennyTestingType() {
    PennyTestingDataTransferModel? pennyData =
        onboardingNavigationProcessingBankDetails!.getPennyTestingData();
    if (pennyData == null) {
      _getAppForm();
    } else {
      pennyTestingData = pennyData;
      pennyTestingState = PennyTestingState.pending;
    }
  }

  _getAppForm() async {
    getAppForm(
      onSuccess: _onAppFormApiSuccess,
      onApiError: _onAppFormApiError,
      onRejected: _onAppFormRejectionNavigation,
    );
  }

  _onAppFormApiSuccess(AppForm appForm) async {
    switch (appForm.pennyTestingVariant) {
      case 'PENNY_TESTING':
        pennyTestingData = PennyTestingDataTransferModel(
            pennyTestingType: PennyTestingType.forward);
        pennyTestingState = PennyTestingState.pending;
        break;
      case 'REVERSE_PENNY_TESTING':
        pennyTestingData = PennyTestingDataTransferModel(
            pennyTestingType: PennyTestingType.reverse);
        pennyTestingState = PennyTestingState.pending;
        break;
      default:

        /// if we r not able to find the type in api response
        handleAPIError(
            ApiResponse(
              state: ResponseState.jsonParsingError,
              apiResponse: "",
            ),
            screenName: PROCESSING_BANK_DETAILS,
            retry: _getAppForm);
    }
  }

  _onAppFormApiError(ApiResponse apiResponse) {
    isLoading = false;
    handleAPIError(
      apiResponse,
      retry: _getAppForm,
      screenName: PROCESSING_BANK_DETAILS,
    );
  }

  void _onAppFormRejectionNavigation(CheckAppFormModel checkAppFormModel) {
    isLoading = false;
    if (onboardingNavigationProcessingBankDetails != null) {
      onboardingNavigationProcessingBankDetails!
          .onAppFormRejected(model: checkAppFormModel.appFormRejectionModel);
    } else {
      onNavigationDetailsNull(PROCESSING_BANK_DETAILS);
    }
  }

  List<String> computeTitle() {
    switch (pennyTestingData.pennyTestingType) {
      case PennyTestingType.reverse:
        return ["Payment pending"];
      default:
        return ["Got 30 seconds?"];
    }
  }

  String getSuccessMessage() {
    switch (pennyTestingData.pennyTestingType) {
      case PennyTestingType.reverse:
        return "The deducted ₹1 will be reversed to your bank account within 48 hours";
      default:
        return "₹1 will be reversed to your account within 48 hours.";
    }
  }

  @override
  void onClose() {
    Get.log("onclose penny testing");
    stopPennyTestingPolling();
    super.onClose();
  }

  void goToBankDetails() {
    isLoading = false;
    if (onboardingNavigationProcessingBankDetails != null) {
      onboardingNavigationProcessingBankDetails!.toggleAppBarVisibility(true);
      onboardingNavigationProcessingBankDetails!.toggleAppBarTitle(true);
      onboardingNavigationProcessingBankDetails!
          .navigateUserToAppStage(sequenceEngineModel: sequenceEngineModel);
      pennyTestingState = PennyTestingState.pending;
    } else {
      onNavigationDetailsNull(PROCESSING_BANK_DETAILS);
    }
  }

  void _appFormRejectNavigation(AppFormRejectionModel appFormRejectionModel) {
    isLoading = false;
    if (onboardingNavigationProcessingBankDetails != null) {
      onboardingNavigationProcessingBankDetails!
          .onAppFormRejected(model: appFormRejectionModel);
    } else {
      onNavigationDetailsNull(PROCESSING_BANK_DETAILS);
    }
  }

  Duration computeDuration() {
    Duration diff =
        pennyTestingData.validUpto!.difference(pennyTestingData.currentTime!);

    return diff;
  }

  onClosePressed() {
    stopPennyTestingPolling();
    Get.back();
  }

  startPennyTestPolling() {
    _startPennyTestingPolling();
  }
}
