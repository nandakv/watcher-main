import 'dart:convert';

import 'package:get/get.dart';
import 'package:privo/app/api/response_model.dart';
import 'package:privo/app/models/document_type_list_model.dart';

UnTaggedDocModel unTaggedDocModelFromJson(ApiResponse apiResponse) {
  return UnTaggedDocModel.decodeResponse(apiResponse);
}

class UnTaggedDocModel {
  late final ApiResponse apiResponse;
  late final List<TaggedDoc> docs;

  UnTaggedDocModel.decodeResponse(ApiResponse apiResponse) {
    switch (apiResponse.state) {
      case ResponseState.success:
        try {
          _parseJson(apiResponse.apiResponse);
          this.apiResponse = apiResponse..state = ResponseState.success;
        } catch (e) {
          Get.log("AppForm tag model exception ${e.toString()}");
          this.apiResponse = apiResponse
            ..state = ResponseState.jsonParsingError
            ..exception = e.toString();
        }
        break;
      default:
        this.apiResponse = apiResponse;
    }
  }

  _parseJson(String apiResponse) {
    var json = jsonDecode(apiResponse);
    List<dynamic> untagged = json['untagged'];
    List<TaggedDoc> untaggedDocs = [];
    for (var element in untagged) {
      untaggedDocs.add(TaggedDoc.fromJson(element));
    }
    docs = untaggedDocs;
  }
}
