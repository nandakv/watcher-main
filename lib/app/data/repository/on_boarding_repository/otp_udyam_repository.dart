import 'package:privo/app/models/udyam_model/otp_udyam_details_model.dart';

import '../../../api/http_client.dart';
import '../../../api/response_model.dart';
import '../../../models/check_app_form_model.dart';
import '../../../models/udyam_model/otp_udyam_model.dart';
import '../base_repository.dart';

class OTPUdyamRepository extends BaseRepository {
  Future<OTPUdyamDetailsModel> getUdyamNumber() async {
    ApiResponse apiResponse = await HttpClient.get(
      url: "$morpheusBaseUrl/appForm/$appFormId/udyam",
    );
    return otpUdyamDetailsModelFromJson(apiResponse);
  }

  Future<OTPUdyamModel> getUdyamOtp(Map<dynamic, dynamic> body) async {
    ApiResponse apiResponse = await HttpClient.post(
        url: "$morpheusBaseUrl/appForm/$appFormId/udyam/otp", body: body);
    return otpUdyamModelFromJson(apiResponse);
  }

  Future<CheckAppFormModel> getUdyamDoc(Map<dynamic, dynamic> body) async {
    ApiResponse apiResponse = await HttpClient.post(
        url: "$morpheusBaseUrl/appForm/$appFormId/udyam/doc", body: body);
    return checkAppFormModelFromJson(apiResponse);
  }
}
