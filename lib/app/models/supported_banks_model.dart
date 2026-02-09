import 'dart:convert';

import 'package:get/get.dart';

import '../api/response_model.dart';
import 'app_form_post_response_model.dart';

enum BankStatementUploadCombination { aa, nb, up, aaNB, aaUP, nbUP, all }

enum JusPayMandateCombination {
  upi,
  eNach,
  all,
}

SupportedBanksModel supportedBanksNameModelFromJson(ApiResponse apiResponse) {
  return SupportedBanksModel.decodeResponse(apiResponse);
}

class SupportedBanksModel {
  SupportedBanksModel(
      {required this.rejection,
      required this.apiResponse,
      required this.responseBody,
      required this.supportedBanks});

  late final Rejection? rejection;
  late final List<dynamic> responseBody;
  late ApiResponse apiResponse;
  late List<BanksModel> supportedBanks;

  SupportedBanksModel.decodeResponse(ApiResponse apiResponse) {
    switch (apiResponse.state) {
      case ResponseState.success:
        try {
          _parseJson(apiResponse);
          this.apiResponse = apiResponse..state = ResponseState.success;
        } catch (e) {
          this.apiResponse = apiResponse
            ..state = ResponseState.jsonParsingError
            ..exception = e.toString();
        }
        break;
      default:
        this.apiResponse = apiResponse;
    }
  }

  void _parseJson(ApiResponse apiResponse) {
    Map<String, dynamic> jsonMap = jsonDecode(apiResponse.apiResponse);
    rejection = jsonMap['rejection'] == null
        ? null
        : Rejection.fromJson(jsonMap['rejection']);
    responseBody = jsonMap['responseBody'] ?? {};
    supportedBanks = _parseListOfBanks(responseBody);
  }

  List<BanksModel> _parseListOfBanks(List jsonData) {
    try {
      List<BanksModel> tmpList = [];
      for (var element in jsonData) {
        tmpList.add(BanksModel.fromJson(element));
      }
      return tmpList;
    } on Exception catch (e) {
      Get.log(e.toString());
    }
    return [];
  }
}

class BanksModel {
  late final int id;
  late final String razorpayBankName;
  late final String razorpayBankCode;
  late final bool emandateNetbankingSupported;
  late final bool emandateDebitcardSupported;
  late final int perfiosId;
  late final int perfiosInstitutionId;
  late final String perfiosBankName;
  late final String pirimidBankName;
  late final String ifscCode;
  late final String fipCode;
  late final bool statementSupported;
  late final bool netbankingSupported;
  late final String entityName;
  late final String pirimidBankId;
  late final bool accountAggregatorSupported;
  late final bool emandateUpiSupported;
  late final ApiResponse apiResponse;

  BanksModel.decodeResponse(ApiResponse apiResponse) {
    switch (apiResponse.state) {
      case ResponseState.success:
        try {
          Map<String, dynamic> json = jsonDecode(apiResponse.apiResponse);
          _parseJson(json);
          this.apiResponse = apiResponse;
        } catch (e) {
          this.apiResponse = apiResponse
            ..state = ResponseState.jsonParsingError
            ..exception = e.toString();
        }
        break;
      default:
        this.apiResponse = apiResponse;
    }
  }

  _parseJson(Map<String, dynamic> json) {
    id = json["id"];
    razorpayBankName = json["razorpayBankName"];
    razorpayBankCode = json["razorpayBankCode"] ?? "";
    ifscCode = json["ifscCode"] ?? "";
    emandateNetbankingSupported = json["emandateNetbankingSupported"];
    emandateDebitcardSupported = json["emandateDebitcardSupported"];
    perfiosId = json['perfiosId'] ?? 0;
    perfiosInstitutionId = json['perfiosInstitutionId'];
    perfiosBankName = json['perfiosBankName'];
    pirimidBankName = json['pirimidBankName'] ?? "";
    statementSupported = json['statementSupported'];
    netbankingSupported = json['netbankingSupported'];
    pirimidBankId = json['pirimidBankId'] ?? "";
    entityName = json['entityName'] ?? "";
    accountAggregatorSupported = json['accountAggregatorSupported'] ?? false;
    emandateUpiSupported = json['emandateUpiSupported'] ?? false;
  }

  BanksModel.fromJson(Map<String, dynamic> json) {
    _parseJson(json);
  }

  JusPayMandateCombination computeJusPayMandateType() {
    Map<String, JusPayMandateCombination> combinationMap = {
      "upi:true,nb:true,card:true": JusPayMandateCombination.all,
      "upi:true,nb:false,card:true": JusPayMandateCombination.all,
      "upi:true,nb:true,card:false": JusPayMandateCombination.all,
      "upi:true,nb:false,card:false": JusPayMandateCombination.upi,
      "upi:false,nb:true,card:false": JusPayMandateCombination.eNach,
      "upi:false,nb:false,card:true": JusPayMandateCombination.eNach,
      "upi:false,nb:true,card:true": JusPayMandateCombination.eNach,
    };

    return combinationMap[
            "upi:$emandateUpiSupported,nb:$emandateNetbankingSupported,card:$emandateDebitcardSupported"] ??
        JusPayMandateCombination.all;
  }

  BankStatementUploadCombination computeBankUploadOptionCombination() {
    Map<String, BankStatementUploadCombination> combinationMap = {
      "aa:true,nb:true,up:true": BankStatementUploadCombination.all,
      "aa:true,nb:false,up:false": BankStatementUploadCombination.aa,
      "aa:false,nb:true,up:false": BankStatementUploadCombination.nb,
      "aa:false,nb:false,up:true": BankStatementUploadCombination.up,
      "aa:true,nb:true,up:false": BankStatementUploadCombination.aaNB,
      "aa:true,nb:false,up:true": BankStatementUploadCombination.aaUP,
      "aa:false,nb:true,up:true": BankStatementUploadCombination.nbUP,
    };

    return combinationMap[
            "aa:$accountAggregatorSupported,nb:$netbankingSupported,up:$statementSupported"] ??
        BankStatementUploadCombination.all;
  }

  static Map<String, dynamic> toJson(BanksModel model) => {
        "id": model.id,
        "razorpayBankName": model.razorpayBankName,
        "razorpayBankCode": model.razorpayBankCode,
        "emandateNetbankingSupported": model.emandateNetbankingSupported,
        "emandateDebitcardSupported": model.emandateDebitcardSupported,
        "perfiosId": model.perfiosId,
        "perfiosInstitutionId": model.perfiosInstitutionId,
        "perfiosBankName": model.perfiosBankName,
        "statementSupported": model.statementSupported,
        "netbankingSupported": model.netbankingSupported,
        "entityName": model.entityName,
        "ifscCode": model.ifscCode
      };

  @override
  String toString() {
    return "netbankingSupported - $netbankingSupported, statementSupported - $statementSupported, accountAggregatorSupported - $accountAggregatorSupported";
  }
}
