import 'package:privo/app/api/http_client.dart';
import 'package:privo/app/api/response_model.dart';
import 'package:privo/app/data/provider/auth_provider.dart';
import 'package:privo/app/data/repository/base_repository.dart';
import 'package:privo/app/models/check_app_form_model.dart';
import 'package:privo/app/models/foreclosure_payment_info_model.dart';

import 'package:privo/app/models/loan_details_model.dart';
import 'package:privo/app/models/loans_model.dart';
import 'package:privo/app/models/overdue_loan_list.dart';
import 'package:privo/app/models/part_payment_info_model.dart';
import 'package:privo/app/models/pending_loan_details.dart';

import '../../models/advance_emi_payment_info_model.dart';

class EmiRepository extends BaseRepository {
  ///Function to get the loan details
  Future<LoanDetailsModel> getLoanDetails({required String loanId}) async {
    ApiResponse apiResponse = await HttpClient.get(
      url: "$aquManV2BaseUrl/loan/$loanId",
    );
    return loanDetailModelFromJson(apiResponse);
  }

  ///Function to get the pending loan details
  Future<PendingLoanDetailsModel> getPendingLoanDetails(String loanId) async {
    ApiResponse apiResponse = await HttpClient.get(
      url: "$aquManBaseUrl/loan/$loanId/pendingPayments",
    );
    return pendingLoanDetailModelFromJson(apiResponse);
  }

  ///Function to get all the customer loans
  Future<LoansModel> getLoans({required String customerId}) async {
    ApiResponse apiResponse = await HttpClient.get(
      url: "$aquManV2BaseUrl/customer/$customerId/loans",
    );
    return LoansModelFromJson(apiResponse);
  }

  ///Function to get overdue loans
  Future<OverDueLoansModel> getOverdueLoans(
      {required String customerId, String lpc = "CLP"}) async {
    ApiResponse apiResponse = await HttpClient.get(
      url: "$aquManBaseUrl/customer/$customerId/dpd?loanProductCode=$lpc",
    );
    return overDueLoanListModelFromJson(apiResponse);
  }

  ///Function to get foreclosure paymentinfo
  Future<AdvanceEMIPaymentInfoModel> getAdvanceEMIPaymentInfo({
    required String loanId,
    required String loanStartDate,
    required String nextDueDate,
    required String paymentType,
  }) async {
    ApiResponse apiResponse = await HttpClient.get(
      url:
          "$aquManBaseUrl/payment?loanId=$loanId&nextDueDate=$nextDueDate&loanStartDate=$loanStartDate&paymentType=$paymentType",
    );
    return AdvanceEMIPaymentInfoModel.decodeResponse(apiResponse);
  }

  ///Function to get foreclosure paymentinfo
  Future<ForeclosurePaymentInfoModel> getForeclosePaymentInfo({
    required String loanId,
    required String loanStartDate,
    required String nextDueDate,
    required String paymentType,
  }) async {
    ApiResponse apiResponse = await HttpClient.get(
      url:
      "$aquManBaseUrl/payment?loanId=$loanId&nextDueDate=$nextDueDate&loanStartDate=$loanStartDate&paymentType=$paymentType",
    );
    return ForeclosurePaymentInfoModel.decodeResponse(apiResponse);
  }

  ///Function to get part payment info
  Future<PartPaymentInfoModel> getPartPaymentInfo({
    required String loanId
  }) async {
    ApiResponse apiResponse = await HttpClient.get(
      url:
      "$aquManBaseUrl/payment?loanId=$loanId&paymentType=partPay",
    );
    return PartPaymentInfoModel.decodeResponse(apiResponse);
  }
}
