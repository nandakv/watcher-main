import 'dart:async';

import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:privo/app/models/security_check/security_check_model.dart';
import 'package:privo/app/services/preprocessor_service/sms_service.dart';
import 'package:privo/app/utils/error_logger_mixin.dart';
import 'package:privo/app/utils/strings.dart';
import 'package:privo/flavors.dart';

import '../firebase/analytics.dart';

class NativeFunctions with ErrorLoggerMixin {
  static String FACEBOOK_APP_EVENT_METHOD_NAME = 'log_facebook_app_event';
  static String INIT_FACEBOOK_SDK = 'facebook_sdk_init';
  static const platform = MethodChannel("privo");
  static const smsEventChannel = EventChannel("sms_event_channel");
  static const reversePennyDropEventChannel =
      EventChannel("reverse_penny_drop_channel");
  static const locationEventChannel = EventChannel("location_event_channel");

  Future<bool> openWebView(
      {required String url, required String callBackUrl}) async {
    try {
      Get.log("opening emandate webview : url $url, callBack $callBackUrl");
      bool? result = await platform.invokeMethod(
          'e_mandate_web_view', {'url': url, 'callback_url': callBackUrl});
      Get.log("emandate result = $result");
      return result ?? false;
    } catch (e) {
      Get.log("Webview native ${e.toString()}");
      return false;
    }
  }

  Future<bool> isDeviceRooted() async {
    return await platform.invokeMethod('root_checker');
  }

  Future<bool> isEmulator() async {
    return await platform.invokeMethod('emulator_check');
  }

  Future<SecurityCheckModel?> checkSecurityIssues(
      {required Map<String, bool> securityCheckList}) async {
    try {
      var res = await platform
          .invokeMethod("security_check", {"checklist_map": securityCheckList});
      if (res != null && res is Map) {
        if (res['isError'] == true) {
          _logError("Received error from native", "${res['errorMessage']}");
          return null;
        }
        return SecurityCheckModel.fromJson(res);
      } else {
        _logError("Error While checking security issues from native",
            "Received null response from native");
        return null;
      }
    } catch (e) {
      Get.log("Error in checkSecurityIssues: $e");
      _logError("Error while checking security issues from native", "$e");

      return null;
    }
  }

  _logError(String errorDetails, String exception) {
    logError(
      statusCode: "",
      responseBody: errorDetails,
      requestBody: "",
      exception: exception,
      url: "",
    );
  }

  Future<void> enableScreenProtection({required bool enable}) async {
    try {
      await platform.invokeMethod(
        'enable_screen_protection',
        {
          'enable_screen_protection': enable,
        },
      );
    } on PlatformException catch (e) {
      Get.log("enable_screen_protection Exception - $e");
    }
  }

  Future<List<dynamic>> fetchSms() async {
    try {
      var smsData = await platform.invokeListMethod('fetch_sms');
      if (smsData != null) {
        return smsData;
      } else {
        return [];
      }
    } on PlatformException catch (e) {
      Get.log("fetchSs Exception - $e");
      return [];
    }
  }

  late StreamSubscription _smsSubscription;
  late StreamSubscription _upiIntentSubscription;

  Future startLocationFetch({bool fetchLastKnownLocation = false}) async {
    try {
      return await platform.invokeMapMethod('start_location_fetch', {
        'fetch_last_known_location': fetchLastKnownLocation,
      });
    } catch (e) {
      Get.log("An exception occured ${e.toString()}");
    }
  }

  Future checkIfLocationEnabled() async {
    try {
      return await platform.invokeMapMethod('check_if_location_enabled');
    } catch (e) {
      Get.log("An exception occured ${e.toString()}");
    }
  }

  Future<List> getAllUPIAppsList({required String intentUrl}) async {
    try {
      Map? nativeResponse = await platform.invokeMapMethod(
        'get_all_upi_apps_list',
        {
          "intentURL": intentUrl,
        },
      );
      Get.log(nativeResponse.toString());
      if (nativeResponse != null && nativeResponse.containsKey("dataList")) {
        List rawAppsList = nativeResponse['dataList'];
        return rawAppsList;
      }
      return [];
    } catch (e) {
      logError(
        statusCode: "",
        responseBody: "Error While Fetching list of UPI apps from native",
        requestBody: "",
        exception: "$e",
        url: "",
      );

      Get.log("An exception occured ${e.toString()}");
      return [];
    }
  }

  Future startReversePennyDrop(
      {required String intentUrl, required String packageName}) async {
    // _startListeningToUPIIntentStatus();

    try {
      Map<String, dynamic>? details = await platform.invokeMapMethod(
        'start_reverse_penny_drop',
        {
          "intentURL": intentUrl,
          "packageName": packageName,
        },
      );
      Get.log(details.toString());

      if (details != null) {
        if (details['isError']) {
          // _upiIntentSubscription.cancel();
          logError(
            statusCode: "",
            responseBody: "Error While starting reverse penny drop from native",
            requestBody: "",
            exception: "${details['errorMessage']}",
            url: "",
          );
        }
      }
    } catch (e) {
      //  _upiIntentSubscription.cancel();
      logError(
        statusCode: "",
        responseBody: "Error While starting reverse penny drop from native",
        requestBody: "",
        exception: "$e",
        url: "",
      );
      Get.log("An exception occured ${e.toString()}");
    }
  }

  Future startSmsFetch(
      {String? fromDateTime, required bool isAPITrigger}) async {
    _startListeningToSMSThreadStatus(
      fromDateTime: fromDateTime,
      isAPITrigger: isAPITrigger,
    );
    try {
      var startFetchSMSResult = await platform.invokeMapMethod(
        'new_start_sms_fetch',
        {
          'fileName':
              rawSMSFileName + _computeRawSMSDataFileExtension(isAPITrigger),
          'from_date_time': fromDateTime
        },
      );
      if (startFetchSMSResult != null) {
        Get.log("sms error - ${startFetchSMSResult['isError']}");
        Get.log("sms error message = ${startFetchSMSResult['errorMessage']}");
        if (startFetchSMSResult['isError']) {
          AppAnalytics.logRawSmsFetchFailure(
              {"errorMessage": startFetchSMSResult['errorMessage']});
          _retrySMS(
            fromDateTime: fromDateTime,
            isAPITrigger: isAPITrigger,
          );
          logError(
            statusCode: "",
            responseBody: "Error While Fetching SMS from native",
            requestBody: "",
            exception: "${startFetchSMSResult['errorMessage']}",
            url: "",
          );
        }
      }
    } on PlatformException catch (e) {
      Get.log("fetchSs Exception - $e");
      AppAnalytics.logRawSmsFetchFailure(
          {"errorMessage": e.message ?? "Error in Method Channel"});
      _retrySMS(
        fromDateTime: fromDateTime,
        isAPITrigger: isAPITrigger,
      );
      logError(
        exception: "$e",
        requestBody: "",
        responseBody: "Platform Exception while sms fetch start method call",
        statusCode: "",
        url: "",
      );
    }
  }

  Future<Map<String, String>> getCarrierDetails() async {
    try {
      Map<String, String>? carrierDetails = await platform
          .invokeMapMethod<String, String>('fetch_carrier_details');

      if (carrierDetails != null) {
        if (carrierDetails["isError"] != null &&
            carrierDetails["isError"] == "true") {
          logError(
            exception: carrierDetails['errorMessage'],
            requestBody: "",
            responseBody: "Platform Exception during carrier details",
            statusCode: "",
            url: "",
          );
        }
      }

      return carrierDetails ?? {};
    } catch (e) {
      Get.log("An exception occured ${e.toString()}");
      logError(
        exception: "$e",
        requestBody: "",
        responseBody: "Platform Exception during carrier details",
        statusCode: "",
        url: "",
      );
      return {};
    }
  }

  _startListeningToUPIIntentStatus() {
    _upiIntentSubscription =
        reversePennyDropEventChannel.receiveBroadcastStream().listen(
      (events) async {
        Get.log("UPI events - $events");
      },
    );
  }

  _startListeningToSMSThreadStatus(
      {String? fromDateTime, required bool isAPITrigger}) {
    _smsSubscription = smsEventChannel.receiveBroadcastStream().listen(
      (events) async {
        if (events['isError']) {
          _retrySMS(
            fromDateTime: fromDateTime,
            isAPITrigger: isAPITrigger,
          );
          AppAnalytics.logRawSmsFetchFailure(
              {"errorMessage": events['errorMessage']});
          logError(
            statusCode: "",
            responseBody:
                "error while listening to native sms in event channel listen",
            requestBody: "",
            exception: "${events['errorMessage']}",
            url: "",
          );
        } else {
          _smsSubscription.cancel();
          SmsService().sendSMSDataToS3(
            fromDateTime: fromDateTime,
            isAPITrigger: isAPITrigger,
          );
        }
      },
    );
  }

  Stream<dynamic> getLocationStream() {
    return locationEventChannel.receiveBroadcastStream();
  }

  final int _maxRetryCountForSMS = 5;
  int _smsRetryCount = 0;

  _retrySMS({String? fromDateTime, required bool isAPITrigger}) {
    if (_smsRetryCount <= _maxRetryCountForSMS) {
      _smsRetryCount++;
      _smsSubscription.cancel();
      startSmsFetch(
        fromDateTime: fromDateTime,
        isAPITrigger: isAPITrigger,
      );
    } else {
      SmsService().sendEmptyDataForSMSFailure(isAPITriggered: isAPITrigger);
    }
  }

  Future<Map<String, String>?> startKarzaAadhaarSDK() async {
    try {
      return await platform.invokeMapMethod(
        'start_karza_aadhaar_sdk',
        {
          'url': F.envVariables.karzaKeys.url,
          'karza_key': F.envVariables.karzaKeys.karzaKey,
          'environment': F.envVariables.karzaKeys.environment
        },
      );
    } on PlatformException catch (e) {
      print("sdk execption = $e");
      return null;
    }
  }

  Future<bool> initFacebookSDK() async {
    try {
      return await platform.invokeMethod(INIT_FACEBOOK_SDK);
    } on PlatformException catch (e) {
      Get.log("initFacebookSDK Exception - $e");
      return false;
    }
  }

  Future openCustomTab({required String customTabURL}) async {
    await platform.invokeMethod('open_custom_tab', {
      'custom_tab_url': customTabURL,
    });
  }

  String _computeRawSMSDataFileExtension(bool isAPITrigger) {
    if (isAPITrigger) return ".txt";
    return ".json";
  }

// Future<bool> logFacebookAppEvent(
//     {required String eventName, required String eventValue}) async {
//   try {
//     return await platform.invokeMethod(
//       FACEBOOK_APP_EVENT_METHOD_NAME,
//       {"event_name": eventName, "event_value": eventValue},
//     );
//   } on PlatformException catch (e) {
//     return false;
//   }
// }
}
