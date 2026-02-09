import 'package:privo/app/api/http_client.dart';
import 'package:privo/app/api/response_model.dart';
import 'package:privo/app/data/repository/base_repository.dart';
import 'package:privo/app/models/document_model.dart';
import 'package:privo/app/models/loan_docs_model.dart';
import 'package:privo/app/models/signed_url_model.dart';

import '../../models/servicing_config_model.dart';

class LoanDetailsRepository extends BaseRepository {
  ///Function to get the pending loan details
  Future<DocumentModel> getStatementOfAccount(
      {required String loanId,
      required String fromDate,
      required String toDate}) async {
    ApiResponse apiResponse = await HttpClient.get(
      url:
          "$aquManBaseUrl/loan/$loanId/statement?toDate=$toDate&fromDate=$fromDate",
    );
    return documentModelFromJson(apiResponse);
  }

  ///Function to get the document url signed from Dr.Strange API
  Future<SignedUrlModel> getUrlSigned(String url) async {
    ApiResponse apiResponse = await HttpClient.get(
      url: "$drStrangeBaseUrl/urlGenerator?url=$url",
    );
    return signedUrlModelFromJson(apiResponse);
  }

  Future<ListLoanDocs> getLoanDocProvider({required String loanId}) async {
    ApiResponse apiResponse = await HttpClient.get(
      url: "$aquManBaseUrl/loan/$loanId/docs",
    );
    return listLoanDocsModelFromJson(apiResponse);
  }

  Future<LoanDocumentsModel> getLoanDocuments(
      String loanId,String loanProductCode) async {
    ApiResponse apiResponse = await HttpClient.get(
      url: "$aquManBaseUrl/loanDocuments/$loanId/$loanProductCode",
    );
    return LoanDocumentsModel.decodeResponse(apiResponse);
  }
}
