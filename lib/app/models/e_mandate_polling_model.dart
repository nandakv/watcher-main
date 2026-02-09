import 'dart:convert';

import 'package:privo/app/api/response_model.dart';
import 'package:privo/app/models/check_app_form_model.dart';

enum EMandatePollingStatus { success, failure, pending }

class EMandatePollingModel extends CheckAppFormModel {
  late final EMandatePollingStatus eMandatePollingStatus;
  late final String accountNumber;
  late final String bankName;
  late final bool isTPVFailure;
  late final String mandateMethod;

  EMandatePollingModel.decodeResponse(ApiResponse apiResponse)
      : super.decodeResponse(apiResponse) {
    try {
      _parseJson();
    } catch (e) {
      this.apiResponse = apiResponse
        ..state = ResponseState.jsonParsingError
        ..exception = e.toString();
    }
  }

  void _parseJson() {
    mandateMethod = _computeMandateMethod();
    if (responseBody['polling_status'] == "COMPLETE") {
      _checkEMandateStatus();
    } else {
      eMandatePollingStatus = EMandatePollingStatus.pending;
    }
  }

  void _checkEMandateStatus() {
    if (responseBody['mandateStatus'] == "SUCCESS") {
      eMandatePollingStatus = EMandatePollingStatus.success;
    } else {
      isTPVFailure = responseBody['tpv_failure'] ?? false;
      _parseBankDetails();
      eMandatePollingStatus = EMandatePollingStatus.failure;
    }
  }

  void _parseBankDetails() {
    if (responseBody['loanProduct'] == "SBL") {
      _parseBankDetailsForSBL();
    } else if (responseBody['pennyTesting'] != null) {
      _parseBankDetailsFromPennyTestingKey();
    } else {
      _parseBankDetailsFromBankAccountsKey();
    }
  }

  _parseBankDetailsForSBL() {
    accountNumber = responseBody['mandateBankAccount']['accountNumber'];
    bankName = responseBody['mandateBankAccount']['bankName'];
  }

  _parseBankDetailsFromBankAccountsKey() {
    accountNumber = responseBody['bankAccounts']['accountNumber'];
    bankName = responseBody['bankAccounts']['bankName'];
  }

  _parseBankDetailsFromPennyTestingKey() {
    accountNumber = responseBody['pennyTesting']['accountNumber'];
    bankName = responseBody['pennyTesting']['bankName'] ??
        responseBody['bankAccounts']['bankName'];
  }

  String _computeMandateMethod() {
    if (responseBody['mandateMethod'] == null) return "";
    switch (responseBody['mandateMethod']) {
      case "upimandate":
        return "UPI";
      case "emandate":
        return "eNACH";
      case "cardmandate":
        return "Debit_Card";
      default:
        return "";
    }
  }
}
