import '../../api/http_client.dart';
import '../../api/response_model.dart';
import '../../models/loan_cancellation_details_model.dart';
import 'base_repository.dart';

class LoanCancellationRepository extends BaseRepository {
  Future<LoanCancellationDetailsModel> getLoanCancellationDetails(
      {required String loanId}) async {
    ApiResponse apiResponse = await HttpClient.get(
      url: "$aquManBaseUrl/loanCancellation/$loanId",
    );
    return loanCancellationDetailsModelFromJson(apiResponse);
  }
}
