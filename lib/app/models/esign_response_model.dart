import 'dart:convert';

ESignResponseModel eSignResponseModelFromJson(String? str) =>
    ESignResponseModel.fromJson(json.decode(str!));

class ESignResponseModel {
  ESignResponseModel({
    required this.responseBody,
  });

  late final ResponseBody responseBody;

  ESignResponseModel.fromJson(Map<String, dynamic> json) {
    responseBody = ResponseBody.fromJson(json['responseBody']);
  }
}


class ResponseBody {
  ResponseBody({
    required this.appFormId,
    required this.tokenId,
    required this.documentId,
  });
  late final String appFormId;
  late final String tokenId;
  late final String documentId;

  ResponseBody.fromJson(Map<String, dynamic> json){
    appFormId = json['appFormId'];
    tokenId = json['tokenId'];
    documentId = json['documentId'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['appFormId'] = appFormId;
    _data['tokenId'] = tokenId;
    _data['documentId'] = documentId;
    return _data;
  }
}