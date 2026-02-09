import 'dart:convert';

import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:appsflyer_sdk/appsflyer_sdk.dart';
import 'package:intl/intl.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:privo/app/amplify/auth/amplify_auth.dart';
import 'package:privo/app/data/provider/auth_provider.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';
import 'package:privo/app/services/data_cloud_service.dart';
import 'package:privo/app/utils/app_functions.dart';
import 'package:privo/watcher_secrets.dart';
import 'package:sfmc/sfmc.dart';
import 'package:webengage_flutter/webengage_flutter.dart';
import 'package:privo/app/routes/app_pages.dart';
import 'package:privo/app/services/deep_link_service/deep_link_service.dart';

import '../../flavors.dart';

class AppAnalytics {
  static final FirebaseAnalytics analytics = FirebaseAnalytics.instance;

  static late final AppsflyerSdk _appsflyerSdk;

// static final AppsflyerSdk _appsflyerSdk = AppsflyerSdk(
//   AppsFlyerOptions(
//       afDevKey: 'MpG3nt9mgpZGahre3BaCw6',
//       showDebug: true,
//       timeToWaitForATTUserAuthorization: 15),
// );

  static logButtonClicks(
      {required String buttonName,
      required String screenName,
      required String value}) async {
    Get.log("logButtonClicks - "
        "$buttonName, ${screenName.replaceAll('/', '')}, $value");

    await analytics.logEvent(
      name: 'button_click',
      parameters: {
        'button_name': buttonName,
        'screen_name': screenName.replaceAll('/', ''),
      },
    );
  }

  static late final AppsflyerSdk appsflyerSdk;

  static AppsFlyerOptions options = AppsFlyerOptions(
    afDevKey: F.envVariables.appsFlyerCredentials.appsFlyerKey,
    appId: F.envVariables.appsFlyerCredentials.appID,
    // afDevKey: 'MpG3nt9mgpZGahre3BaCw6',
    timeToWaitForATTUserAuthorization: 50,
    showDebug: F.appFlavor == Flavor.prod ? false : true,
  );

  static initAppsFlyer() async {
    appsflyerSdk = AppsflyerSdk(options);
    DeepLinkService deepLinkService = DeepLinkService();
    deepLinkService.setAppsFlyerSdk(sdk: appsflyerSdk);
    appsflyerSdk.setOneLinkCustomDomain([F.envVariables.customDomainUrl]);

    ///FIrst the callback has to be initialised and
    ///then only the sdk has to be initialised as per documentation
    DeepLinkService.appsflyerSdk.onDeepLinking((dp) {
      deepLinkService.onDeepLinkRecieved(dp);
    });
    await appsflyerSdk.initSdk(
        registerConversionDataCallback: false,
        registerOnDeepLinkingCallback: true,
        registerOnAppOpenAttributionCallback: false);
  }

  static setAppInviteTemplate({
    required String referralCode,
    required Function(AppsflyerSdk appsFlyerSDK, dynamic result) onAppInviteSet,
  }) async {
    try {
      appsflyerSdk.setCustomerUserId(await AmplifyAuth.userID);
      appsflyerSdk.setAppInviteOneLinkID(
        F.envVariables.appsFlyerCredentials.templateId,
        (result) {
          onAppInviteSet(appsflyerSdk, result);
        },
      );
    } catch (e) {
      rethrow;
    }
  }

  static logAppsFlyerEvent({required String eventName}) async {
    AuthUser user = await Amplify.Auth.getCurrentUser();
    String subId = user.userId;
    appsflyerSdk.setCustomerUserId(subId);
    appsflyerSdk.waitForCustomerUserId(true);
    bool? value = await appsflyerSdk.logEvent(eventName, {});
    if (value != null) Get.log("appsflyer log - $eventName : value - $value");
  }

  static logReferralLink({required String deepLink}) async {
    Get.log("deepLink - $deepLink");

    await analytics.logEvent(name: 'referral_link', parameters: {
      'deep_link': deepLink,
    });
  }

  static logWithoutReferral() async {
    await analytics.logEvent(name: 'without_referral');
  }

  static logAppOpen() async {
    await analytics.logAppOpen();
  }

  static logSignUp(String signUpMethod) async {
    Get.log("logSignUp - $signUpMethod");
    await analytics.logSignUp(signUpMethod: signUpMethod);
  }

  static logSetUserId() async {
    await analytics.setUserId(id: await AmplifyAuth.userID);
  }

  static logLevelStart() async {
    await analytics.logLevelStart(levelName: 'onBoardingFlow');
  }

  static logLevelEnd() async {
    await analytics.logLevelEnd(levelName: 'onBoardingFlow');
  }

  static logOnBoardingFlow(int level, String screenName) async {
    Get.log("logOnBoardingFlow - $level, $screenName");
    await analytics.logLevelUp(level: level, character: screenName);
  }

  static navigationObjectNull(String logic) async {
    await analytics
        .logEvent(name: 'navigation_object_null', parameters: {'logic': logic});
  }

  static logRawSmsApiFailure(Map<String, String> data) async {
    await analytics.logEvent(name: 'raw_sms_failed', parameters: data);
  }

  static logRawSmsFileDeleteFailure(Map<String, String> data) async {
    await analytics.logEvent(
        name: 'raw_sms_file_delete_failed', parameters: data);
  }

  static logRawSmsFetchFailure(Map<String, String> data) async {
    await analytics.logEvent(name: 'raw_sms_fetch_failed', parameters: data);
  }

  static logDeviceDetailsFetchFailure(Map<String, String> data) async {
    await analytics.logEvent(
        name: 'device_details_fetch_failed', parameters: data);
  }

  static logGoogleLocationFetchFailure(Map<String, String> data) async {
    await analytics.logEvent(
        name: 'google_location_fetch_failure', parameters: data);
  }

  static locationDataRetry() async {
    await analytics.logEvent(
      name: 'location_data_retry',
      parameters: {
        'user_id': await AmplifyAuth.userID,
      },
    );
  }

  static locationNotRetrievable() async {
    await analytics.logEvent(
      name: 'location_not_retrievable',
      parameters: {
        'user_id': await AmplifyAuth.userID,
      },
    );
  }

  static trackWebEngageUser(
      {required String userAttributeName, dynamic userAttributeValue}) async {
    Get.log(
        "track userAttribute--> $userAttributeName --- $userAttributeValue");
    if (userAttributeName.isEmpty) userAttributeName = "empty attribute name";

    if (userAttributeValue == null) return;

    try {
      SFMCSdk.setAttribute(userAttributeName, "$userAttributeValue");
      DataCloudService().setUserAttributes(
        attributeName: AppFunctions().camelCase(userAttributeName),
        attributeValue: "$userAttributeValue",
      );
    } catch (e) {
      Get.log("Salesforce user attribute failed - $e");
    }

    WebEngagePlugin.setUserAttribute(userAttributeName, userAttributeValue);
  }

  static trackWebEngageEventWithAttribute(
      {required String eventName, Map<String, dynamic>? attributeName}) async {
    Get.log("track eventAttribute--> $eventName --- $attributeName");
    if (eventName.isNotEmpty) {
      attributeName = await _addLPCToWebEngageEvent(attributeName);
      try {
        CustomEvent event = CustomEvent(
          _addUnderscoreToEventName(eventName),
          attributes: attributeName,
        );
        SFMCSdk.trackEvent(event);
        // DataCloudService().trackEvent(
        //   eventName: eventName,
        //   attributes: attributeName,
        // );
      } catch (e) {
        Get.log("Salesforce event failed - $e");
      }

      WebEngagePlugin.trackEvent(eventName, attributeName);
    }
  }

  static String _addUnderscoreToEventName(String eventName) {
    return eventName.replaceAll(" ", "_");
  }

  static Future<Map<String, dynamic>> _addLPCToWebEngageEvent(
      Map<String, dynamic>? attributeName) async {
    if (attributeName != null) {
      attributeName['lpc'] = await AppAuthProvider.getLpc;
      return attributeName;
    } else {
      return {"lpc": await AppAuthProvider.getLpc};
    }
  }

  static dateTimeNow() {
    final DateTime now = DateTime.now().toUtc();
    final DateFormat formatter = DateFormat("'~t'yyyy-MM-dd'T'HH:mm:ss.SSS'Z'");
    return formatter.format(now);
  }

  static logFirebaseEvents({required String eventName}) async {
    Get.log("event-- $eventName");
    analytics.logEvent(name: eventName);
  }
}
