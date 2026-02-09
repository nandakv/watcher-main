import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:privo/app/api/http_client.dart';
import 'package:privo/app/api/response_model.dart';
import 'package:privo/app/data/provider/auth_provider.dart';
import 'package:privo/app/data/repository/base_repository.dart';
import 'package:privo/app/modules/on_boarding/mixins/app_form_mixin.dart';
import 'package:privo/flavors.dart';
import '../../models/whatsapp_opt_in_model.dart';

class AppPermissionRepository extends BaseRepository {
  Future<WhatsappOptInModel> getWhatsappCredentials() async {
    String phoneNumber = await AppAuthProvider.phoneNumber;
    Map<String, String> getUserPass = {
      "userId": F.envVariables.gupShupCredentials.userId,
      "password": F.envVariables.gupShupCredentials.password,
      "url": F.envVariables.gupShupCredentials.url
    };
    ApiResponse apiResponse = await HttpClient.get(
        url:
            "${getUserPass['url']}&userid=${getUserPass['userId']}&password=${getUserPass['password']}&phone_number=$phoneNumber&v=1.1&auth_scheme=plain&channel=WHATSAPP",
        authType: AuthType.smsgupshup);
    return WhatsappOptInModel.fromJson(apiResponse);
  }

  Future onAppPermissions(String permisssionName) async {
    AuthUser user = await Amplify.Auth.getCurrentUser();
    String subId = user.userId;
    Map<String, dynamic> body = {
      permisssionName: "Yes",
      "type": "appPermission"
    };

    return await HttpClient.post(
        url: "$baseUrl/appForm/$subId/consent", body: body);
  }

  Future postCommunicationConsent() async {
    AuthUser user = await Amplify.Auth.getCurrentUser();
    String subId = user.userId;
    Map<String, dynamic> body = {"type": "communication"};

    return await HttpClient.post(
        url: "$baseUrl/appForm/$subId/consent", body: body);
  }

  ///pass device details at the time of sign up.
  Future<ApiResponse> postDeviceInfo(Map<dynamic, dynamic> body) async {
    return await HttpClient.post(
        url: "$morpheusBaseUrl/userTracking/deviceDetails",
        body: body,
        authType: AuthType.token);
  }
}
