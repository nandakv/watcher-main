import 'dart:convert';

import 'package:privo/app/api/response_model.dart';


enum DocStatus {show,hide,redirect}

class LoanDocumentsModel {
  late Document? nocDocument;
  late ApiResponse apiResponse;
  late List<Document> documents;

  LoanDocumentsModel.decodeResponse(ApiResponse apiResponse) {
    switch (apiResponse.state) {
      case ResponseState.success:
        try {
          Map<String, dynamic> jsonMap = jsonDecode(apiResponse.apiResponse);
          documents = <Document>[];
          if (jsonMap['documents'] != null) {
            jsonMap['documents'].forEach((v) {
              documents.add(Document.fromJson(v));
              if(v['document'] =="NOC_LETTER"){
                nocDocument = Document.fromJson(v);
              }
            });
          }
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
}

class Document {
  late DocStatus status;
  late String document;
  late String reason;

  Document({required this.status,required this.document,required this.reason});

  Document.fromJson(Map<String, dynamic> json) {
    status = _computeDocStatus(json['status']);
    document = json['document'];
    reason = json['reason'];
  }

  _computeDocStatus(String status){
    switch(status){
      case "SHOW":
        return DocStatus.show;
      case "HIDE":
        return DocStatus.hide;
      case "REDIRECT":
        return DocStatus.redirect;
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['status'] = status;
    data['document'] = document;
    data['reason'] = reason;
    return data;
  }
}
