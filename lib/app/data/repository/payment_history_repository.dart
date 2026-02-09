import 'package:privo/app/api/http_client.dart';
import 'package:privo/app/api/response_model.dart';
import 'package:privo/app/data/repository/base_repository.dart';
import 'package:privo/app/models/payment_history_model.dart';

class PaymentHistoryRepository extends BaseRepository {
  Future<PaymentHistoryModel> getPaymentHistory(
      {required String loanId,
      String fromDate = "",
      String? sortOrder,
      int page = 1,
      String toDate = ""}) async {
    ApiResponse apiResponse = await HttpClient.get(
      url:
          "$aquManBaseUrl/loan/$loanId/paymentHistory?appFormId=$appFormId&toDate=$toDate&fromDate=$fromDate&sortOrder=$sortOrder&page=$page",
    );
    return paymentHistoryModelFromJson(apiResponse);
  }
}
