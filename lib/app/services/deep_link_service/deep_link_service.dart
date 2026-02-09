import 'dart:convert';

import 'package:amplify_core/amplify_core.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:appsflyer_sdk/appsflyer_sdk.dart';
import 'package:get/get.dart';
import 'package:privo/app/data/provider/auth_provider.dart';
import 'package:privo/flavors.dart';

class DeepLinkService {
  static final DeepLinkService _deepLinkService = DeepLinkService._internal();
  static late AppsflyerSdk appsflyerSdk;
  static String deepLinkValue = "";
  static Map<String, dynamic> deepLinkData = {};
  static String blogId = "";

  factory DeepLinkService() {
    return _deepLinkService;
  }

  DeepLinkService._internal();

  setAppsFlyerSdk({required AppsflyerSdk sdk}) {
    appsflyerSdk = sdk;
  }

  onDeepLinkRecieved(DeepLinkResult dp) {
    Get.log("Got Deeplink ");
    switch (dp.status) {
      case Status.FOUND:
        _onDeepLinkFound(dp);
        break;
      case Status.NOT_FOUND:
        Get.log("deep link not found");
        break;
      case Status.ERROR:
        Get.log("deep link error: ${dp.error}");
        break;
      case Status.PARSE_ERROR:
        Get.log("deep link status parsing error");
        break;
      default:
        break;
    }
  }

   fetchNestedDeepLinkValue(String key) {
    if (deepLinkData['deepLink'] != null &&
        deepLinkData['deepLink'][key] != null) {
      return deepLinkData['deepLink'][key];
    } else {
      return "";
    }
  }

  _onDeepLinkFound(DeepLinkResult dp) async {
    deepLinkData = dp.toJson();
    if (dp.deepLink != null) {
      blogId = dp.deepLink!.clickEvent['deep_link_sub1'] ?? "";
      deepLinkValue = dp.deepLink!.deepLinkValue ?? "None";
      await AppAuthProvider.setUtmDeepLinkData(
          jsonEncode(dp.deepLink!.clickEvent));
    }
    Get.log("${dp.deepLink?.toString()} value");
    Get.log("deep link value: ${dp.deepLink?.deepLinkValue}");
    Get.log("blogId: ${dp.deepLink?.clickEvent['deep_link_sub1']}");
    Get.log("Hash of internal class ${_deepLinkService.hashCode}");
    Get.log("Deep link value set $deepLinkValue");
  }

  static void onInstallConversionData(dynamic res) {
    Get.log("Install conversion data: " + res.toString());
  }

  static void clearDeepLink() {
    deepLinkValue = "";
    deepLinkData = {};
    Get.log("Cleared deeplink value $deepLinkValue");
  }
}
