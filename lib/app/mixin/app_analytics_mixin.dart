import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:appsflyer_sdk/appsflyer_sdk.dart';
import 'package:get/get.dart';
import 'package:privo/app/firebase/analytics.dart';
import 'package:privo/app/services/lpc_service.dart';
import 'package:privo/app/utils/app_functions.dart';
import 'package:sfmc/sfmc.dart';
import 'package:webengage_flutter/webengage_flutter.dart';

import '../../flavors.dart';
import '../data/provider/auth_provider.dart';
import '../services/data_cloud_service.dart';
import '../services/deep_link_service/deep_link_service.dart';

class AppAnalyticsMixin {
  trackWebEngageUser(
      {required String userAttributeName, dynamic userAttributeValue}) async {
    Get.log(
        "track userAttribute--> $userAttributeName --- $userAttributeValue");
    if (userAttributeValue == null) return;
    if (userAttributeName.isEmpty) userAttributeName = "empty attribute name";
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

  trackWebEngageEventWithAttribute(
      {required String eventName, Map<String, dynamic>? attributeName}) async {
    Get.log("track eventAttribute--> $eventName --- $attributeName");
    if (eventName.isNotEmpty) {
      attributeName = await _addLPCToWebEngageEvent(attributeName);

      try {
        CustomEvent event = CustomEvent(_addUnderscoreToEventName(eventName),
            attributes: attributeName);
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

  String _addUnderscoreToEventName(String eventName) {
    return eventName.replaceAll(" ", "_");
  }

  Future<Map<String, dynamic>> _addLPCToWebEngageEvent(
      Map<String, dynamic>? attributeName) async {
    Map<String, dynamic> attributes = attributeName ?? {};

    final activeCard = LPCService.instance.activeCard;
    if (activeCard != null) {
      attributes['lpc'] = activeCard.loanProductCode;

      if (LPCService.instance.isLpcCardTopUp ||
          LPCService.instance.isLpcCardLowAndGrow) {
        attributes['type'] = activeCard.lpcCardType.name;
      }
    }

    return attributes;
  }

  logAppsFlyerEvent({required String eventName}) {
    AppAnalytics.logAppsFlyerEvent(eventName: eventName);
  }
}
