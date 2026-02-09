


import 'dart:convert';

import 'package:get/get.dart';

///General response model to parse the response of the onboarding logic state
///management service


GeneralResponseModel? generalModelFromJson(String? str) {
  try {
    return GeneralResponseModel.fromJson(json.decode(str!));
  } on Exception catch (e) {
    Get.log(e.toString());
    return null;
  }
}


class GeneralResponseModel {
  GeneralResponseModel({
    required this.body,
    required this.status,
  });
  late final String body;
  late final int status;

  GeneralResponseModel.fromJson(Map<String, dynamic> json){
    body = json['Body'] ?? "";
    status = json['Status'] ?? 0;
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['Body'] = body;
    _data['Status'] = status;
    return _data;
  }
}