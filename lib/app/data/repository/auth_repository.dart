import 'package:package_info_plus/package_info_plus.dart';
import 'package:privo/app/api/http_client.dart';
import 'package:privo/flavors.dart';
import 'package:get/get.dart';
import '../../amplify/models/user_check_model.dart';
import '../../amplify/models/otp_response_model.dart';
import '../../api/response_model.dart';

class AuthRepository {
  static String get _baseURL {
    return "${F.envVariables.privoBaseURL}/api/v1/login";
  }

  static Future<UserCheckModel> checkUser({required String username}) async {
    Map<String, dynamic> body = {
      "username": username,
    };

    try {
      PackageInfo packageInfo = await PackageInfo.fromPlatform();
      body.addAll({
        "buildNumber": int.parse(packageInfo.buildNumber),
      });
    } on Exception catch (e) {
      return userCheckModelFromJson(
          ApiResponse(state: ResponseState.failure, apiResponse: ""));
    }

    ApiResponse apiResponse = await HttpClient.post(
      url: "$_baseURL/checkUser",
      body: body,
    );

    return userCheckModelFromJson(apiResponse);
  }

  static Future<OTPResponseModel> sendOTP(
      {required Map<String, String> body}) async {
    ApiResponse apiResponse = await HttpClient.post(
        url: "$_baseURL/updatePhone", body: body, authType: AuthType.token);

    return otpResponseModelFromJson(apiResponse);
  }

  static Future<OTPResponseModel> verifyOTP(
      {required Map<String, String> body}) async {
    ApiResponse apiResponse = await HttpClient.post(
        url: "$_baseURL/verifyPhone", body: body, authType: AuthType.token);

    return otpResponseModelFromJson(apiResponse);
  }
}
