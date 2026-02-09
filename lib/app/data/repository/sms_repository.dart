import 'package:privo/app/amplify/auth/amplify_auth.dart';
import 'package:privo/app/api/http_client.dart';
import 'package:privo/app/api/response_model.dart';
import 'package:privo/app/data/provider/auth_provider.dart';
import 'package:privo/app/data/repository/base_repository.dart';
import 'package:privo/app/models/sms_model.dart';

class SMSRepository extends BaseRepository {
  Future<SMSModel> postSMSData(Map<String, dynamic> smsData) async {
    ApiResponse apiResponse = await HttpClient.post(
      url:
          '$baseUrl/rawsmspush?inputType=raw_sms&subId=${await AmplifyAuth.userID}',
      body: smsData,
    );
    return SMSModel.fromJson(apiResponse);
  }

  Future<SMSModel> getSMSDataStatus() async {
    ApiResponse apiResponse = await HttpClient.get(
      url: '$morpheusBaseUrl/home_page/userTrackingData',
    );
    return SMSModel.fromJson(apiResponse);
  }
}
