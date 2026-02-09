import 'package:fluttertoast/fluttertoast.dart';
import 'package:privo/app/amplify/auth/amplify_auth.dart';
import 'package:privo/app/data/repository/local_repository.dart';
import 'package:privo/app/mixin/e_mandate_polling_mixin.dart';
import 'package:privo/app/mixin/withdrawal_polling_mixin.dart';
import 'package:privo/app/routes/app_pages.dart';
import 'package:get/get.dart';
import 'package:privo/app/services/data_cloud_service.dart';
import 'package:privo/app/services/lpc_service.dart';
import 'package:privo/app/services/sfmc_analytics.dart';
import 'package:sfmc/sfmc.dart';
import 'package:webengage_flutter/webengage_flutter.dart';

import '../../firebase/analytics.dart';
import '../../utils/web_engage_constant.dart';

///AuthProvider functions to be called in the respective controllers
///Contains : user check and logout function
///restart function to be called whenever app has to be restarted

class AppAuthProvider {
  static String CREDIT_SCORE_FEEDBACK = "credit_score_feedback";

  static Future<String> get getReferralCode async =>
      (await LocalRepository.get('referral_code'));

  static setReferralCode(String referralCode) async =>
      await LocalRepository.put('referral_code', referralCode);

  static Future setRawSmsSent() async {
    await LocalRepository.put('raw_sms_sent', 'true');
  }

  static Future<bool> get isRawSmsSent async {
    String rawSmsStatus = await LocalRepository.get('raw_sms_sent');
    return rawSmsStatus == 'true';
  }

  static Future<bool> get isPermissionPageShown async {
    String firstPermission = await LocalRepository.get('first_permission');
    return firstPermission == 'true';
  }

  static Future setPermissionPageShown() async {
    await LocalRepository.put('first_permission', 'true');
  }

  static Future<bool> get isLoanTermsPageShown async {
    String firstPermission = await LocalRepository.get('loan_terms');
    return firstPermission == 'true';
  }

  static Future setLoanTermsShown() async {
    await LocalRepository.put('loan_terms', 'true');
  }

  static Future<bool> get isWelcomePageShown async {
    String firstPermission = await LocalRepository.get('welcome_page');
    return firstPermission == 'true';
  }

  static Future setWelcomePageShown() async {
    await LocalRepository.put('welcome_page', 'true');
  }

  static Future<String> get userName async =>
      await LocalRepository.get('user_name');

  static Future<String> get phoneNumber async =>
      await LocalRepository.get("phone_number");

  static Future<String> get email async => await LocalRepository.get('email');

  static setEmail(String email) async {
    await LocalRepository.put('email', email);
  }

  static Future<bool> get isUserSignedUp async {
    String signUpStatus = await LocalRepository.get('user_sign_up');
    return signUpStatus == 'true';
  }

  static Future setIsUserSignedUp() async {
    await LocalRepository.put('user_sign_up', 'true');
  }

  static setUserName(String userName) async =>
      await LocalRepository.put('user_name', userName);

  static String get appFormID =>
      // "0e6d07e2-5b22-4ba0-b3dc-e4ffb1e221a7"; // TODO: remove after testing
      LPCService.instance.activeCard?.appFormId ?? "";

  static setNotifyMeClicked() async =>
      await LocalRepository.put('notify_me_clicked', 'true');

  static Future<bool> get isNotifyMeClicked async {
    String notifyMeClicked = await LocalRepository.get('notify_me_clicked');
    return notifyMeClicked == 'true';
  }

  static Future<String> get getLpc async =>
      LPCService.instance.activeCard?.loanProductCode ?? "";

  static setPhoneNumber(String phoneNumber) async {
    await LocalRepository.put(
        'phone_number', phoneNumber.trim().replaceAll("+91", ""));
  }

  static String get getCif => LPCService.instance.activeCard?.customerCif ?? "";

  static Future<String> get getIpAddress async =>
      await LocalRepository.get('ipAddress');

  static setLastSMSDateTime(String lastSMSTimeStamp) async {
    await LocalRepository.put('last_sms_time_stamp', lastSMSTimeStamp);
  }

  static Future<String> get getLastSMSDateTime async =>
      await LocalRepository.get('last_sms_time_stamp');

  static Future<String> get getFullName async =>
      await LocalRepository.get('full_name');

  static Future<String> get getCreditScore async =>
      await LocalRepository.get('credit_score');

  static Future<bool> workDetailsSubmitted() async {
    String workDetailsSubmitted =
        await LocalRepository.get('work_details_submitted');
    return workDetailsSubmitted == 'true';
  }

  static setAppFormID(String appFormID) async {
    await LocalRepository.put('app_form_id', appFormID);
    Get.log(appFormID);
  }

  static twoFactorAuthenticationComplete() async {
    await LocalRepository.put('two_factor_authentication', 'true');
  }

  static Future<bool> get shouldShowTwoFactorAuthentication async {
    String isTwoFactorAuthenticationDone =
        await LocalRepository.get('two_factor_authentication');
    return isTwoFactorAuthenticationDone != 'true';
  }

  static setUserLocationData(String locationData) async {
    await LocalRepository.put('user_location_data', locationData);
    Get.log("location data - $locationData");
  }

  static Future<String> get getUserLocationData async =>
      await LocalRepository.get('user_location_data');

  static setUserGoogleLocation(String locationData) async {
    await LocalRepository.put('user_google_location_data', locationData);
    Get.log("Google location data - $locationData");
  }

  static Future<String> get getUserGoogleLocationData async =>
      await LocalRepository.get('user_google_location_data');

  static setCif(String cif) async {
    await LocalRepository.put('cif', cif);
  }

  static setFullName(String fullName) async {
    await LocalRepository.put('full_name', fullName);
  }

  static setCreditScore(String score) async {
    await LocalRepository.put('credit_score', score);
  }

  static Future<bool> get isCreditScoreFeedbackGiven async {
    String creditScoreFeedback =
        await LocalRepository.get(CREDIT_SCORE_FEEDBACK);
    return creditScoreFeedback == 'true';
  }

  static setCreditScoreFeedbackGiven() async {
    await LocalRepository.put(CREDIT_SCORE_FEEDBACK, 'true');
  }

  static setDigioMockData(bool isDigioMockEnabled) async {
    await LocalRepository.put(
        'is_digio_mock_enabled', isDigioMockEnabled.toString());
    Get.log("Logged string ${isDigioMockEnabled}");
  }

  static Future<bool> get isDigioMockEnabled async =>
      (await LocalRepository.get('is_digio_mock_enabled')) == 'true';

  static setRawSmsData(String rawSms) async {
    await LocalRepository.put('raw_sms', rawSms);
    Get.log("Logged string ${rawSms}");
  }

  static setWorkDetailsSubmitted(bool isWorkDetailsSubmitted) async {
    await LocalRepository.put(
        'work_details_submitted', isWorkDetailsSubmitted.toString());
    Get.log("Logged string ${isWorkDetailsSubmitted}");
  }

  static setLpc(String lpc) async {
    await LocalRepository.put('lpc', lpc);
    Get.log("Logged string ${lpc}");
  }

  static setNonCLPLoanAgreementSnackBarShown() async {
    await LocalRepository.put('non_clp_loan_agreement_snackbar', 'true');
  }

  static Future<bool> get isNonCLPLoanAgreementSnackBarShown async {
    return await LocalRepository.get('non_clp_loan_agreement_snackbar') ==
        'true';
  }

  static setSBDBusinessDetailsSnackBarShown() async {
    await LocalRepository.put('sbd_business_details_snackbar', 'true');
  }

  static Future<bool> get isSBDBusinessDetailsSnackBarShown async {
    return await LocalRepository.get('sbd_business_details_snackbar') == 'true';
  }

  static setReportIssueEnabled(bool isReportIssueEnabled) async {
    await LocalRepository.put(
        'report_issue_enabled', isReportIssueEnabled.toString());
    Get.log("Logged string ${isReportIssueEnabled}");
  }

  static Future<bool> get isReportIssueEnabled async {
    String isReportIssueEnabled =
        await LocalRepository.get('report_issue_enabled');
    return isReportIssueEnabled == 'true';
  }

  static clearRawSmsData() async {
    await LocalRepository.clearValue('raw_sms');
  }

  static Future<String> get getRawSmsData async =>
      await LocalRepository.get('raw_sms');

  static Future logout() async {
    await AmplifyAuth.signOutCurrentUser();
    AppAnalytics.trackWebEngageEventWithAttribute(
        eventName: WebEngageConstants.userLoggedOut);
    WebEngagePlugin.userLogout();
    SFMCAnalytics().logout();
    LocalRepository.clearStorage();
    restartApp();
  }

  static setIdAddress(String ipAddress) async {
    await LocalRepository.put('ipAddress', ipAddress);
  }

  static Future restartApp() async =>
      await Get.offAllNamed(Routes.SIGN_IN_SCREEN);

  static Future<bool> get isEmiCalculatorIntroPageShown async {
    String isShown = await LocalRepository.get('emi_calculator_intro_page');
    return isShown == 'true';
  }

  static Future setEmiCalculatorIntroPageShown() async {
    await LocalRepository.put('emi_calculator_intro_page', 'true');
  }

  static Future<bool> get isCreditScoreHomeRefreshShown async {
    String isShown = await LocalRepository.get('credit_score_home_refresh');
    return isShown == 'true';
  }

  static Future setCreditScoreHomeRefreshShown() async {
    await LocalRepository.put('credit_score_home_refresh', 'true');
  }

  static List<String> get getAppFormList {
    return LPCService.instance.lpcCards.map((e) => e.appFormId).toList();
  }

  static Future<String> get utmDeepLinkData async {
    return await LocalRepository.get('utm_deep_link_data');
  }

  static setUtmDeepLinkData(String data) async {
    await LocalRepository.put('utm_deep_link_data', data);
  }

  static deleteUTMData() async {
    await LocalRepository.clearValue('utm_deep_link_data');
  }

  static Future<bool> get showFinSightsStoryMode async {
    String finSightsStoryModeEnable =
        await LocalRepository.get('finSights_story_mode');
    return finSightsStoryModeEnable != 'true';
  }

  static Future setShowFinSightsStoryMode() async {
    await LocalRepository.put('finSights_story_mode', 'true');
  }

  static Future<int> get aaRetryCount async {
    String retryCountStr = await LocalRepository.get('aa_retry_count') ?? '0';
    return int.tryParse(retryCountStr) ?? 0;
  }

  static Future setAARetryCount(int retryCount) async {
    await LocalRepository.put('aa_retry_count', retryCount.toString());
  }

  static Future<bool> get finsightsWaitList async {
    String showWaitingWaitList = await LocalRepository.get('wait_list');
    return showWaitingWaitList != 'true';
  }

  static Future setFinsightsWaitList() async {
    await LocalRepository.put('wait_list', 'true');
  }

  static Future<bool> get isReferralSuccessful async {
    String showWaitingWaitList =
        await LocalRepository.get('is_referral_successful');
    return showWaitingWaitList == 'true';
  }

  static Future setIsReferralSuccessful() async {
    await LocalRepository.put('is_referral_successful', 'true');
  }

  static Future<bool> get isReferralLeaderBoardNotified async {
    String isReferralLeaderBoardNotified =
        await LocalRepository.get('referral_leader_board');
    return isReferralLeaderBoardNotified == 'true';
  }

  static Future setReferralLeaderBoardNotified() async {
    await LocalRepository.put('referral_leader_board', 'true');
  }

  static Future<bool> get showReferral async {
    String showReferralScreen = await LocalRepository.get('show_referral');
    return showReferralScreen == 'true';
  }

  static Future setShowReferral(bool showReferral) async {
    await LocalRepository.put('show_referral', showReferral ? 'true' : 'false');
  }

  static Future<bool> get appRatingPrompted async {
    String appRatingPrompted = await LocalRepository.get('app_rating_prompted');
    return appRatingPrompted != 'true';
  }

  static Future setAppRatingPrompted() async {
    await LocalRepository.put('app_rating_prompted', 'true');
  }

  Future<int?> deviceDetailsRefreshWindow() async {
    String appRatingPrompted =
        await LocalRepository.get('device_details_refresh_window');
    if (appRatingPrompted.isEmpty) {
      return null;
    } else {
      return int.tryParse(appRatingPrompted);
    }
  }

  setDeviceDetailsRefreshWindow([int? value]) async {
    if (value == null) return;
    await LocalRepository.put(
        'device_details_refresh_window', value.toString());
  }

  static Future<bool> get finsightsShowPolling async {
    String finsightsShowPolling = await LocalRepository.get('show_polling');
    return finsightsShowPolling == 'true';
  }

  static Future setFinsightsShowPolling({bool showPolling=true}) async {
    await LocalRepository.put('show_polling', showPolling.toString());
  }
}
