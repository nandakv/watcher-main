import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:privo/app/common_widgets/bottom_sheet_widget.dart';
import 'package:privo/app/common_widgets/forms/base_field_validator.dart';
import 'package:privo/app/data/repository/on_boarding_repository/otp_udyam_repository.dart';
import 'package:privo/app/models/check_app_form_model.dart';
import 'package:privo/app/models/udyam_model/otp_udyam_details_model.dart';
import 'package:privo/app/modules/on_boarding/widgets/otp_udyam_screen/On_boarding_udyam_navigation.dart';
import 'package:privo/app/modules/on_boarding/widgets/otp_udyam_screen/udyam_validator.dart';
import 'package:privo/app/utils/error_logger_mixin.dart';
import '../../../../api/api_error_mixin.dart';
import '../../../../api/response_model.dart';
import '../../../../common_widgets/otp/bottom_sheet_otp_interface.dart';
import '../../../../common_widgets/otp/bottom_sheet_otp_logic.dart';
import '../../../../firebase/analytics.dart';
import '../../../../models/udyam_model/otp_udyam_model.dart';
import '../../../../utils/snack_bar.dart';
import '../../../../utils/web_engage_constant.dart';
import '../../../authentication/sign_in_screen/widget/sign_in_field_validator.dart';
import '../../mixins/app_form_mixin.dart';
import '../../mixins/on_boarding_mixin.dart';
import '../../../../common_widgets/otp/bottom_sheet_otp_widget.dart';

enum UdyamState { udyamScreen, loading, success, failure }

class OtpUdyamLogic extends GetxController
    with
        AppFormMixin,
        OnBoardingMixin,
        ApiErrorMixin,
        ErrorLoggerMixin,
        BaseFieldValidators,
        UdyamValidator,
        SignInFieldValidator
    implements BottomSheetOTPHandler {
  OnBoardingUdyamNavigation? onBoardingUdyamNavigation;
  late OTPUdyamDetailsModel otpUdyamResponseModel;
  late OTPUdyamModel otpUdyamModel;
  late CheckAppFormModel checkAppFormModel;
  late final String UDYAM_FIELD_ID = "udyam_field_id";
  late final String MOBILE_FIELD_ID = "mobile_field_id";
  final String BUTTON_KEY = 'button_key';
  final String OTP_PINPUT = "pinput";
  final String OTP_BUTTON = "otp_button";
  final String TEXTFIELD_KEY = 'number-field';
  final String OTP_UDYAM_SCREEN = 'otp_udyam_screen';

  String applicantId = "";
  String caseId = "";

  OtpUdyamLogic({this.onBoardingUdyamNavigation});

  final TextEditingController udyamController = TextEditingController();
  final TextEditingController mobileNumberController = TextEditingController();

  UdyamState _udyamState = UdyamState.loading;

  UdyamState get udyamState => _udyamState;

  set udyamState(UdyamState value) {
    _udyamState = value;
    update();
  }

  bool _consentCheckBoxValue = false;

  bool get consentCheckBoxValue => _consentCheckBoxValue;

  set consentCheckBoxValue(bool value) {
    _consentCheckBoxValue = value;
    update(["checkBox", "button"]);
  }

  //Sets the value to true if pin is entered
  final TextEditingController pinPutController = TextEditingController();
  final FocusNode pinPutFocusNode = FocusNode();

  bool readOnly = false;

  bool _showVerfied = false;

  bool get showVerfied => _showVerfied;

  set showVerfied(bool value) {
    _showVerfied = value;
    update([OTP_PINPUT, OTP_BUTTON, 'resend']);
  }

  bool _isPinSet = false;

  bool get isPinSet => _isPinSet;

  set isPinSet(bool value) {
    _isPinSet = value;
    update([BUTTON_KEY, OTP_BUTTON]);
  }

  ///loading variable to change the state of the button
  bool _isButtonLoading = false;

  set isButtonLoading(value) {
    _isButtonLoading = value;
    update(
        [OTP_PINPUT, OTP_BUTTON, 'resend', 'button', 'skip', 'verify_button']);
  }

  bool get isButtonLoading => _isButtonLoading;

  String otpErrorText = "";

  _clearOTPPage() {
    pinPutController.clear();
    otpErrorText = "";
  }

  ///loading variable to change the state of the button
  bool _isResendLoading = false;

  set isResendLoading(value) {
    _isResendLoading = value;
    update(['resend']);
  }

  get isResendLoading => _isResendLoading;

  BoxDecoration errorPinPutDecoration = BoxDecoration(
    borderRadius: BorderRadius.circular(4),
    color: Colors.grey.withOpacity(0.5),
    border: Border.all(color: const Color(0xffE35959), width: 2),
  );

  ///Box Decoration for the pin input of OTP
  BoxDecoration pinPutDecoration = BoxDecoration(
    color: Colors.grey.withOpacity(0.5),
    borderRadius: BorderRadius.circular(4),
  );

  BoxDecoration selectedFieldDecoration = BoxDecoration(
    color: Colors.grey.withOpacity(0.5),
    borderRadius: BorderRadius.circular(4),
  );

  onClosePressed() {
    Get.back();
  }

  FutureOr<void> afterLayout() {
    onBoardingUdyamNavigation?.toggleAppBarVisibility(true);
    getUdyamNumberCall();
  }

  final OTPUdyamRepository otpUdyamRepository = OTPUdyamRepository();

  //get udyam num and applicant id
  getUdyamNumberCall() async {
    OTPUdyamDetailsModel _otpUdyamResponseModel =
        await otpUdyamRepository.getUdyamNumber();
    switch (_otpUdyamResponseModel.apiResponse.state) {
      case ResponseState.success:
        otpUdyamResponseModel = _otpUdyamResponseModel;
        udyamState = UdyamState.udyamScreen;
        AppAnalytics.trackWebEngageEventWithAttribute(
          eventName: WebEngageConstants.udyamConsentScreenLoaded,
        );
        udyamController.text = otpUdyamResponseModel.udyam;
        _udyamNumberEvent();
        applicantId = otpUdyamResponseModel.applicantId;
        break;
      default:
        handleAPIError(
          _otpUdyamResponseModel.apiResponse,
          screenName: OTP_UDYAM_SCREEN,
          retry: getUdyamNumberCall,
        );
    }
  }

  void _udyamNumberEvent() {
    if (otpUdyamResponseModel.udyam.isNotEmpty) {
      readOnly = true;
      AppAnalytics.trackWebEngageEventWithAttribute(
          eventName: WebEngageConstants.udyamNumberPrePopulated,
          attributeName: {"Udyam_Number": otpUdyamResponseModel.udyam});
    }
  }

  bool getOtpButtonEnable() {
    if (consentCheckBoxValue &&
        isFieldValid(udyamNumberValidation(udyamController.text)) &&
        isFieldValid(validateMobileNumber(mobileNumberController.text))) {
      update(["button"]);
      return true;
    } else {
      return false;
    }
  }

  Future getOtpClicked() async {
    isButtonLoading = true;
    AppAnalytics.trackWebEngageEventWithAttribute(
        eventName: WebEngageConstants.otpRequestClicked);
    await _toGetOTP();
  }

  //Retrieving caseId
  Future<void> _toGetOTP({bool reSet = false}) async {
    Map<String, dynamic> body = {
      "applicantId": applicantId,
      "udyamNumber": udyamController.text,
      "phoneNumber": mobileNumberController.text
    };
    OTPUdyamModel _otpUdyamModel = await otpUdyamRepository.getUdyamOtp(body);
    switch (_otpUdyamModel.apiResponse.state) {
      case ResponseState.success:
        otpUdyamModel = _otpUdyamModel;
        caseId = otpUdyamModel.caseId;
        isButtonLoading = false;
        if (!reSet) {
          Get.bottomSheet(BottomSheetWidget(
              child: BottomSheetOTPWidget(
            bottomSheetOTPHandler: this,
            headerType: OTPHeaderType.otp,
          )),isScrollControlled: true);
        }
        break;
      default:
        handleAPIError(
          _otpUdyamModel.apiResponse,
          screenName: OTP_UDYAM_SCREEN,
          retry: _toGetOTP,
        );
    }
  }

//if success change the state to KYC aadhar
  Future<void> toUploadUdyamDocument(Function(String errorText) onError,
      String pinController, Function onShowVerified) async {
    Map<String, dynamic> body = {
      "action": null,
      "caseId": caseId,
      "applicantId": applicantId,
      "otp": pinController
    };
    CheckAppFormModel _checkAppFormModel =
        await otpUdyamRepository.getUdyamDoc(body);
    switch (_checkAppFormModel.apiResponse.state) {
      case ResponseState.success:
        checkAppFormModel = _checkAppFormModel;
        //onShowVerified();   // to show verified label in otp bottom sheet
        onError("");
        AppAnalytics.trackWebEngageEventWithAttribute(
            eventName: WebEngageConstants.udyamDocumentRetrieved,
            attributeName: {
              "Document_Id": checkAppFormModel.responseBody['docs']
                  ['sanction_letter']
            });
        await onSuccess();
        break;
      case ResponseState.badRequestError:
        onError('Enter the correct OTP');
        break;
      default:
        onFailure();
        _logUdyamDocError(_checkAppFormModel);
        break;
    }
  }

  void onFailure() {
    failureEvents();
    onBoardingUdyamNavigation?.toggleAppBarVisibility(false);
    udyamState = UdyamState.loading;
    consentCheckBoxValue = false;
    mobileNumberController.clear();
    Get.back();
    Future.delayed(const Duration(seconds: 5));
    udyamState = UdyamState.failure;
  }

  void failureEvents() {
    AppAnalytics.trackWebEngageEventWithAttribute(
        eventName: WebEngageConstants.otpVerificationFailed);
    AppAnalytics.trackWebEngageEventWithAttribute(
        eventName: WebEngageConstants.udyamDocumentRetrievalFailed,
        attributeName: {"Error_Reason": "Udyam document retrieval failed"});
  }

  Future<void> onSuccess() async {
    AppAnalytics.trackWebEngageEventWithAttribute(
        eventName: WebEngageConstants.otpVerificationSuccess);
    Get.back();
    onBoardingUdyamNavigation?.toggleAppBarVisibility(false);
    udyamState = UdyamState.success;
    await Future.delayed(const Duration(seconds: 5));
    navigateToNextScreen(checkAppFormModel);
  }

  void _logUdyamDocError(CheckAppFormModel _checkAppFormModel) {
    logError(
      url: _checkAppFormModel.apiResponse.url,
      requestBody: _checkAppFormModel.apiResponse.requestBody,
      exception: _checkAppFormModel.apiResponse.exception,
      responseBody: _checkAppFormModel.apiResponse.apiResponse,
      statusCode: "${_checkAppFormModel.apiResponse.statusCode}",
    );
  }

  Future<void> onSkipUdyam({isSkipBottomSheet = false}) async {
    isButtonLoading = true;
    AppAnalytics.trackWebEngageEventWithAttribute(
        eventName: WebEngageConstants.udyamFlowSkipped);
    Map<String, dynamic> skipBody = {
      "action": "skip",
    };
    CheckAppFormModel _checkAppFormModel =
        await otpUdyamRepository.getUdyamDoc(skipBody);
    switch (_checkAppFormModel.apiResponse.state) {
      case ResponseState.success:
        checkAppFormModel = _checkAppFormModel;
        if (isSkipBottomSheet) Get.back();
        navigateToNextScreen(checkAppFormModel);
        break;
      default:
        handleAPIError(
          _checkAppFormModel.apiResponse,
          screenName: OTP_UDYAM_SCREEN,
          retry: onSkipUdyam,
        );
    }
    isButtonLoading = false;
    update(["skip"]);
  }

  navigateToNextScreen(CheckAppFormModel checkAppFormModel) {
    Get.log("appform - ${checkAppFormModel.appFormId}");
    if (onBoardingUdyamNavigation != null &&
        checkAppFormModel.sequenceEngine != null) {
      onBoardingUdyamNavigation!.navigateUserToAppStage(
          sequenceEngineModel: checkAppFormModel.sequenceEngine!);
    } else {
      onNavigationDetailsNull(OTP_UDYAM_SCREEN);
    }
  }

  @override
  void onEditClick() {
    Get.back();
    _clearOTPPage();
  }

  ///Function to handle when the pin is submitted. Checks if the pin is matching with confirm pin
  ///and sets the label and button color
  @override
  onConfirmPinSubmitted(
      {required Function updateToLoading,
      required Function(String errorText) onError,
      required String otp,
      required Function(bool onPinSet) pinSet,
      required Function onShowVerified}) async {
    pinPutController.text = otp;
    if (otp.isNotEmpty) {
      selectedFieldDecoration = pinPutDecoration;
      update([OTP_PINPUT]);
      if (otp.length > 5) {
        pinPutFocusNode.unfocus();
        pinSet(true);
        updateToLoading();
        toUploadUdyamDocument(onError, otp, onShowVerified);
      } else {
        onError("");
        pinSet(false);
      }
    } else {
      onError("Enter OTP");
      selectedFieldDecoration = errorPinPutDecoration;
    }
  }

  @override
  resetOtp({bool reSet = false}) async {
    if (Get.focusScope != null) Get.focusScope!.unfocus();

    await AppSnackBar.successBar(
        title: "An OTP has been sent to your Mobile Number",
        message: mobileNumberController.text);
    isResendLoading = true;
    _toGetOTP(reSet: true);
    isResendLoading = false;
  }

  void checkBoxEvent(bool value) {
    AppAnalytics.trackWebEngageEventWithAttribute(
        eventName: WebEngageConstants.udyamConsentProvided,
        attributeName: {"checked": value});
  }

  void udyamNumberEvent() {
    if (RegExp(r'^[A-Za-z]{5}-[A-Za-z]{2}-\d{2}-\d{7}$')
        .hasMatch(udyamController.text)) {
      AppAnalytics.trackWebEngageEventWithAttribute(
          eventName: WebEngageConstants.udyamNumberEntered,
          attributeName: {"Udyam_Number": udyamController.text});
    }
  }

  ctaButtonEnable() {
    udyamNumberEvent();
    update(['button']);
  }

  @override
  String mobileNumber() {
    return mobileNumberController.text;
  }

  @override
  bool resendLoading() {
    return isResendLoading;
  }

  @override
  FocusNode get getPinPutFocus => pinPutFocusNode;
}
