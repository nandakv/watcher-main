import 'package:privo/app/api/http_client.dart';
import 'package:privo/app/api/response_model.dart';
import 'package:privo/app/models/razorpay_order_model.dart';

import 'base_repository.dart';

class RePaymentRepository extends BaseRepository {
  Future<RazorPayOrderModel> getOrderId(Map<String, dynamic> body) async {
    ApiResponse apiResponse = await HttpClient.post(
        url: "$bifrostBaseUrl/repaymentOrder/create",
        body: body,
        authType: AuthType.token);
    return razorPayOrderModelFromJson(apiResponse);
  }
}
