import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:privo/app/data/repository/base_repository.dart';
import 'package:privo/app/models/check_app_form_model.dart';
import 'package:privo/app/models/version_number_response_model.dart';

import '../../../api/http_client.dart';
import '../../../api/response_model.dart';

class PersonalDetailRepository extends BaseRepository {
  Future<VersionNumberResponseModel> updateAppVersionNumber() async {
    var versionNumber = await PackageInfo.fromPlatform();
    var fcmToken = await FirebaseMessaging.instance.getToken();
    ApiResponse apiResponse = await HttpClient.post(
      url: "$baseUrl/appForm/$appFormId/versionNumber",
      body: {
        "versionNumber":
            "${versionNumber.version} + ${versionNumber.buildNumber}",
        "fcmToken": "$fcmToken"
      },
    );
    return versionNumberResponseModelFromJson(apiResponse);
  }

  Future<CheckAppFormModel> postUserDetailsToAppForm(
      {required Map data, required String url}) async {
    ApiResponse apiResponse = await HttpClient.post(
      url: url,
      body: data,
    );
    return checkAppFormModelFromJson(apiResponse);
  }

  Future<ApiResponse> postSmsData(Map data) async {
    Get.log("Raw sms body $data");

    ApiResponse apiResponse = await HttpClient.post(
      url: "$morpheusBaseUrl/appForm/$appFormId/preProcessor?inputType=raw_sms",
      body: data,
    );
    return apiResponse;
  }
}
