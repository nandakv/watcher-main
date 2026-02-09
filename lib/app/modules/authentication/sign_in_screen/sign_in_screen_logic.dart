import 'dart:async';

import 'package:amplify_core/amplify_core.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:privo/app/amplify/auth/amplify_auth.dart';
import 'package:privo/app/firebase/analytics.dart';
import 'package:privo/app/modules/authentication/sign_in_screen/model/lpc_info_model.dart';
import 'package:privo/app/modules/authentication/sign_in_screen/widget/otp_text_field.dart';
import 'package:privo/app/modules/authentication/sign_in_screen/widget/refree_widget/refree_bottom_sheet.dart';
import 'package:privo/app/routes/app_pages.dart';
import 'package:privo/app/services/deep_link_service/deep_link_service.dart';
import 'package:privo/app/services/sfmc_analytics.dart';
import 'package:privo/app/utils/web_engage_constant.dart';
import 'package:smart_auth/smart_auth.dart';
import 'package:webengage_flutter/webengage_flutter.dart';

import '../../../../res.dart';
import '../../../api/api_error_mixin.dart';
import '../../../data/provider/auth_provider.dart';
import '../../../services/platform_services/platform_services.dart';
import '../../../utils/apps_flyer_constants.dart';
import '../../../utils/firebase_constants.dart';
import '../../../utils/snack_bar.dart';
import 'widget/sign_in_bottom_sheet.dart';

enum SignInPageState { phoneNumber, otp }

///Controller class to handle all the backend logics of the mobile screen
class SignInScreenLogic extends GetxController with ApiErrorMixin {
  TextEditingController mobileNoController = TextEditingController();
  FocusNode mobileNoFocusNode = FocusNode();

  final List<LegacyInfo> legacyData = [
    LegacyInfo(title: "AAA", value: "CRISIL\nRating"),
    LegacyInfo(title: "1M+", value: "Happy\nCustomers"),
    LegacyInfo(title: "47", value: "Branches\nNationwide"),
    LegacyInfo(title: "7+", value: "Years of\nTrusted Service"),
  ];

  final List<LpcInfoModel> introImages = [
    LpcInfoModel(
        image: Res.sblIntro,
        title: "Small Business Loans",
        message: "Tailored loans to support small businesses and enterprises"),
    // LpcInfoModel(
    //     image: Res.privoIntro,
    //     title: "Privo Instant Credit",
    //     message:
    //         "Quick and hassle free loans to meet immediate financial needs"),
    LpcInfoModel(
        image: Res.loanManagementIntro,
        title: "Loan Management",
        message:
            "Manage your loans, estimate EMIs, check your credit score and more.."),
  ];

  int _currentIntroImageIndex = 0;

  String ANIMATED_IMAGES_ID = 'ANIMATED_IMAGES';

  int get currentIntroImageIndex => _currentIntroImageIndex;

  set currentIntroImageIndex(int value) {
    _currentIntroImageIndex = value;
    update([ANIMATED_IMAGES_ID]);
  }

  late final SmsRetrieverImpl smsRetrieverImpl;

  int _carousalIndex = 0;

  int get carousalIndex => _carousalIndex;

  set carousalIndex(int ind) {
    _carousalIndex = ind;
    update([CAROUSAL_INDICATOR]);
  }

  ///loading variable to change the state of the button
  bool _isResendLoading = false;

  set isResendLoading(value) {
    _isResendLoading = value;
    update(['resend']);
  }

  AnimationController? animationController;
  Animation<double>? animation;

  get isResendLoading => _isResendLoading;

  bool _showConsent = false;

  bool get showConsent => _showConsent;

  set showConsent(bool val) {
    _showConsent = val;
    update([CONSENT_KEY]);
  }

  //Sets the value to true if pin is entered
  final TextEditingController pinPutController = TextEditingController();
  final FocusNode pinPutFocusNode = FocusNode();

  final String TEXTFIELD_KEY = 'number-field';
  final String CONSENT_KEY = 'consent';
  final String BUTTON_KEY = 'button_key';
  final String PAN_CHECK_BOX_KEY = 'check_box_one_key';
  final String CAROUSAL_INDICATOR = "carousal_indicator";
  final String OTP_PINPUT = "pinput";
  final String OTP_BUTTON = "otp_button";

  int _otpRetryCount = 0;

  bool _isPinSet = false;

  bool get isPinSet => _isPinSet;

  set isPinSet(bool value) {
    _isPinSet = value;
    update([BUTTON_KEY]);
  }

  late Timer timer;

  String otpErrorText = "";

  ///loading variable to change the state of the button
  bool _isButtonLoading = false;

  set isButtonLoading(value) {
    _isButtonLoading = value;
    update([BUTTON_KEY, OTP_PINPUT, TEXTFIELD_KEY, OTP_BUTTON, 'resend']);
  }

  bool get isButtonLoading => _isButtonLoading;

  bool _showVerfied = false;

  bool get showVerfied => _showVerfied;

  set showVerfied(bool value) {
    _showVerfied = value;
    update([BUTTON_KEY, OTP_PINPUT, TEXTFIELD_KEY, OTP_BUTTON, 'resend']);
  }

  BoxDecoration selectedFieldDecoration = BoxDecoration(
    color: Colors.grey.withOpacity(0.5),
    borderRadius: BorderRadius.circular(4),
  );

  ///Box Decoration for the pin input of OTP
  BoxDecoration pinPutDecoration = BoxDecoration(
    color: Colors.grey.withOpacity(0.5),
    borderRadius: BorderRadius.circular(4),
  );

  BoxDecoration errorPinPutDecoration = BoxDecoration(
    borderRadius: BorderRadius.circular(4),
    color: Colors.grey.withOpacity(0.5),
    border: Border.all(color: const Color(0xffE35959), width: 2),
  );

  @override
  void onInit() {
    super.onInit();
    smsRetrieverImpl = SmsRetrieverImpl(SmartAuth.instance);
    AppAnalytics.trackWebEngageEventWithAttribute(
        eventName: WebEngageConstants.registrationScreenLoading);
    _listenMobileFocusNode();
  }

  void _switchAnimatedImage() {
    if (currentIntroImageIndex == 2) {
      currentIntroImageIndex = 0;
    } else {
      currentIntroImageIndex++;
    }
  }

  _listenMobileFocusNode() {
    mobileNoFocusNode.addListener(() {
      if (mobileNoFocusNode.hasFocus) {
        if (showConsent == false) {
          showConsent = true;
        }
      }
    });
  }

  String? _errorText;

  String? get errorText => _errorText;

  set errorText(String? errorText) {
    _errorText = errorText;
    update([TEXTFIELD_KEY]);
  }

  final formKey = GlobalKey<FormState>();

  SignInPageState _signInPageState = SignInPageState.phoneNumber;

  SignInPageState get signInPageState => _signInPageState;

  set signInPageState(SignInPageState val) {
    _signInPageState = val;
    isButtonLoading = false;
    update();
  }

  set setNumber(String value) {
    errorText = null;
    isNumber = value.length == 10;
  }

  ///This variable is set to true when the text entered by user is a valid number
  ///and to enable the continue button
  bool _isNumber = false;

  bool get isNumber => _isNumber;

  set isNumber(bool value) {
    _isNumber = value;
    update([BUTTON_KEY]);
    _checkButtonEnable();
  }

  bool _isButtonEnabled = false;

  bool get isButtonEnabled => _isButtonEnabled;

  set isButtonEnabled(bool value) {
    _isButtonEnabled = value;
    update([BUTTON_KEY]);
  }

  bool _panConsentCheckBoxValue = false;

  bool get panConsentCheckBoxValue => _panConsentCheckBoxValue;

  set panConsentCheckBoxValue(bool value) {
    _panConsentCheckBoxValue = value;
    update([PAN_CHECK_BOX_KEY, BUTTON_KEY]);
    AppAnalytics.trackWebEngageEventWithAttribute(
        eventName: _panConsentCheckBoxValue
            ? WebEngageConstants.panCIBILConsentCheck
            : WebEngageConstants.panCIBILConsentUnCheck);
    _checkButtonEnable();
  }

  _checkButtonEnable() {
    isButtonEnabled = isNumber && panConsentCheckBoxValue;
  }

  void onContinueTapped() async {
    AppAnalytics.logButtonClicks(
        buttonName: 'mobile_continue',
        screenName: Routes.MOBILE_SCREEN,
        value: mobileNoController.text);

    if (mobileNoController.text.isEmpty ||
        mobileNoController.text.length != 10) {
      errorText = "Enter a valid number";
    } else if (panConsentCheckBoxValue) {
      Get.focusScope!.unfocus();

      isButtonLoading = true;
      AppAnalytics.trackWebEngageEventWithAttribute(
          eventName: WebEngageConstants.mobileNumberInput,
          attributeName: {'Status': true});
      AppAnalytics.trackWebEngageEventWithAttribute(
          eventName: WebEngageConstants.registrationFlowContinueCTA);
      switch (await AmplifyAuth().signIn(
        phoneNumber: mobileNoController.text,
      )) {
        case SignInState.success:
          _onSendOTPSuccess();
          break;
        case SignInState.error:
          isButtonLoading = false;
          errorText = "Try Again Later";
          break;
        case SignInState.phoneNumberNotValid:
          isButtonLoading = false;
          errorText = "Enter a valid number";
          break;
      }
    } else {
      Fluttertoast.showToast(msg: "Please Accept the Consent");
    }
  }

  void onEditPhoneNo() async {
    if (!showVerfied && !isButtonLoading) {
      _goToPhoneNoPageFromOTPPAge();
      _clearOTPPage();
      await AppAnalytics.trackWebEngageEventWithAttribute(
          eventName: WebEngageConstants.editNumberCTA);
    }
  }

  _clearOTPPage() {
    pinPutController.clear();
    otpErrorText = "";
  }

  _goToPhoneNoPageFromOTPPAge() {
    signInPageState = SignInPageState.phoneNumber;
    isButtonEnabled = true;
    _otpRetryCount = 0;
  }

  void _onSendOTPSuccess() {
    isButtonLoading = false;
    signInPageState = SignInPageState.otp;
    isButtonEnabled = false;
  }

  ///to reset the timer of resend button
  Future resetOTP() async {
    if (Get.focusScope != null) Get.focusScope!.unfocus();
    isResendLoading = true;

    await AmplifyAuth().signIn(phoneNumber: mobileNoController.text);

    await AppSnackBar.successBar(
        title: "An OTP has been sent to your Mobile Number",
        message: mobileNoController.text);

    isResendLoading = false;
  }

  ///Function to handle when the pin is submitted. Checks if the pin is matching with confirm pin
  ///and sets the label and button color
  void onConfirmPinSubmitted() async {
    if (pinPutController.text.isNotEmpty) {
      otpErrorText = "";
      selectedFieldDecoration = pinPutDecoration;
      update(['pinput']);
      if (pinPutController.value.text.length > 5) {
        pinPutFocusNode.unfocus();
        isPinSet = true;
        AppAnalytics.trackWebEngageEventWithAttribute(
            eventName: WebEngageConstants.OTPInput);
        AppAnalytics.trackWebEngageEventWithAttribute(
            eventName: WebEngageConstants.verifyOTPInput);
        pushToNextScreen(pinPutController.text);
      } else {
        isPinSet = false;
      }
    } else {
      otpErrorText = "Enter OTP";
      selectedFieldDecoration = errorPinPutDecoration;
      update(['pinput']);
    }
  }

  ///Push to next [Routes.MOBILE_SCREEN] if it is coming from email screen
  /// and [Routes.ON_BOARDING_SCREEN] if it is coming from  mobile screen
  void pushToNextScreen(String value) async {
    isButtonLoading = true;
    AppAnalytics.logButtonClicks(
        buttonName: 'otp_continue',
        screenName: Routes.OTP_SCREEN,
        value: value);

    _otpRetryCount++;

    switch (await AmplifyAuth().verifyOTP(otp: pinPutController.text)) {
      case VerifyOTPState.success:
        isButtonLoading = false;
        showVerfied = true;
        await Future.delayed(Duration(seconds: 2));
        AuthUser user = await Amplify.Auth.getCurrentUser();
        String subId = user.userId;
        WebEngagePlugin.userLogin(subId);
        AppAnalytics.trackWebEngageEventWithAttribute(
            eventName: WebEngageConstants.userLoggedIn);
        AppAnalytics.trackWebEngageEventWithAttribute(
            eventName: WebEngageConstants.OTPVerify,
            attributeName: {'Status': true});
        await _onVerifyOTPSuccess();
        break;
      case VerifyOTPState.error:
        isButtonLoading = false;
        otpErrorText = "Try Again Later";
        pinPutDecoration = errorPinPutDecoration;
        update(['pinput']);
        break;
      case VerifyOTPState.invalidOTP:
        isButtonLoading = false;
        otpErrorText = "Enter the correct OTP";
        pinPutDecoration = errorPinPutDecoration;
        update(['pinput']);
        break;
      case VerifyOTPState.notAuthorized:
        Fluttertoast.showToast(
            msg: _computeToastMessageForNotAuthorizedException());

        _goToPhoneNoPageFromOTPPAge();
        _clearOTPPage();
        break;
    }
  }

  String _computeToastMessageForNotAuthorizedException() {
    return _otpRetryCount < 3
        ? "Session Expired"
        : "Too many Attempts with Incorrect OTP\nTry Again";
  }

  Future<void> _onVerifyOTPSuccess() async {
    AppAnalytics.logFirebaseEvents(eventName: FirebaseConstants.signUp);
    await AppAuthProvider.setPhoneNumber(mobileNoController.text);
    await SFMCAnalytics().setContactKey();
    if (await AppAuthProvider.isUserSignedUp) {
      AppAnalytics.logAppsFlyerEvent(
        eventName: AppsFlyerConstants.signUp,
      );
      PrivoPlatform.platformService.fetchAndPostDeviceDetails();
    }

    await Get.offAllNamed(Routes.SPLASH_SCREEN);
  }

  @override
  void codeUpdated() {
    onConfirmPinSubmitted();
  }

  Future<bool> onBackPress() async {
    if (isButtonLoading || isResendLoading) {
      Fluttertoast.showToast(msg: "Please Wait");
      return false;
    }
    return true;
  }

  onCarousalChange(int index, reason) {
    carousalIndex = index;
  }

  String computeButtonTitle() {
    return signInPageState == SignInPageState.phoneNumber
        ? "Get Started"
        : "Verify";
  }

  bool computeIsButtonEnabled() {
    return signInPageState == SignInPageState.phoneNumber
        ? isButtonEnabled
        : isPinSet;
  }

  resendOTP() async {
    await resetOTP();
    AppAnalytics.trackWebEngageEventWithAttribute(
        eventName: WebEngageConstants.resendOTP);
  }

  FutureOr moveToNextImage() {
    currentIntroImageIndex = (currentIntroImageIndex + 1) % introImages.length;
    forwardAnimation();
    update([ANIMATED_IMAGES_ID]);
  }

  void initAnimationControllers(TickerProvider vsync) {
    animationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: vsync,
    );
    if (animationController != null) {
      animation =
          Tween<double>(begin: 0.0, end: 1.0).animate(animationController!);

      forwardAnimation();

      timer = Timer.periodic(const Duration(seconds: 5), (Timer timer) {
        reverseAnimation();
      });
    }
  }

  void onGetStartedClicked() async {
    AppAnalytics.trackWebEngageEventWithAttribute(
        eventName: WebEngageConstants.getStartedClicked,
        attributeName: {'screen no': currentIntroImageIndex});
    stopAnimation();
    timer.cancel();

    await Get.bottomSheet(SignInBottomSheet(), isDismissible: false);

    if (isClosed) {
      return;
    }

    forwardAnimation();
    timer = Timer.periodic(const Duration(seconds: 5), (Timer timer) {
      reverseAnimation();
    });
  }

  void onCloseTapped() {
    Get.back();
  }

  void stopAnimation() {
    if (animationController != null && animationController!.isAnimating) {
      animationController!.stop();
    }
  }

  void disposeAnimation() {
    animationController?.dispose();
  }

  void forwardAnimation() {
    if (animationController != null) {
      animationController!.forward();
    }
  }

  void reverseAnimation() {
    if (animationController != null) {
      animationController!.reverse().then((_) {
        if (!isClosed) {
          moveToNextImage();
        }
      });
    }
  }

  @override
  void onClose() {
    mobileNoController.dispose();
    mobileNoFocusNode.dispose();
    pinPutController.dispose();
    pinPutFocusNode.dispose();

    timer.cancel();

    disposeAnimation();

    super.onClose();
  }
}

class LegacyInfo {
  String title;
  String value;

  LegacyInfo({required this.title, required this.value});
}
