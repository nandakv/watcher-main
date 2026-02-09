import 'package:intl/intl.dart';
import 'package:privo/app/api/http_client.dart';
import 'package:privo/app/api/response_model.dart';
import 'package:privo/app/models/aadhaar_data_model.dart';
import 'package:privo/app/models/ckyc_response_model.dart';
import 'package:privo/app/models/vkyc_initiate_model.dart';
import 'package:privo/app/services/platform_services/platform_services.dart';
import 'package:privo/app/utils/app_functions.dart';
import 'package:privo/flavors.dart';

import '../../../models/aadhaar_otp_model.dart';
import '../../../models/check_app_form_model.dart';
import '../../../models/digio_aadhaar_response_model.dart';
import '../../../models/digio_get_aadhaar_xml_model.dart';
import '../../../models/digio_id_model.dart';
import '../base_repository.dart';

class KYCRepository extends BaseRepository {
  Future<CkycResponseModel> getCKYCDetails() async {
    ApiResponse apiResponse =
        await HttpClient.get(url: "$baseUrl/appForm/$appFormId/validateCkyc");
    return ckycResponseModelFromJson(apiResponse);
  }

  Future<CheckAppFormModel> postKycDetails(
      {required Map<String, dynamic> resultBody, required String url}) async {
    ApiResponse apiResponse = await HttpClient.put(
      url: "$morpheusBaseUrl/appForm/$appFormId/kyc",
      body: resultBody,
    );
    return checkAppFormModelFromJson(apiResponse);
  }

  Future<AadhaarOTPModel> sendOTP({required Map<String, String> body}) async {
    ApiResponse apiResponse = await HttpClient.post(
      url: "$karzaUrl/aadhaar-xml/otp",
      body: body,
      authType: AuthType.karza,
    );
    return aadhaarOTPModelFromJson(apiResponse);
  }

  Future<AadhaarDataModel> verifyOTP(
      {required Map<String, String> body}) async {
    ApiResponse apiResponse = await HttpClient.post(
      url: "$karzaUrl/aadhaar-xml/file",
      body: body,
      authType: AuthType.karza,
    );
    return aadhaarDataModelFromJson(apiResponse);
  }

  Future<AadhaarDataModel> getAadhaarData(
      {required Map<String, String> body}) async {
    ApiResponse apiResponse = await HttpClient.post(
      url: "$karzaUrl/aadhaar/download",
      body: body,
      authType: AuthType.karza,
    );
    return aadhaarDataModelFromJson(apiResponse);
  }

  Future<CheckAppFormModel> getVKYCStatus({
    required Map<String, dynamic> data,
  }) async {
    ApiResponse apiResponse = await HttpClient.post(
      url: "$baseUrl/api/v1/poll?app_form_id=$appFormId&type=vkyc",
      body: data,
    );
    return checkAppFormModelFromJson(apiResponse);
  }

  Future<VKYCInitiateModel> initiateVKYC() async {
    ApiResponse apiResponse = await HttpClient.post(
      url: "$morpheusBaseUrl/vkyc/initiate",
      body: {
        "appFormId": appFormId,
        "redirectUrl": PrivoPlatform.platformService.getVKYCRedirectURL(),
      },
    );
    return VKYCInitiateModel.decodeResponse(apiResponse);
  }

  Future<CheckAppFormModel> uploadSelfie({
    required Map<String, dynamic> data,
    required String url,
  }) async {
    ApiResponse apiResponse = await HttpClient.post(
      url: url,
      body: data,
    );
    return checkAppFormModelFromJson(apiResponse);
  }

  Future<DigioIDModel> getDigioId(String phoneNumber) async {
    ApiResponse apiResponse = await HttpClient.post(
      url: '$digioURL/client/kyc/v2/request/with_template',
      body: {
        "customer_identifier": "+91$phoneNumber",
        "template_name": F.envVariables.digiLockerCreds.template,
        "notify_customer": false,
        "generate_access_token": true,
        // "phone_number":"+91$phoneNumber"
      },
      authType: AuthType.digio,
    );
    return DigioIDModel.fromJson(apiResponse);
  }

  Future<DigioAadhaarResponseModel> getAadhaarResponse(String kId) async {
    ApiResponse apiResponse = await HttpClient.post(
      url: '$digioURL/client/kyc/v2/$kId/response',
      authType: AuthType.digio,
    );
    return DigioAadhaarResponseModel.fromJson(apiResponse);
  }

  Future<DigioAadhaarXMLModel> getAadhaarXML(String executionId) async {
    ApiResponse apiResponse = await HttpClient.get(
      url:
          '$digioURL/client/kyc/v2/media/$executionId?doc_type=AADHAAR&xml=true',
      authType: AuthType.digio,
    );
    return DigioAadhaarXMLModel.fromJson(apiResponse);
  }

  Future<ApiResponse> storeAadharConsent() async {
    return await HttpClient.put(
      url: "$morpheusBaseUrl/appForm/$appFormId/update",
      body: {
        "consent": {
          "aadhaar": {"UIDAI": "yes", "Digilocker": "yes"}
        },
      },
    );
  }

  Future<ApiResponse> storeVKYCConsent() async {
    return await HttpClient.put(
      url: "$morpheusBaseUrl/appForm/$appFormId/update",
      body: {
        "consent": {
          "videokyc": {
            "consent": "Yes",
            "consentCreatedAt": AppFunctions().getCurrentDateTimeWithTimeZone(),
          }
        }
      },
    );
  }
}
