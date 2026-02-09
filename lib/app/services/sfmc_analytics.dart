import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:privo/app/data/provider/auth_provider.dart';
import 'package:privo/app/mixin/app_analytics_mixin.dart';
import 'package:privo/app/services/data_cloud_service.dart';
import 'package:sfmc/sfmc.dart';

import '../mixin/app_analytics_mixin.dart';

class SFMCAnalytics with AppAnalyticsMixin {
  Future init() async {
    try {
      SFMCSdk.enableLogging();
      SFMCSdk.setPiAnalyticsEnabled(false);
      SFMCSdk.setAnalyticsEnabled(true);
      SFMCSdk.enablePush();
    } catch (e) {
      Get.log("Error while initializing the sfmc sdk $e");
    }
  }

  setContactKey() async {
    String phoneNumber = await AppAuthProvider.phoneNumber;
    String contactKey = await SFMCSdk.getContactKey() ?? "";
    Get.log("phone number = $phoneNumber");
    Get.log("contact key = $contactKey");
    if (phoneNumber.isNotEmpty || contactKey.isEmpty) {
      await SFMCSdk.setContactKey(phoneNumber);
      DataCloudService().login(phoneNumber: phoneNumber);
      trackWebEngageUser(
        userAttributeName: "Phone",
        userAttributeValue: phoneNumber,
      );
      Get.log("contact key set");
    }
  }

  logout() async {
    DataCloudService().logout();
    await SFMCSdk.setContactKey("");
  }

// Future<void> _enablePush() async {
//   bool pushEnabled = await SFMCSdk.isPushEnabled() ?? false;
//   Get.log("push enabled = $pushEnabled");
//   if (!pushEnabled) {
//     PermissionStatus status = await Permission.notification.request();
//     if (status == PermissionStatus.granted) {
//       Get.log("Permission granted");
//       await SFMCSdk.enablePush();
//     }
//   }
// }
}
