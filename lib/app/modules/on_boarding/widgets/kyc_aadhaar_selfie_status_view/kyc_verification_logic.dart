import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hypersnapsdk_flutter/hypersnapsdk_flutter.dart';

// import 'package:hypersnapsdk_flutter/hv_result.dart';
import 'package:privo/app/api/api_error_mixin.dart';
import 'package:privo/app/api/response_model.dart';
import 'package:privo/app/common_widgets/blue_button.dart';
import 'package:privo/app/common_widgets/bottom_sheet_radio_button/bottom_sheet_radio_button_logic.dart';
import 'package:privo/app/common_widgets/bottom_sheet_radio_button/bottom_sheet_radio_button_widget.dart';
import 'package:privo/app/common_widgets/gradient_button.dart';
import 'package:privo/app/data/repository/app_parameter_repository.dart';
import 'package:privo/app/data/repository/on_boarding_repository/kyc_repository.dart';
import 'package:privo/app/data/repository/on_boarding_repository/on_boarding_repository.dart';
import 'package:privo/app/data/repository/on_boarding_repository/sequence_engine_repository.dart';
import 'package:privo/app/firebase/analytics.dart';
import 'package:privo/app/mixin/kyc_polling_mixin.dart';
import 'package:privo/app/models/app_form_rejection_model.dart';
import 'package:privo/app/models/app_parameter_model.dart';
import 'package:privo/app/models/check_app_form_model.dart';
import 'package:privo/app/models/sequence_engine_model.dart';
import 'package:privo/app/models/vkyc_initiate_model.dart';
import 'package:privo/app/modules/on_boarding/mixins/app_form_mixin.dart';
import 'package:privo/app/modules/on_boarding/mixins/on_boarding_mixin.dart';
import 'package:privo/app/modules/on_boarding/user_state_maps.dart';
import 'package:permission_handler/permission_handler.dart' as pes;
import 'package:privo/app/modules/on_boarding/widgets/kyc_aadhaar_selfie_status_view/kyc_aadhaar_selfie_status_navigation.dart';
import 'package:privo/app/modules/on_boarding/widgets/kyc_aadhaar_selfie_status_view/widgets/aadhaar_step_info_bottom_sheet.dart';
import 'package:privo/app/modules/on_boarding/widgets/kyc_aadhaar_selfie_status_view/widgets/vkyc_error_bottom_sheet_widget.dart';
import 'package:privo/app/modules/on_boarding/widgets/kyc_aadhaar_selfie_status_view/widgets/vkyc_info_bottom_sheet_widget.dart';
import 'package:privo/app/theme/app_colors.dart';
import 'package:privo/app/utils/app_functions.dart';
import 'package:privo/app/utils/apps_flyer_constants.dart';
import 'package:privo/app/utils/native_channels.dart';
import 'package:privo/app/utils/snack_bar.dart';
import 'package:privo/app/utils/web_engage_constant.dart';
import 'package:privo/flavors.dart';

import '../../../../../res.dart';
import '../../../../mixin/app_analytics_mixin.dart';
import '../digio_digilocker_aadhaar/digio_digilocker_aadhaar_logic.dart';
import 'kyc_analytics_mixin.dart';

enum KycVerificationState {
  loading, //to decide if selfie or vkyc
  aadhaar,
  selfie,
  vKYC,
  vkycToSelfie,
  okycExpiredToSelfie,
  okycExpiredToAadhaar,
  polling,
  aadharDetails,
  aadharMethodSelection,
  digioDigilocker,
  kycSuccess
}

enum AadhaarVerificationType { digilocker, aadhaarOtp }

class KycVerificationLogic extends GetxController
    with
        ApiErrorMixin,
        OnBoardingMixin,
        KycPollingMixin,
        AppFormMixin,
        AppAnalyticsMixin,
        KycAnalyticsMixin {
  static const String SELFIE_SCREEN = "selfie";
  static const String AADHAR_SCREEN = "aadhar";
  static const String VKYC_SCREEN = "vkyc";
  static const String AADHAR_METHOD_SELECTION_SCREEN =
      "aadhar_method_selection_screen";
  static const String KYC_POLLING_SCREEN = "kyc_polling";
  static const String UPL_LOAN_PRODUCT_CODE = 'UPL';
  static const String SBL_LOAN_PRODUCT_CODE = 'SBL';
  static const String CLP_LOAN_PRODUCT_CODE = 'CLP';

  List<String> kycSteppers = [];

  // bool isVKYC = true;
  VKYCAvailabilityModel? vkycAvailability;
  bool buttonEnabled = true;
  bool isFlowVKYC = false;

  AadhaarVerificationType verificationType = AadhaarVerificationType.digilocker;

  final String APP_STEPPER_ID = "APP_STEPPER_ID";
  late final String AADHAAR_SELECTION_ID = "AADHAAR_SELECTION_ID";
  double currentAppStepperState = 0;

  KycVerificationLogic({this.kycVerificationNavigation});

  OnBoardingKycVerificationNavigation? kycVerificationNavigation;

  KycVerificationState _kycVerificationState = KycVerificationState.loading;

  KycVerificationState get kycVerificationState => _kycVerificationState;

  late SequenceEngineModel sequenceEngineModel;

  late CheckAppFormModel kycSuccessCheckAppForm;

  set kycVerificationState(KycVerificationState value) {
    _kycVerificationState = value;
    update();

    switch (value) {
      case KycVerificationState.vKYC:
        AppAnalytics.trackWebEngageEventWithAttribute(
          eventName: WebEngageConstants.vKYCScreenLoaded,
        );
        isFlowVKYC = true;
        _computeVKYCAvailability();
        break;
      case KycVerificationState.polling:
        _toggleBackPress(isBackDisabled: true);
        _enablePolling = true;
        startPolling();
        break;
      case KycVerificationState.loading:
      case KycVerificationState.aadhaar:
      case KycVerificationState.selfie:
      case KycVerificationState.aadharDetails:
      case KycVerificationState.digioDigilocker:
      case KycVerificationState.kycSuccess:
      default:
    }

    computeAppStepperState();
  }

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  set isLoading(bool value) {
    _isLoading = value;
    update();
    _toggleBackPress(isBackDisabled: value);
  }

  static const String KYC_POLLING_LOGIC = "kyc_polling_logic";

  static const String QC_APPROVED_STATUS = "15";

  bool _enablePolling = true;

  final String VKYC_TRY_AGAIN_CTA_ID = "vkyc_try_again_cta_id";

  bool _isRequestingVKYC = false;

  bool get isRequestingVKYC => _isRequestingVKYC;

  set isRequestingVKYC(bool value) {
    _isRequestingVKYC = value;
    update([VKYC_TRY_AGAIN_CTA_ID]);
  }

  bool _isVKYCPolling = false;

  late DigioDigilockerAadhaarLogic digiLockerLogic;

  Future<void> computeButtonAction() async {
    switch (kycVerificationState) {
      case KycVerificationState.aadhaar:
        kycVerificationState = KycVerificationState.aadharMethodSelection;
        digiLockerLogic = Get.find<DigioDigilockerAadhaarLogic>();
        logAadharOptionScreenLoaded();
        break;
      case KycVerificationState.selfie:
        onOpenCamera();
        break;
      case KycVerificationState.vKYC:
        AppAnalytics.trackWebEngageEventWithAttribute(
            eventName: WebEngageConstants.continueVKYCClicked);
        _storeVKYCConsent();
        break;
      default:
        break;
    }
  }

  onStepInfoClicked() {
    logAadharOptionScreenStepInfoClick(kycVerificationState);
    Get.bottomSheet(
      const AadhaarStepInfoBottomSheet(),
      enableDrag: false,
      isScrollControlled: true,
    );
  }

  storeAadharConsent() async {
    digiLockerLogic.isButtonLoading = true;
    ApiResponse apiResponse = await KYCRepository().storeAadharConsent();
    switch (apiResponse.state) {
      case ResponseState.success:
        onAadhaarVerificationTypeSelected();
        break;
      default:
        digiLockerLogic.isButtonLoading = false;
        handleAPIError(apiResponse,
            screenName: AADHAR_METHOD_SELECTION_SCREEN,
            retry: storeAadharConsent);
        break;
    }
  }

  onAadhaarVerificationTypeSelected() {
    switch (verificationType) {
      case AadhaarVerificationType.digilocker:
        logAadharOptionScreenCtaClick(digilockerString);
        digiLockerLogic.startDigioSDK();
        break;
      case AadhaarVerificationType.aadhaarOtp:
        logAadharOptionScreenCtaClick(aadhaarOTPString);
        kycVerificationState = KycVerificationState.aadharDetails;
        break;
    }
  }

  String computeButtonTitle() {
    switch (kycVerificationState) {
      case KycVerificationState.aadhaar:
        return "Verify Aadhaar";
      case KycVerificationState.selfie:
        return "Open Camera";
      default:
        return "Continue";
    }
  }

  ///when the open camera is clicked
  ///it checks for the camera permission
  onOpenCamera() async {
    if (await pes.Permission.camera.isGranted) {
      AppAnalytics.trackWebEngageEventWithAttribute(
          eventName: WebEngageConstants.openCamera);
      startSelfieSDK();
    } else {
      var result = await Get.defaultDialog(
        title: "Need Camera Permission",
        content:
            const Text("Please Allow to the camera permission to continue"),
        contentPadding: const EdgeInsets.all(16),
        radius: 8,
        actions: [
          BlueButton(
            onPressed: () => Get.back(result: true),
            buttonColor: activeButtonColor,
            title: "OKAY",
          ),
        ],
      );

      if (result != null && result) {
        await pes.Permission.camera.request();
      }

      onOpenCamera();
    }
  }

  onVerificationTypeChanged(AadhaarVerificationType? type) {
    if (type == null || digiLockerLogic.isButtonLoading) return;
    verificationType = type;
    update([AADHAAR_SELECTION_ID]);
  }

  ///Opens the hyperverge selfie SDK
  ///on success [getLiveNessScore()] will be triggered
  ///if the liveness failed alert pop-up will be displayed
  startSelfieSDK() async {
    try {
      isLoading = true;

      // HVFaceCapture.faceCaptureSetLivenessAPIParameters({
      //   "allowEyesClosed": "no",
      //   "allowMultipleFaces": "no",
      //   "rejectBlur": "yes",
      //   "rejectFaceMask": "yes",
      // });

      await HVFaceCapture.start(
        onComplete: onFaceCaptureComplete,
        hvFaceConfig: HVFaceConfig(
          hvLivenessAPIDetails: HVLivenessAPIDetails(
            params: {
              "allowEyesClosed": "no",
              "allowMultipleFaces": "no",
              "rejectBlur": "yes",
              "rejectFaceMask": "yes",
            },
          ),
        ),
      );
    } catch (e) {
      Get.log("selfie sdk exeption - $e");
      Get.log(e.toString());
      isLoading = false;
      AppSnackBar.errorBar(
          title: "Oops!!! Something went wrong", message: 'Try Again Later');
    }
  }

  onFaceCaptureComplete(HVResponse? hvResponse, HVError? error) async {
    if (error != null) {
      Get.log("selfie error - ${error.errorMessage}");
      print("selfie error - ${error.errorMessage}");
      isLoading = false;
      _showError("Sorry", "Face not detected in Selfie Image");
    } else if (hvResponse != null &&
        hvResponse.apiResult != null &&
        hvResponse.imageUri != null) {
      var faceResultObj = hvResponse.apiResult!;

      Get.log("hvResponse - $faceResultObj");
      print("hvResponse - $faceResultObj");

      await AppFunctions().postUserDataToServer(
        thirdPartyName: "SelfieData",
        requestJson: {
          "AppId": F.envVariables.hypervergeKeys.appId,
          "AppKey": F.envVariables.hypervergeKeys.appKey
        },
        responseJson: faceResultObj,
      );

      if (faceResultObj["result"]["live"] == "yes") {
        _sendSelfieData(
            hvResponse.imageUri!, faceResultObj["result"]["liveness-score"]);
      } else {
        isLoading = false;
        _showError("Sorry", "Face not detected in Selfie Image");
      }
    } else {
      Get.log("response is null");
      isLoading = false;
      _showError("Sorry", "Face not detected in Selfie Image");
    }
  }

  void _sendSelfieData(String imagePath, String livenessScore) async {
    isLoading = true;
    List<int> imageBytes = await File(imagePath).readAsBytes();
    String base64Image = base64Encode(imageBytes);

    Map<String, dynamic> body = {
      'livenessScore': double.parse(livenessScore),
      'selfie': base64Image,
    };

    if (kycVerificationNavigation != null) {
      _fetchSequenceEngine();
      CheckAppFormModel model =
          await SequenceEngineRepository(sequenceEngineModel).makeHttpRequest(
        body: body,
      );
      switch (model.apiResponse.state) {
        case ResponseState.success:
          _checkError(model);
          break;
        default:
          handleAPIError(
            model.apiResponse,
            screenName: SELFIE_SCREEN,
            retry: () => _sendSelfieData(imagePath, livenessScore),
          );
      }
    }
  }

  _fetchSequenceEngine() {
    if (kycVerificationNavigation != null) {
      sequenceEngineModel =
          kycVerificationNavigation!.getSequenceEngineDetails();
    }
  }

  _checkError(CheckAppFormModel model) {
    if (model.error != null) {
      _showError("Sorry", model.error!.errorBody.message);
    } else {
      _onSendSelfieDataSuccess(model);
    }
  }

  _getLoanProductCode(Map<String, dynamic> responseBody) {
    if (responseBody["loanProduct"] == null) {
      return responseBody["selfieDoc"]["loanProduct"];
    } else {
      return responseBody["loanProduct"];
    }
  }

  void _onSendSelfieDataSuccess(CheckAppFormModel checkAppFormModel) {
    AppAnalytics.logAppsFlyerEvent(
        eventName: AppsFlyerConstants.selfieUploaded);
    AppAnalytics.logAppsFlyerEvent(
        eventName: AppsFlyerConstants.selfieCompleted);
    AppAnalytics.logAppsFlyerEvent(eventName: AppsFlyerConstants.kycCompleted);
    logSelfieCompleted();
    _navigateToNextScreen(checkAppFormModel);
  }

  void _navigateToNextScreen(
    CheckAppFormModel checkAppFormModel, {
    bool switchToSelfie = false,
  }) {
    if (kycVerificationNavigation != null &&
        checkAppFormModel.sequenceEngine != null) {
      kycVerificationNavigation!.navigateUserToAppStage(
          sequenceEngineModel: checkAppFormModel.sequenceEngine!);

      _computeKycSteppers(checkAppFormModel.responseBody);

      switch (checkAppFormModel.sequenceEngine!.appState) {
        case "$KYC_AADHAAR":
          kycVerificationState = KycVerificationState.aadhaar;
          break;
        case "$KYC_SELFIE":
          kycVerificationState = KycVerificationState.selfie;
          break;
        case "$VKYC":
          kycVerificationState = KycVerificationState.vKYC;
          break;
        case "$KYC_POLLING":
          kycVerificationState = KycVerificationState.polling;
          break;
      }
    } else {
      onNavigationDetailsNull(SELFIE_SCREEN);
    }
  }

  void _showError(String title, String message) {
    isLoading = false;
    Get.defaultDialog(
      title: title,
      content: Text(message),
      contentPadding: const EdgeInsets.all(16),
      radius: 8,
      actions: [
        GradientButton(
          onPressed: () => Get.back(),
          title: "Retake",
        ),
      ],
    );
  }

  void startPolling() async {
    try {
      _toggleBackPress(isBackDisabled: true);
      isLoading = true;
      _fetchSequenceEngine();
      startKycPolling(
        onApiError: _onKycError,
        onRejected: _onAppFormRejectionNavigation,
        sequenceEngineModel: sequenceEngineModel,
        requestPayload: _fetchRequestPayload(),
        onSuccess: _onKycSuccess,
      );
    } catch (e) {
      Get.log("Exception is ${e.toString()}");
    }
  }

  _onKycError(ApiResponse apiResponse) {
    handleAPIError(apiResponse,
        screenName: KYC_POLLING_SCREEN, retry: startPolling);
  }

  _fetchRequestPayload() {
    if (kycVerificationNavigation != null) {
      sequenceEngineModel =
          kycVerificationNavigation!.getSequenceEngineDetails();
      return _computePollingNotNull();
    }
  }

  _computePollingNotNull() {
    if (sequenceEngineModel.onPolling != null) {
      return sequenceEngineModel.onPolling!.requestPayload;
    }
  }

  void _toggleBackPress({required bool isBackDisabled}) {
    if (kycVerificationNavigation != null) {
      kycVerificationNavigation!.toggleBack(isBackDisabled: isBackDisabled);
    } else {
      onNavigationDetailsNull(KYC_POLLING_LOGIC);
    }
  }

  void _onAppFormRejectionNavigation(
      AppFormRejectionModel appFormRejectionModel) {
    if (kycVerificationNavigation != null) {
      AppAnalytics.logAppsFlyerEvent(eventName: AppsFlyerConstants.kycRejected);
      AppAnalytics.trackWebEngageEventWithAttribute(
          eventName: WebEngageConstants.kycVerificationFailureScreenLoaded);
      kycVerificationNavigation!
          .onAppFormRejected(model: appFormRejectionModel);
    } else {
      onNavigationDetailsNull(KYC_POLLING_LOGIC);
    }
  }

  void _onKycSuccess(CheckAppFormModel checkAppFormModel) async {
    isLoading = false;
    if (checkAppFormModel.sequenceEngine != null) {
      sequenceEngineModel = checkAppFormModel.sequenceEngine!;
      _toggleAppBarVisibility(showAppBar: false);
      kycVerificationState = KycVerificationState.kycSuccess;
      AppAnalytics.trackWebEngageEventWithAttribute(
          eventName: WebEngageConstants.kycVerificationSuccessScreenLoaded);
      await Future.delayed(const Duration(seconds: 5));
      continueToLineAgreement();
    } else {
      onNavigationDetailsNull(KYC_POLLING_LOGIC);
    }
  }

  void continueToLineAgreement() {
    if (kycVerificationNavigation != null) {
      kycVerificationNavigation!
          .navigateUserToAppStage(sequenceEngineModel: sequenceEngineModel);
    } else {
      onNavigationDetailsNull(KYC_POLLING_LOGIC);
    }
  }

  @override
  void onClose() {
    _enablePolling = false;
    _isVKYCPolling = false;
    Get.log("enable polling = $_enablePolling");
    super.onClose();
  }

  Future<void> onAfterLayout(KycVerificationState userState) async {
    logKYCLoaded();
    kycVerificationNavigation?.toggleAppBarVisibility(true);
    getAppForm(
      onApiError: (ApiResponse apiResponse) {
        handleAPIError(apiResponse,
            retry: () => onAfterLayout(userState),
            screenName: _computeScreenName(userState));
      },
      onRejected: (CheckAppFormModel appFormModel) {
        _onAppFormRejectionNavigation(appFormModel.appFormRejectionModel);
      },
      onSuccess: (AppForm appForm) {
        isFlowVKYC = appForm.isVKYCFlow;
        _computeKycSteppers(appForm.responseBody);
        _computeKycState(userState, appForm);
      },
    );
  }

  _computeKycSteppers(Map<String, dynamic> responseBody) {
    try {
      List<String> kycSteppers =
          List<String>.from(responseBody['kycSteps']).map((e) => e).toList();
      this.kycSteppers = kycSteppers;
    } catch (e) {
      ApiResponse apiResponse = ApiResponse(
        state: ResponseState.failure,
        apiResponse: "",
        exception: "Kyc Steps key not found",
      );
      handleAPIError(apiResponse, screenName: SELFIE_SCREEN);
    }
  }

  bool get showStepText => kycSteppers.length >= 2;

  String _computeScreenName(KycVerificationState userState) {
    switch (userState) {
      case KycVerificationState.loading:
      case KycVerificationState.aadhaar:
      case KycVerificationState.aadharDetails:
      case KycVerificationState.aadharMethodSelection:
      case KycVerificationState.digioDigilocker:
        return AADHAR_SCREEN;
      case KycVerificationState.selfie:
        return SELFIE_SCREEN;
      case KycVerificationState.vKYC:
      case KycVerificationState.vkycToSelfie:
      case KycVerificationState.okycExpiredToSelfie:
      case KycVerificationState.okycExpiredToAadhaar:
        return VKYC_SCREEN;
      case KycVerificationState.polling:
        return KYC_POLLING_SCREEN;
      case KycVerificationState.kycSuccess:
        return "kyc_success";
    }
  }

  Future<void> _computeKycState(
      KycVerificationState userState, AppForm appForm) async {
    kycVerificationState = userState;
    switch (kycVerificationState) {
      case KycVerificationState.aadhaar:
        AppAnalytics.trackWebEngageEventWithAttribute(
            eventName: WebEngageConstants.kycParentScreenLoaded);
        computeSanctionLetterInfoSnackBar(appForm.responseBody["loanProduct"]);
        break;
      case KycVerificationState.polling:
      // _enablePolling = true;
      // startPolling();
      // break;
      case KycVerificationState.vKYC:
      case KycVerificationState.selfie:
      case KycVerificationState.aadharDetails:
      case KycVerificationState.digioDigilocker:
      default:
        break;
    }
  }

  computeSanctionLetterInfoSnackBar(String lpc) {
    switch (lpc) {
      case "SBL":
      case "UPL":
        return showSanctionLetterInfoSnackBar();
      case "CLP":
        break;
    }
  }

  onAadhaarSuccess() {
    _fetchSequenceEngine();
    kycVerificationState = sequenceEngineModel.appState == "$VKYC"
        ? KycVerificationState.vKYC
        : KycVerificationState.selfie;
    if (kycVerificationNavigation != null) {
      ///show appbar title
      kycVerificationNavigation!.toggleAppBarTitle(true);
    } else {
      onNavigationDetailsNull(KYC_POLLING_LOGIC);
    }
  }

  showSanctionLetterInfoSnackBar() {
    Get.showSnackbar(
      GetSnackBar(
        messageText: Row(
          children: [
            const SizedBox(
              width: 10,
            ),
            SvgPicture.asset(
              Res.information_svg,
              height: 12,
              color: const Color(0xff161742),
            ),
            const SizedBox(
              width: 10,
            ),
            const Expanded(
              child: Text(
                'You will receive the sanction letter on your e-mail and SMS',
                style: TextStyle(
                  color: Color(0xff161742),
                  fontSize: 10,
                  letterSpacing: 0.16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: 25,
          vertical: 10,
        ),
        duration: const Duration(seconds: 3),
        snackPosition: SnackPosition.TOP,
        backgroundColor: const Color(0xffFFF3EB),
      ),
    );
  }

  computeAppStepperState() {
    switch (kycVerificationState) {
      case KycVerificationState.loading:
      case KycVerificationState.aadhaar:
      case KycVerificationState.aadharDetails:
      case KycVerificationState.digioDigilocker:
        currentAppStepperState = 1;
        break;
      case KycVerificationState.selfie:
      case KycVerificationState.vKYC:
        currentAppStepperState = 2;
        break;
      case KycVerificationState.polling:
      case KycVerificationState.kycSuccess:
        currentAppStepperState = 3;
        break;
    }
    update([APP_STEPPER_ID]);
  }

  navigateToAadhaarMethodSelectionScreen() {
    kycVerificationState = KycVerificationState.aadharMethodSelection;
    onVerificationTypeChanged(AadhaarVerificationType.digilocker);
  }

  _storeVKYCConsent() async {
    isLoading = true;
    isRequestingVKYC = true;
    ApiResponse apiResponse = await KYCRepository().storeVKYCConsent();
    switch (apiResponse.state) {
      case ResponseState.success:
        isLoading = false;
        _videoKYCInfoBottomSheet();
        break;
      default:
        handleAPIError(apiResponse,
            screenName: VKYC_SCREEN, retry: _storeVKYCConsent);
    }
  }

  void _videoKYCInfoBottomSheet() async {
    var result = await Get.bottomSheet(VKYCInfoBottomSheetWidget());
    if (result != null && result) {
      AppAnalytics.trackWebEngageEventWithAttribute(
          eventName: WebEngageConstants.connectWithAgentClicked);
      initiateVKYC(true);
    }
  }

  initiateVKYC(bool startPolling) async {
    isLoading = true;
    isRequestingVKYC = true;
    VKYCInitiateModel vkycInitiateModel = await KYCRepository().initiateVKYC();
    switch (vkycInitiateModel.apiResponse.state) {
      case ResponseState.success:
        if (vkycInitiateModel.isSwitchToSelfie) {
          isRequestingVKYC = true;
        } else {
          _openCustomTab(vkycInitiateModel, startPolling);
        }
        break;
      default:
        handleAPIError(
          vkycInitiateModel.apiResponse,
          screenName: VKYC_SCREEN,
          retry: () => initiateVKYC(startPolling),
        );
    }
  }

  void _openCustomTab(
    VKYCInitiateModel vkycInitiateModel,
    bool startPolling,
  ) async {
    NativeFunctions().openCustomTab(
      customTabURL: vkycInitiateModel.vkycWaitPageUrl,
    );
    isRequestingVKYC = false;
    if (startPolling) {
      _isVKYCPolling = true;
      _startVKYCStatusPolling();
    }
  }

  void _startVKYCStatusPolling() async {
    _fetchSequenceEngine();
    CheckAppFormModel checkAppFormModel =
        await SequenceEngineRepository(sequenceEngineModel).makeHttpRequest(
      body: sequenceEngineModel.onPolling!.requestPayload,
    );
    switch (checkAppFormModel.apiResponse.state) {
      case ResponseState.success:
        _checkIfAppFormRejected(checkAppFormModel);
        break;
      default:
        handleAPIError(
          checkAppFormModel.apiResponse,
          screenName: VKYC_SCREEN,
          retry: _startVKYCStatusPolling,
        );
    }
  }

  _checkIfAppFormRejected(CheckAppFormModel checkAppFormModel) {
    if (checkAppFormModel.appFormRejectionModel.isRejected) {
      isRequestingVKYC = false;
      _isVKYCPolling = false;
      isLoading = false;
      AppAnalytics.trackWebEngageEventWithAttribute(
          eventName: WebEngageConstants.vkycRejectedLoaded);
      _onAppFormRejectionNavigation(checkAppFormModel.appFormRejectionModel);
    } else {
      _computeVKYCStatus(checkAppFormModel);
    }
  }

  void _computeVKYCStatus(CheckAppFormModel checkAppFormModel) async {
    try {
      VKYCPollingStatus vkycPollingStatus =
          checkAppFormModel.vKYCPollingStatus!;

      switch (vkycPollingStatus) {
        case VKYCPollingStatus.newUser:
        case VKYCPollingStatus.retryingExpiredOkyc:
          isRequestingVKYC = false;
          _isVKYCPolling = false;
          isLoading = false;
          break;
        case VKYCPollingStatus.rejected:
          _isVKYCPolling = false;
          isRequestingVKYC = false;
          _logEventsOnVKYCStatusChange(status: vkycPollingStatus);
          _navigateToNextScreen(checkAppFormModel);
          break;
        case VKYCPollingStatus.physicalKYC:
          _isVKYCPolling = false;
          isRequestingVKYC = false;
          _logEventsOnVKYCStatusChange(status: vkycPollingStatus);
          _navigateToNextScreen(checkAppFormModel);
          break;
        case VKYCPollingStatus.complete:
          _isVKYCPolling = false;
          isRequestingVKYC = false;
          _logEventsOnVKYCStatusChange(status: vkycPollingStatus);
          _navigateToNextScreen(checkAppFormModel);
          break;
        case VKYCPollingStatus.switchToSelfie:
          _showTransitionScreen(
              checkAppFormModel, KycVerificationState.vkycToSelfie);
          break;
        case VKYCPollingStatus.okycExpiredToSelfie:
          _showTransitionScreen(
              checkAppFormModel, KycVerificationState.okycExpiredToSelfie);
          break;
        case VKYCPollingStatus.okycExpiredToAadhaar:
          _showTransitionScreen(
              checkAppFormModel, KycVerificationState.okycExpiredToAadhaar);
          break;
        case VKYCPollingStatus.open:
          isRequestingVKYC = false;
          if (_isVKYCPolling && vkycPollingStatus == VKYCPollingStatus.open) {
            await Future.delayed(
              Duration(
                  seconds: sequenceEngineModel.onPolling?.callFrequency ?? 5),
            );
            _startVKYCStatusPolling();
          }
          break;
        case VKYCPollingStatus.agentAssigned:
          isRequestingVKYC = true;
          if (_isVKYCPolling) {
            await Future.delayed(
              Duration(
                  seconds: sequenceEngineModel.onPolling?.callFrequency ?? 5),
            );
            _startVKYCStatusPolling();
          }
          break;
        case VKYCPollingStatus.failure:
          isRequestingVKYC = false;
          _isVKYCPolling = false;
          isLoading = false;
          _vkycErrorBottomSheet();
          break;
      }
    } catch (e) {
      handleAPIError(
        checkAppFormModel.apiResponse
          ..state = ResponseState.jsonParsingError
          ..exception = e.toString(),
        screenName: VKYC_SCREEN,
        retry: _startVKYCStatusPolling,
      );
    }
  }

  _toggleAppBarVisibility({required bool showAppBar}) {
    if (kycVerificationNavigation != null) {
      kycVerificationNavigation!.toggleAppBarVisibility(showAppBar);
    } else {
      onNavigationDetailsNull(KYC_POLLING_LOGIC);
    }
  }

  Future<void> _showTransitionScreen(CheckAppFormModel checkAppFormModel,
      KycVerificationState kycState) async {
    isFlowVKYC = false;
    _isVKYCPolling = false;
    isRequestingVKYC = false;
    isLoading = false;
    _toggleBackPress(isBackDisabled: true);
    _toggleAppBarVisibility(showAppBar: false);
    kycVerificationState = kycState;
    await Future.delayed(const Duration(seconds: 5));
    _toggleBackPress(isBackDisabled: false);
    _toggleAppBarVisibility(showAppBar: true);
    _navigateToNextScreen(
      checkAppFormModel,
      switchToSelfie: true,
    );
  }

  void _logEventsOnVKYCStatusChange({required VKYCPollingStatus status}) {
    switch (status) {
      case VKYCPollingStatus.complete:
        AppAnalytics.trackWebEngageEventWithAttribute(
            eventName: WebEngageConstants.vkycVerificationSuccessLoaded);
        AppAnalytics.logAppsFlyerEvent(
            eventName: AppsFlyerConstants.kycCompleted);
        break;
      case VKYCPollingStatus.rejected:
        AppAnalytics.trackWebEngageEventWithAttribute(
            eventName: WebEngageConstants.vkycVerificationAgentReject);
        break;
      case VKYCPollingStatus.physicalKYC:
        AppAnalytics.trackWebEngageEventWithAttribute(
            eventName: WebEngageConstants.vkycVerificationAgentUnable);
        break;
      default:
        break;
    }
  }

  void _vkycErrorBottomSheet() async {
    AppAnalytics.trackWebEngageEventWithAttribute(
        eventName: WebEngageConstants.retryVkycLoaded);
    var result = await Get.bottomSheet(
      const VKYCErrorBottomSheetWidget(),
      isDismissible: false,
    );
    if (result != null && result) {
      AppAnalytics.trackWebEngageEventWithAttribute(
          eventName: WebEngageConstants.retryKYCClicked);
      initiateVKYC(true);
    } else if (result != null && !result) {
      AppAnalytics.trackWebEngageEventWithAttribute(
          eventName: WebEngageConstants.retryCloseClicked);
      onVideoKycRetryClosePressed();
    }
  }

  onVideoKycRetryClosePressed() async {
    AppAnalytics.trackWebEngageEventWithAttribute(
        eventName: WebEngageConstants.feedbackScreenLoaded);
    var result = await Get.bottomSheet(
      BottomSheetRadioButtonWidget(
        title: "Tell us what went Wrong?",
        titleTextStyle: const TextStyle(
          fontWeight: FontWeight.w500,
          color: darkBlueColor,
          fontSize: 14,
        ),
        radioValues: _radioValues(),
        enableOtherTextField: true,
        ctaButtonsBuilder: (BottomSheetRadioButtonLogic logic) => [
          GradientButton(
            onPressed: () {
              _onSubmitPressed(logic);
            },
            title: "Submit",
          ),
          _feedBackCancelButton(),
        ],
        onWillPop: _onFeebackWindowPopped,
      ),
      isScrollControlled: true,
      enableDrag: false,
      isDismissible: false,
    );

    Get.log("result - $result");

    if (result != null && result is Map) {
      if (result['close_parent']) {
        Get.back();
      }
    }
  }

  void _onSubmitPressed(BottomSheetRadioButtonLogic logic) {
    logic.onSubmitPressed(
      onSubmitPressed: (selectedValue) async {
        AppAnalytics.trackWebEngageEventWithAttribute(
            eventName: WebEngageConstants.reasonSubmitted,
            attributeName: {"selected_reason": selectedValue});
        AppAnalytics.trackWebEngageEventWithAttribute(
          eventName: WebEngageConstants.feebackSuccessfullySubmitted,
        );
      },
    );
  }

  List<String> _radioValues() {
    return [
      "I don’t have my PAN & Aadhar documents",
      "My Internet connection is weak ",
      "I’ll do it later.",
      "Taking Longer than expected",
      "Agent doesn’t speak my native language",
      "Session got intruppted"
    ];
  }

  bool _onFeebackWindowPopped(bool showSuccessScreen) {
    if (showSuccessScreen) {
      Get.back(
        result: {
          "close_parent": showSuccessScreen,
        },
      );
    }
    return true;
  }

  bool computeVkycNonAvailabilityBadge() {
    return !(vkycAvailability?.enabled ?? false) &&
        kycVerificationState == KycVerificationState.vKYC;
  }

  Center _feedBackCancelButton() {
    return Center(
      child: TextButton(
        onPressed: () {
          AppAnalytics.trackWebEngageEventWithAttribute(
            eventName: WebEngageConstants.feedbackWindowClosed,
          );
          Get.back();
        },
        style: TextButton.styleFrom(
          visualDensity: const VisualDensity(
            horizontal: -4,
            vertical: -4,
          ),
        ),
        child: Text(
          "Cancel",
          style: GoogleFonts.poppins(
            color: skyBlueColor,
            fontWeight: FontWeight.w400,
            fontSize: 12,
            decoration: TextDecoration.underline,
          ),
        ),
      ),
    );
  }

  void _computeVKYCAvailability() async {
    isLoading = true;
    isRequestingVKYC = true;
    AppParameterModel model = await AppParameterRepository().getAppParameters();
    switch (model.apiResponse.state) {
      case ResponseState.success:
        vkycAvailability = model.vkycAvailability;
        buttonEnabled = vkycAvailability?.enabled ?? false;
        _isVKYCPolling = true;
        _startVKYCStatusPolling();
        break;
      default:
        handleAPIError(model.apiResponse,
            screenName: VKYC_SCREEN, retry: _computeVKYCAvailability);
    }
  }

  bool showPoweredByCS() {
    return (kycVerificationNavigation?.isPartnerFlow() ?? false) &&
        kycVerificationState != KycVerificationState.kycSuccess;
  }
}
