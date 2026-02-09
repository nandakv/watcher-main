import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:installed_apps/app_info.dart';
import 'package:installed_apps/installed_apps.dart';
import 'package:get/get.dart';
import 'package:privo/app/api/response_model.dart';
import 'package:privo/app/data/repository/app_parameter_repository.dart';
import 'package:privo/app/data/repository/google_location_repository.dart';
import 'package:privo/app/data/repository/on_boarding_repository/device_detail_repository.dart';
import 'package:privo/app/firebase/analytics.dart';
import 'package:privo/app/models/app_parameter_model.dart';
import 'package:privo/app/models/check_app_form_model.dart';
import 'package:privo/app/utils/error_logger_mixin.dart';
import 'package:another_telephony/telephony.dart';

import '../../data/provider/auth_provider.dart';
import '../../utils/device_details_mixin.dart';

class CustomerDeviceDetailsService
    with ErrorLoggerMixin, AdditionalDeviceDetailsMixin {
  Future postCustomerDeviceDetails({
    ///if you are setting [atDisbursal] to true,
    ///need to pass [locationState] and [locationData]
    bool atDisbursal = false,
    LocationAvailabilityState? locationState,
    String? locationData,
    bool isIncremental = false,
  }) async {
    String ipAddress = "";
    try {
      ipAddress = await AppAuthProvider.getIpAddress;
    } catch (e) {
      logError(
        url: "",
        exception: e.toString(),
        requestBody:
            "Exception occurred while Fetching Customer Device Details",
        responseBody: "",
        statusCode: "",
      );
    }
    try {
      List<AppInfo> apps = await InstalledApps.getInstalledApps(
        true,
        false,
      );
      String userData = await AppAuthProvider.getUserLocationData;
      String userGoogleLocationData =
          await AppAuthProvider.getUserGoogleLocationData;

      Map deviceDetailsMap = {
        'user_location_details': userData.isEmpty ? {} : jsonDecode(userData),
        'google_location_details_ip_enabled': userGoogleLocationData.isEmpty
            ? {}
            : jsonDecode(userGoogleLocationData),
        "user_wifi_details": [],
        "ip_address": ipAddress,
        "device": await getDeviceDetails(),
        "os_version": await getOsVersion(),
        "carrier": await getCarrierDetails(),
        "user_app_details": apps
            .map((e) => {
                  "package": e.packageName,
                  "name_of_the_app": e.name,
                  "version_of_the_app": e.versionName,
                  "system_app_or_not": false,
                  "apk_path": "",
                  "installed_on": e.installedTimestamp,
                  "updated_on": ""
                })
            .toList()
      };
      Get.log("device - $deviceDetailsMap");

      if (atDisbursal) {
        deviceDetailsMap['user_location_details']["availability_flag"] =
            locationState?.index.toString();
      }

      Map body = {
        "customer_device_details": {"json": deviceDetailsMap},
        if (atDisbursal) "stage": "disbursal",
      };

      CheckAppFormModel model =
          await DeviceDetailRepository().postDeviceDetails(
        data: body,
        isIncremental: isIncremental,
      );
      if (model.apiResponse.state != ResponseState.success) {
        logError(
          statusCode: model.apiResponse.statusCode.toString(),
          responseBody: model.apiResponse.apiResponse,
          requestBody: model.apiResponse.requestBody,
          exception: model.apiResponse.exception,
          url: model.apiResponse.url,
        );
      }
    } on Exception catch (e) {
      AppAnalytics.logDeviceDetailsFetchFailure({"exception": "$e"});
      logError(
        url: "",
        exception: e.toString(),
        requestBody:
            "Exception occurred while Fetching Customer Device Details",
        responseBody: "",
        statusCode: "",
      );
    }
  }

// Future postCustomerDeviceDetailsDuringWithdrawal({
//   required LocationAvailabilityState locationState,
//   required String locationData,
// }) async {
//   try {
//     List<Application> apps =
//         await DeviceApps.getInstalledApplications(includeSystemApps: false);
//
//     Map deviceDetailsMap = {
//       "user_location_details":
//           locationData.isEmpty ? {} : jsonDecode(locationData),
//       "user_wifi_details": [],
//       "ip_address": await getIPv4(),
//       "device": await getDeviceDetails(),
//       "os_version": await getOsVersion(),
//       "carrier": await getCarrierDetails(),
//       "user_app_details": apps
//           .map((e) => {
//                 "package": e.packageName,
//                 "name_of_the_app": e.appName,
//                 "version_of_the_app": e.versionName,
//                 "system_app_or_not": false,
//                 "apk_path": e.apkFilePath,
//                 "installed_on": e.installTimeMillis,
//                 "updated_on": e.updateTimeMillis
//               })
//           .toList()
//     };
//
//     deviceDetailsMap['user_location_details']["availability_flag"] =
//         locationState.index.toString();
//
//     Get.log("device details (withdrawal)- $deviceDetailsMap");
//
//     Map body = {
//       "customer_device_details": {"json": deviceDetailsMap},
//       "stage": "disbursal",
//     };
//
//     CheckAppFormModel model =
//         await DeviceDetailRepository().postDeviceDetails(
//       data: body,
//     );
//     if (model.apiResponse.state != ResponseState.success) {
//       logError(
//         statusCode: model.apiResponse.statusCode.toString(),
//         responseBody: model.apiResponse.apiResponse,
//         requestBody: model.apiResponse.requestBody,
//         exception: model.apiResponse.exception,
//         url: model.apiResponse.url,
//       );
//     }
//   } on Exception catch (e) {
//     AppAnalytics.logDeviceDetailsFetchFailure({"exception": "$e"});
//     logError(
//       url: "",
//       exception: e.toString(),
//       requestBody:
//           "Exception occurred while Fetching Customer Device Details",
//       responseBody: "",
//       statusCode: "",
//     );
//   }
// }
}
