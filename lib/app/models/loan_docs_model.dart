// To parse this JSON data, do
//
//     final loanDocsModel = loanDocsModelFromJson(jsonString);

import 'dart:convert';

import 'package:get/get.dart';
import 'package:privo/app/api/response_model.dart';

ListLoanDocs listLoanDocsModelFromJson(ApiResponse apiResponse) {
  return ListLoanDocs.decodeResponse(apiResponse);
}

String listLoanDocsModelToJson(List<LoanDocsModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ListLoanDocs {
  late List<LoanDocsModel> loanDocsModel;
  late final ApiResponse apiResponse;

  ListLoanDocs.decodeResponse(ApiResponse apiResponse) {
    switch (apiResponse.state) {
      case ResponseState.success:
        try {
          _parseJson(apiResponse);
          this.apiResponse = apiResponse..state = ResponseState.success;
        } catch (e) {
          Get.log("Loan docs exception ${e.toString()}");
          this.apiResponse = apiResponse
            ..state = ResponseState.jsonParsingError
            ..exception = e.toString();
        }
        break;
      default:
        this.apiResponse = apiResponse;
    }
  }

  _parseJson(ApiResponse apiResponse) {
    var json = jsonDecode(apiResponse.apiResponse);
    loanDocsModel = _parseListOfDocs(json);
  }

  List<LoanDocsModel> _parseListOfDocs(List jsonData) {
    try {
      List<LoanDocsModel> tmpList = [];
      for (var element in jsonData) {
        tmpList.add(LoanDocsModel.fromJson(element));
      }
      return tmpList;
    } on Exception catch (e) {
      Get.log(e.toString());
    }
    return [];
  }
}

class LoanDocsModel {
  LoanDocsModel({
    required this.appFormId,
    required this.link,
    required this.docType,
  });

  String appFormId;
  String link;
  String docType;

  factory LoanDocsModel.fromJson(Map<String, dynamic> json) => LoanDocsModel(
        appFormId: json["app_form_id"],
        link: json["link"],
        docType: json["doc_type"],
      );

  Map<String, dynamic> toJson() => {
        "app_form_id": appFormId,
        "link": link,
        "doc_type": docType,
      };
}
