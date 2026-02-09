import 'package:privo/app/amplify/auth/amplify_auth.dart';
import 'package:privo/app/data/provider/auth_provider.dart';
import 'package:privo/app/models/delete_account_model.dart';
import 'package:privo/app/models/delete_eligible_model.dart';

import '../../api/http_client.dart';
import '../../api/response_model.dart';
import '../../models/faq_model.dart';
import '../../models/faq_url_model.dart';
import 'base_repository.dart';

class HelpAndSupportRepository extends BaseRepository {
  ///Function to get the faq url
  Future<FAQUrlModel> getFaqUrl(String lpc) async {
    ApiResponse apiResponse = await HttpClient.get(
      url: "$aquManBaseUrl/FAQ/getFileByLpc/$lpc",
    );
    return faqUrlModelFromJson(apiResponse);
  }

  Future<DeleteEligibleModel> checkIfEligibleForDeletion() async {
    ApiResponse apiResponse = await HttpClient.get(
        url:
            "$aquManBaseUrl/account/${await AppAuthProvider.phoneNumber}/deleteEligible");
    return deleteEligibleModelFromJson(apiResponse);
  }

  Future<DeleteAccountModel> postUserDeletionRequest() async {
    ApiResponse apiResponse = await HttpClient.post(
        url:
            "$aquManBaseUrl/account/${await AppAuthProvider.phoneNumber}/deleteAccount",
        body: {'sub_id': await AmplifyAuth.userID});
    return deleteAccountModelFromJson(apiResponse);
  }

  Future<FAQModel> getFaqs(String url) async {
    ApiResponse apiResponse = await HttpClient.get(
      url: url,
    );
    return faqModelFromJson(apiResponse);
  }
}
