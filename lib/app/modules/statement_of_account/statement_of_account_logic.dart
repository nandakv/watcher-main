import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:privo/app/api/api_error_mixin.dart';
import 'package:privo/app/api/response_model.dart';
import 'package:privo/app/common_widgets/blue_button.dart';
import 'package:privo/app/common_widgets/gradient_button.dart';
import 'package:privo/app/data/repository/loan_details_repository.dart';
import 'package:privo/app/models/document_model.dart';
import 'package:privo/app/models/signed_url_model.dart';
import 'package:privo/app/routes/app_pages.dart';

import '../pdf_document/pdf_document_logic.dart';

class StatementOfAccountLogic extends GetxController with ApiErrorMixin {
  var fromDateString = "dd/mm/yyyy".obs;
  var toDateString = "dd/mm/yyyy".obs;

  ///Variables for dates for statement of account
  var fromDate = DateTime.now().obs;
  var toDate = DateTime.now().obs;

  late String STATEMENT_OF_ACCOUNT_SCREEN = "statement_of_account";

  ///Get statement of account from api
  ///This function will also trigger the progress indicator and circular progress bar
  getSoaFromDB(String loanId) async {
    _showLoadingDialog();
    DocumentModel _documentModel =
        await LoanDetailsRepository().getStatementOfAccount(
      loanId: loanId,
      fromDate: _computeDateForLoanDocument(
        fromDateString.value.replaceAll('/', '-'),
      ),
      toDate: _computeDateForLoanDocument(
        toDateString.value.replaceAll('/', '-'),
      ),
    );
    switch (_documentModel.apiResponse.state) {
      case ResponseState.success:
        if (_documentModel == null) {
          await _onUrlNull();
        } else {
          await _onDocumentModel(_documentModel);
        }
        break;
      default:
        Get.back();
        handleAPIError(_documentModel.apiResponse,
            screenName: STATEMENT_OF_ACCOUNT_SCREEN, retry: getSoaFromDB);
    }
  }

  String _computeDateForLoanDocument(String date) {
    Iterable<String> dateList = date.split('-').reversed;
    return dateList.join('-');
  }

  Future<void> _onDocumentModel(DocumentModel _documentModel) async {
    SignedUrlModel signedUrlModel =
        await LoanDetailsRepository().getUrlSigned(_documentModel.outputUrl);
    switch (signedUrlModel.apiResponse.state) {
      case ResponseState.success:
        await _onDownloadSoaSuccess(signedUrlModel.url);
        break;
      default:
        handleAPIError(signedUrlModel.apiResponse,
            screenName: STATEMENT_OF_ACCOUNT_SCREEN);
        break;
    }
  }

  Future<void> _onUrlNull() async {
    Get.back();
    Get.defaultDialog(title: "Sorry ");
    await Get.defaultDialog(
        title: "Oops",
        content: const Text("Please select a valid date"),
        contentPadding: const EdgeInsets.all(12),
        actions: [
          GradientButton(
            onPressed: () => Get.back(),
            title: "OKAY",
          )
        ]);
  }

  Future<void> _onDownloadSoaSuccess(String url) async {
    await Get.toNamed(Routes.PDF_DOCUMENT_SCREEN, arguments: {
      'url': url,
      'fileName': 'SOA',
      'documentType': DocumentType.soaLetter
    });
    Get.back();
  }

  _showLoadingDialog() {
    Get.defaultDialog(
      title: "Please wait..",
      titleStyle: TextStyle(fontSize: 12),
      onWillPop: () async {
        return false;
      },
      barrierDismissible: false,
      content: const CircularProgressIndicator(),
    );
  }
}
