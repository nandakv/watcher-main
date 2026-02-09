import 'package:privo/app/api/http_client.dart';
import 'package:privo/app/api/response_model.dart';
import 'package:privo/app/data/repository/base_repository.dart';
import 'package:privo/app/models/referral_submission_response_model.dart';
import 'package:privo/app/models/referral_data_model.dart';

class ReferralRepository with BaseRepository{
  Future<ReferralDataModel> getUserReferralData() async {
    ApiResponse apiResponse = await HttpClient.get(
        url: "$magnusBaseUrl/referral/getReferralData",
        authType: AuthType.token);
    return referralDataModelFromJson(apiResponse);
  }


  Future<ReferralSubmissionResponseModel> submitReferralData(Map<String,dynamic> body) async {
    ApiResponse apiResponse = await HttpClient.post(
        url: "$magnusBaseUrl/referral/submitReferralData",
        body: body,
        authType: AuthType.token);
    return referralSubmissionResponseModelFromJson(apiResponse);
  }
}