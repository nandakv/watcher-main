import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:privo/app/api/api_error_mixin.dart';
import 'package:privo/app/api/response_model.dart';
import 'package:privo/app/common_widgets/gradient_button.dart';
import 'package:privo/app/data/provider/auth_provider.dart';
import 'package:privo/app/data/repository/app_parameter_repository.dart';
import 'package:privo/app/data/repository/on_boarding_repository/kyc_repository.dart';
import 'package:privo/app/firebase/analytics.dart';
import 'package:privo/app/models/aadhaar_data_model.dart';
import 'package:privo/app/models/app_parameter_model.dart';
import 'package:privo/app/models/sequence_engine_model.dart';
import 'package:privo/app/modules/on_boarding/on_boarding_logic.dart';
import 'package:privo/app/modules/on_boarding/widgets/aadhaar_api/aadhaar_api_navigation.dart';
import 'package:privo/app/modules/on_boarding/widgets/digio_digilocker_aadhaar/digio_digilocker_aadhaar_logic.dart';
import 'package:privo/app/modules/on_boarding/widgets/kyc_aadhaar_selfie_status_view/kyc_verification_logic.dart';
import 'package:privo/app/utils/app_functions.dart';
import 'package:privo/app/utils/apps_flyer_constants.dart';
import 'package:privo/app/utils/web_engage_constant.dart';
import 'package:webengage_flutter/webengage_flutter.dart';

import '../../../../../flavors.dart';

import '../../../../common_widgets/blue_border_button.dart';
import '../../../../common_widgets/blue_button.dart';

import '../../../../common_widgets/bottom_sheet_widget.dart';
import '../../../../data/repository/on_boarding_repository/sequence_engine_repository.dart';
import '../../../../models/aadhaar_otp_model.dart';
import '../../../../models/check_app_form_model.dart';
import '../../../../theme/app_colors.dart';
import '../../../../utils/error_logger_mixin.dart';
import '../../../../utils/snack_bar.dart';
import '../../mixins/app_form_mixin.dart';
import '../../mixins/on_boarding_mixin.dart';

class AadhaarApiLogic extends GetxController
    with OnBoardingMixin, ApiErrorMixin, AppFormMixin, ErrorLoggerMixin {
  OnBoardingAadhaarApiNavigation? onBoardingAadhaarApiNavigation;

  AadhaarApiLogic({
    this.onBoardingAadhaarApiNavigation,
  });

  final _kycVerificationLogic = Get.find<KycVerificationLogic>();

  late String AADHAR_SCREEN = "aadhar";

  KYCRepository kycRepository = KYCRepository();

  static const String UPL_LOAN_PRODUCT_CODE = 'UPL';

  final int AADHAAR_TYPE_KARZA = 1;
  final String OTP_INPUT_ID = 'otp_input_id';

  late final String AADHAAR_TEXT_FIELD_ID = "AADHAAR_TEXT_FIELD_ID";

  ///retry count
  int _otpRetryCount = 0;
  final int MAXRETRY = 2;

  ///aadhaar API
  TextEditingController aadhaarNumberTextController = TextEditingController();
  TextEditingController aadhaarOtpTextController = TextEditingController();
  bool isAadhaarAPIFormFilled = false;
  bool showHelperText = true;
  bool showOTPField = false;
  final aadhaarApiFormKey = GlobalKey<FormState>();
  String aadhaarRequestID = "";
  bool isInvalidAadhaarNumber = false;

  String? _otpErrorText;

  String? get otpErrorText => _otpErrorText;

  set otpErrorText(String? value) {
    _otpErrorText = value;
    update([OTP_INPUT_ID]);
  }

  late SequenceEngineModel sequenceEngineModel;

  //loading variable to change the state of the page
  bool _isLoading = false;

  set isLoading(value) {
    _isLoading = value;
    update();
    if (onBoardingAadhaarApiNavigation != null) {
      onBoardingAadhaarApiNavigation!.toggleBack(isBackDisabled: _isLoading);
    } else {
      onNavigationDetailsNull(AADHAR_SCREEN);
    }
  }

  get isLoading => _isLoading;

  //loading variable to change the state of the button
  bool _isResendLoading = false;

  set isResendLoading(value) {
    _isResendLoading = value;
    update(['resend']);
  }

  get isResendLoading => _isResendLoading;

  bool isLowENVDigioMockEnabled = false;

  @override
  void onInit() {
    super.onInit();
    _checkForDigioMock();
  }

  _checkForDigioMock() async {
    if (F.appFlavor != Flavor.prod) {
      isLowENVDigioMockEnabled = await AppAuthProvider.isDigioMockEnabled;
      Get.log('isLowENVDigioMockEnabled: $isLowENVDigioMockEnabled');
    }
  }

  ///to reset the timer of resend button
  void resetAadhaarOTP() async {
    isResendLoading = true;
    aadhaarOtpTextController.text = "";
    otpErrorText = '';
    await onResendOTP();
    isResendLoading = false;
    // stateTimerStart();
  }

  /// onAadhaarDisagreePressed
  onAadhaarDisagreePressed() {
    Get.back();
  }

  ///when aadhaar and otp text field triggers
  onAadhaarApiTextChanged() {
    if (!showOTPField) {
      isAadhaarAPIFormFilled = aadhaarNumberTextController.text.isNotEmpty &&
          aadhaarNumberTextController.text.replaceAll(' ', '').length == 12;
      showHelperText = !aadhaarNumberTextController.text.isNotEmpty;
      if (isAadhaarAPIFormFilled) isInvalidAadhaarNumber = false;
      update();
    } else {
      showOTPField = aadhaarNumberTextController.text.isNotEmpty;
      showHelperText = !aadhaarNumberTextController.text.isNotEmpty;
      isAadhaarAPIFormFilled = aadhaarNumberTextController.text.isNotEmpty &&
          aadhaarNumberTextController.text.replaceAll(' ', '').length == 12 &&
          aadhaarOtpTextController.text.isNotEmpty &&
          aadhaarOtpTextController.text.length == 6;

      if (isAadhaarAPIFormFilled) isInvalidAadhaarNumber = false;

      otpErrorText = '';

      update();
    }
  }

  ///on aadhaar edit or retry tapped
  onAadhaarRetryTapped() async {
    if (isLoading || isResendLoading) return null;
    AppAnalytics.trackWebEngageEventWithAttribute(
        eventName: WebEngageConstants.aadhaarNumberEdit);
    Get.log("Timer func retry");
    showOTPField = false;
    aadhaarOtpTextController.text = "";
    otpErrorText = '';
    isAadhaarAPIFormFilled = true;
    update();
  }

  ///onResend OTP tapped
  onResendOTP() async {
    if (Get.focusScope != null) Get.focusScope!.unfocus();
    await sendAadhaarOTP();
  }

  ///on Aadhaar submit pressed
  onAadhaarContinue() async {
    if (aadhaarApiFormKey.currentState!.validate()) {
      if (!showOTPField) {
        AppAnalytics.logAppsFlyerEvent(
            eventName: AppsFlyerConstants.aadharEntered);
        AppAnalytics.trackWebEngageEventWithAttribute(
            eventName: WebEngageConstants.aadhaarNumberEntered);
        isLoading = true;
        sendAadhaarOTP();
      } else {
        if (aadhaarOtpTextController.text.isEmpty) {
          otpErrorText = "Enter OTP";
        } else if (F.appFlavor != Flavor.prod && isLowENVDigioMockEnabled) {
          _otpRetryCount++;
          otpErrorText = '';
          isLoading = true;
          await Future.delayed(const Duration(seconds: 2));
          isLoading = false;
          _computeFailure(
            ApiResponse(
              apiResponse: "mock otp retries - $_otpRetryCount",
              url: "",
              state: ResponseState.failure,
            ),
          );
        } else {
          otpErrorText = '';
          update(['resend']);
          isLoading = true;
          verifyAadhaarOTP();
        }
      }
    }
  }

  ///send aadhaar OTP
  Future sendAadhaarOTP() async {
    Map<String, String> body = {
      "consent": "Y",
      "aadhaarNo": aadhaarNumberTextController.text.replaceAll(' ', '')
    };

    AadhaarOTPModel aadhaarOTPModel = await kycRepository.sendOTP(body: body);

    switch (aadhaarOTPModel.apiResponse.state) {
      case ResponseState.success:
        _onAadhaarSendOTPSuccess(aadhaarOTPModel);
        break;
      default:
        isLoading = false;
        _showErrorBottomSheet();
    }
  }

  String _computeErrorMessage() {
    if (_otpRetryCount <= MAXRETRY) {
      return "The UIDAI Aadhaar website is currently experiencing technical issues. Please try again";
    }
    return "The UIDAI Aadhaar website is currently experiencing technical issues. Please verify your Aadhar via Digilocker";
  }

  void _onAadhaarSendOTPSuccess(AadhaarOTPModel aadhaarOTPModel) async {
    var statusCode = aadhaarOTPModel.statusCode;
    switch (statusCode) {
      case 101:
        aadhaarRequestID = aadhaarOTPModel.requestID;
        Fluttertoast.showToast(msg: aadhaarOTPModel.message!);
        showOTPField = true;
        update();
        isAadhaarAPIFormFilled = false;
        aadhaarOtpTextController.text = "";
        otpErrorText = '';
        isLoading = false;
        break;
      case 104:
        Fluttertoast.showToast(msg: "Please Try Again in Sometime");
        await Future.delayed(const Duration(seconds: 2));
        isLoading = false;
        break;
      default:
        isInvalidAadhaarNumber = true;
        isLoading = false;
    }
  }

  ///verify aadhaar OTP
  Future verifyAadhaarOTP() async {
    _otpRetryCount++;
    Map<String, String> body = {
      "otp": aadhaarOtpTextController.text,
      "requestId": aadhaarRequestID,
      "consent": "Y",
      "aadhaarNo": aadhaarNumberTextController.text.replaceAll(' ', '')
    };

    AadhaarDataModel aadhaarDataModel =
        await kycRepository.verifyOTP(body: body);

    switch (aadhaarDataModel.apiResponse.state) {
      case ResponseState.success:
        _onAadhaarDataDownloadSuccess(aadhaarDataModel);
        break;
      default:
        isLoading = false;
        _computeFailure(aadhaarDataModel.apiResponse);
    }
  }

  void _onAadhaarDataDownloadSuccess(AadhaarDataModel aadhaarDataModel) async {
    _otpRetryCount = 0;
    if (aadhaarDataModel.resultMap["status"] == 503) {
      _onAadhaar503();
    }
    var statusCode = aadhaarDataModel.resultMap['statusCode'];
    switch (statusCode) {
      case 101:
        await _onAadhaarSuccess(aadhaarDataModel);
        break;
      case 102:
        otpErrorText = "Enter the correct OTP";
        isLoading = false;
        break;
      case 104:
        _onAadhaarInvalidOtp();
        break;
      default:
        _onAadhaar503();
    }
  }

  void _onAadhaarInvalidOtp() {
    showOTPField = false;
    aadhaarOtpTextController.text = "";
    otpErrorText = '';
    AppSnackBar.errorBar(
        title: "Too many Invalid OTP Attempts",
        message: "Try again in sometime");
    isLoading = false;
    update();
  }

  void _onAadhaar503() {
    showOTPField = false;
    aadhaarOtpTextController.text = "";
    otpErrorText = '';
    AppSnackBar.errorBar(
        title: "Try Again Later", message: "Something went wrong");
    isLoading = false;
    update();
  }

  Future<void> _onAadhaarSuccess(AadhaarDataModel aadhaarDataModel) async {
    if (F.appFlavor != Flavor.prod) Fluttertoast.showToast(msg: "Success");

    Map<String, dynamic> resultBody =
        _makeResultBody(aadhaarDataModel.resultMap);
    webengageEventLogs(aadhaarDataModel);

    await AppFunctions().postUserDataToServer(
      thirdPartyName: "AadharXML",
      requestJson: {
        "url": F.envVariables.karzaKeys.url,
        "karzaKey": F.envVariables.karzaKeys.karzaKey,
        "environment": F.envVariables.karzaKeys.environment
      },
      responseJson: resultBody,
    );

    _sendAadhaarData(resultBody);
  }

  void webengageEventLogs(AadhaarDataModel aadhaarDataModel) {
    AppAnalytics.logAppsFlyerEvent(
        eventName: AppsFlyerConstants.aadharOTPEntered);
    AppAnalytics.trackWebEngageEventWithAttribute(
        eventName: WebEngageConstants.aadhaarOTPEntered);
    AppAnalytics.trackWebEngageEventWithAttribute(
        eventName: WebEngageConstants.aadhaarOtpSuccess);
    WebEngagePlugin.setUserGender(
        aadhaarDataModel.resultMap['result']['dataFromAadhaar']['gender']);
    AppAnalytics.trackWebEngageUser(
        userAttributeName: "GENDER",
        userAttributeValue: aadhaarDataModel.resultMap['result']
            ['dataFromAadhaar']['gender']);
  }

  Map<String, dynamic> _makeResultBody(Map<String, dynamic> apiMap) {
    Map<String, dynamic> result = apiMap['result']['dataFromAadhaar'];
    Map<String, dynamic> splitAddress =
        apiMap['result']['dataFromAadhaar']['address']['splitAddress'];
    String combinedAddress =
        apiMap['result']['dataFromAadhaar']['address']['combinedAddress'] ?? "";
    String shareCode = apiMap['result']['shareCode'];

    Map<String, dynamic> aadhaarMap = {
      "code": "200",
      "gender": result['gender'] ?? "",
      "address_po": splitAddress['postOffice'] ?? "",
      "address_state": splitAddress['state'] ?? "",
      "isEmailVerified": "",
      "isError": "",
      "emailHash": "",
      "address_loc": splitAddress['location'] ?? "",
      "imagebase64": result['image'],
      "maskedAahaarNumber": result['maskedAadhaarNumber'],
      "maskedAadhaarNumber": result['maskedAadhaarNumber'],
      "mobileHash": "",
      "address": combinedAddress,
      "address_house": splitAddress['houseNumber'] ?? "",
      "address_country": splitAddress['country'] ?? "",
      "address_subdist": splitAddress['subdistrict'] ?? "",
      "address_dist": splitAddress['district'] ?? "",
      "address_careof": result['fatherName'] ?? "",
      "zipFileBase64": 'data:application/zip;base64,${result['file']}',
      "address_pc": splitAddress['pincode'] ?? "",
      "isXmlVerify": "",
      "address_landmark": splitAddress['landmark'] ?? "",
      "sharecode": shareCode,
      "dob": result['dob'] ?? "",
      "address_street": splitAddress['street'] ?? "",
      "address_vtc": splitAddress['vtcName'] ?? "",
      "genDate": "",
      "name": result['name'] ?? "",
      "isMobileVerified": "",
      "type": AADHAAR_TYPE_KARZA,
    };

    return {
      "kyc": {
        "kycType": "aadhaarCard",
        "kycValue": aadhaarMap['maskedAadhaarNumber'],
        "issuedCountry": "IN"
      },
      "address": {
        "line1": generateLineOne(aadhaarMap),
        "line2": aadhaarMap['address_landmark'] ?? "",
        "state": aadhaarMap['address_state'] ?? "",
        "city": aadhaarMap['address_vtc'] ?? "",
        "country": "IN",
        "pinCode": aadhaarMap['address_pc'] ?? ""
      },
      "aadhaarRawResponse": apiMap,
      "aadhaar": aadhaarMap
    };
  }

  void _sendAadhaarData(Map<String, dynamic> resultBody) async {
    _getSequenceEngineModel();
    CheckAppFormModel model =
        await SequenceEngineRepository(sequenceEngineModel).makeHttpRequest(
      body: resultBody,
    );

    switch (model.apiResponse.state) {
      case ResponseState.success:
        _onAadhaarSendDataSuccess(model.sequenceEngine!);
        break;
      default:
        handleAPIError(model.apiResponse,
            screenName: AADHAR_SCREEN,
            retry: () => _sendAadhaarData(resultBody));
    }
  }

  _getSequenceEngineModel() {
    if (onBoardingAadhaarApiNavigation != null) {
      sequenceEngineModel =
          onBoardingAadhaarApiNavigation!.getSequenceEngineDetails();
    } else {
      onNavigationDetailsNull(AADHAR_SCREEN);
    }
  }

  _onAadhaarSendDataSuccess(SequenceEngineModel model) {
    if (onBoardingAadhaarApiNavigation != null) {
      isLoading = false;
      onBoardingAadhaarApiNavigation!
          .navigateUserToAppStage(sequenceEngineModel: model);
      _kycVerificationLogic.onAadhaarSuccess();
    } else {
      onNavigationDetailsNull(AADHAR_SCREEN);
    }
  }

  Future<bool> onBackPressed() async {
    var result = await Get.defaultDialog(
      backgroundColor: Colors.white,
      title: 'Are you sure want to go back now?',
      titlePadding: const EdgeInsets.all(6),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(
            height: 20,
          ),
          BlueButton(
            onPressed: () => Get.back(result: false),
            buttonColor: activeButtonColor,
            title: "STAY",
          ),
          const SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6.0),
            child: BlueBorderButton(
                onPressed: () {
                  if (showOTPField) {
                    AppAnalytics.trackWebEngageEventWithAttribute(
                        eventName: WebEngageConstants.aadhaarOtpScreenBackButton);
                  } else {
                    AppAnalytics.trackWebEngageEventWithAttribute(
                        eventName: WebEngageConstants.aadhaarBackButton);
                  }
                  Get.back(result: true);
                },
                buttonColor: activeButtonColor,
                title: "Go Back"),
          ),
        ],
      ),
    );
    return result != null && result;
  }

  onHomeBackPress() {
    if (showOTPField) {
      AppAnalytics.trackWebEngageEventWithAttribute(
          eventName: WebEngageConstants.aadhaarOtpScreenBackButton);
    } else {
      AppAnalytics.trackWebEngageEventWithAttribute(
          eventName: WebEngageConstants.aadhaarBackButton);
    }
  }

  _showErrorBottomSheet() {
    Get.bottomSheet(BottomSheetWidget(
      childPadding: const EdgeInsets.all(24),
      enableCloseIconButton: false,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            _computeErrorMessage(),
            style: _infobottomSheetTextTextStyle(),
            textAlign: TextAlign.center,
          ),
          const SizedBox(
            height: 15,
          ),
          GradientButton(
            edgeInsets:
                const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
            fillWidth: false,
            onPressed: () => _computeErrorButtonOnClicked(),
            title: _computeErrorButtonTitle(),
          ),
        ],
      ),
    ));
  }

  String _computeErrorButtonTitle() =>
      _otpRetryCount <= MAXRETRY ? "Try Again" : "Continue";

  void _computeErrorButtonOnClicked() {
    final logic = Get.find<DigioDigilockerAadhaarLogic>();
    if (_otpRetryCount <= MAXRETRY) {
      Get.back();
    } else {
      _otpRetryCount = 0;
      logic.isButtonLoading = false;
      logic.checkBoxValue = false;
      Get.back();
      _kycVerificationLogic.navigateToAadhaarMethodSelectionScreen();
      aadhaarNumberTextController.clear();
      aadhaarOtpTextController.clear();
    }
  }

  void _computeFailure(ApiResponse apiResponse) {
    logError(
      url: apiResponse.url,
      exception: apiResponse.exception,
      requestBody: apiResponse.requestBody,
      responseBody: apiResponse.apiResponse,
      statusCode: apiResponse.statusCode.toString(),
    );
    _showErrorBottomSheet();
  }

  // Future<bool> _checkForDigioMock() async {
  //   AppParameterModel model = await AppParameterRepository().getAppParameters();
  //   if (model.apiResponse.state == ResponseState.success) {
  //     return model.isLowEnvDigioMockEnabled;
  //   }
  //   return false;
  // }

  TextStyle _infobottomSheetTextTextStyle() {
    return const TextStyle(
        color: darkBlueColor,
        fontSize: 14,
        fontWeight: FontWeight.w500,
        fontFamily: 'Figtree',
        letterSpacing: 0.18);
  }
}
