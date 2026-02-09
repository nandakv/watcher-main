import 'dart:convert';
import 'dart:io';

import 'package:get/get.dart';
import 'package:privo/app/api/api_error_mixin.dart';
import 'package:privo/app/api/response_model.dart';
import 'package:privo/app/data/repository/on_boarding_repository/kyc_repository.dart';
import 'package:privo/app/data/repository/on_boarding_repository/sequence_engine_repository.dart';
import 'package:privo/app/models/check_app_form_model.dart';
import 'package:privo/app/modules/on_boarding/on_boarding_logic.dart';

import '../../../../flavors.dart';
import '../../../firebase/analytics.dart';
import '../../../utils/app_functions.dart';

class OnBoardingMixin {
  onNavigationDetailsNull(String logicName) async {
    await ApiErrorMixin().handleAPIError(
        ApiResponse(
          state: ResponseState.failure,
          apiResponse: "",
          exception: "GetX Navigation object was null in $logicName",
        ),
        screenName: logicName,
        retry: () => Get.back());
    await AppAnalytics.navigationObjectNull(logicName);
  }

  ///for aadhaar xml, request body has to be changed
  ///the line1 inside the address object
  ///should be created with the address object from the sdk response
  String generateLineOne(Map<dynamic, dynamic> resultBody) {
    String address = resultBody['address'] ?? "";
    String landmark = resultBody['address_landmark'] ?? "";
    String state = resultBody['address_state'] ?? "";
    String city = resultBody['address_vtc'] ?? "";
    String pincode = resultBody['address_pc'] ?? "";

    if (landmark.isNotEmpty) {
      address = address.replaceAll('$landmark,', '');
    }

    if (state.isNotEmpty) {
      address = address.replaceAll('$state,', '');
    }

    if (city.isNotEmpty) {
      address = address.replaceAll('$city,', '');
    }

    if (pincode.isNotEmpty) {
      address = address.replaceAll('$pincode,', '');
    }

    if (pincode.isNotEmpty) {
      address = address.replaceAll(pincode, '');
    }

    ///this is to trim the extra spaces after replacing
    address = address
        .split(',')
        .map((e) => e.trim())
        .toList()
        .join(', ')
        .replaceAll(', India', '');

    return address;
  }

  ///when the selfie sdk is a success
  ///moves to the processing screen
  ///gets the image from selfie sdk and image from gallery
  ///hyperverge sdk checks if two face are matching
  ///and proceeds to success or failure screen accordingly to the response
  // Future<bool> getLiveNessScore(
  //     {required String documentImage,
  //     required String liveImage,
  //     required String url}) async {
  //   // Define the OCR endpoint
  //   String endPoint = "https://ind-faceid.hyperverge.co/v1/photo/verifyPair";
  //
  //   // Get image URI from document capture results
  //   String documentImageUri = documentImage;
  //
  //   // Get image URI from face capture results
  //   String faceImageUri = liveImage;
  //
  //   // Create API request param
  //   Map params = {'selfie': documentImage, 'selfie2': liveImage};
  //
  //   Get.log("getLiveNessScore - params = $params");
  //
  //   // Create API request headers
  //   ///production
  //   // Map headers = {'appId': '99e0d3', 'appKey': '8ab45f8a528b2010a1d4'};
  //
  //   ///testing
  //   Map headers = {
  //     'appId': F.envVariables.hypervergeKeys.appId,
  //     'appKey': F.envVariables.hypervergeKeys.appKey
  //   };
  //
  //   Map faceMatchAPICallResult =
  //       await HVNetworkHelper.networkHelperMakeFaceMatchCall(
  //           endPoint, faceImageUri, documentImageUri, params, headers);
  //
  //   await AppFunctions().postUserDataToServer(
  //     thirdPartyName: "FaceMatch",
  //     requestJson: {
  //       "AppId": F.envVariables.hypervergeKeys.appId,
  //       "AppKey": F.envVariables.hypervergeKeys.appKey
  //     },
  //     responseJson: faceMatchAPICallResult,
  //   );
  //
  //   Get.log("faceMatchAPI = $faceMatchAPICallResult");
  //
  //   Map faceResultObj = faceMatchAPICallResult["resultObj"];
  //
  //   List<int> imageBytes = await File(liveImage).readAsBytes();
  //   String base64Image = base64Encode(imageBytes);
  //
  //   Map<String, dynamic> body = {
  //     "selfie": base64Image,
  //     "result": getHyperVergeResultMap(faceMatchAPICallResult),
  //   };
  //
  //   CheckAppFormModel model =
  //       await KYCRepository().uploadSelfie(data: body, url: url);
  //
  //   switch (model.apiResponse.state) {
  //     case ResponseState.success:
  //       return faceResultObj.isNotEmpty &&
  //           faceResultObj["result"]["match"] == "yes" &&
  //           faceResultObj["result"]['to-be-reviewed'] == "no";
  //     default:
  //       ApiErrorMixin().handleAPIError(model.apiResponse, screenName: "selfie");
  //       return false;
  //   }
  // }

  Map getHyperVergeResultMap(Map faceMatchMap) {
    if (faceMatchMap['resultObj'].isNotEmpty) {
      Map finalMap = {};

      var resultObjMap = faceMatchMap["resultObj"];

      var encodedApiResult = jsonEncode(resultObjMap['apiResult']);

      ///The hyperverge response map added some escape character's
      ///To remove we have to do double decode
      var decodedApiResult = jsonDecode(jsonDecode(encodedApiResult));

      var encodedApiHeaders = jsonEncode(resultObjMap['apiHeaders']);
      var decodedApiHeaders = jsonDecode(jsonDecode(encodedApiHeaders));

      finalMap.addAll(
        {
          "status": resultObjMap['status'],
          "statusCode": resultObjMap["statusCode"],
          "result": resultObjMap["result"],
          "apiResult": decodedApiResult,
          "imageUri": resultObjMap['imageUri'],
          "apiHeaders": decodedApiHeaders
        },
      );

      faceMatchMap.remove("resultObj");
      faceMatchMap["resultObj"] = finalMap;

      return faceMatchMap;
    }

    return faceMatchMap;
  }
}
