import 'dart:convert';

import 'package:get/get.dart';
import 'package:privo/app/api/response_model.dart';
import 'package:privo/app/models/document_type_list_model.dart';

FileTagModel fileTagModelFromJson(ApiResponse apiResponse) {
  return FileTagModel.decodeResponse(apiResponse);
}

class FileTagModel {
  late final TaggedDoc taggedDoc;
  late final ApiResponse apiResponse;
  late final List<AllowedDocType> docs;

  FileTagModel.decodeResponse(ApiResponse apiResponse) {
    switch (apiResponse.state) {
      case ResponseState.success:
        try {
          _parseJson(apiResponse.apiResponse);
          this.apiResponse = apiResponse..state = ResponseState.success;
        } catch (e) {
          Get.log("FileTagModel exception ${e.toString()}");
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
    json = json['AppFormDocs'][0];
    taggedDoc = TaggedDoc(
      url: json['s3Url'],
      fileName: json['fileName'],
      id: json['id'],
    );
    List<dynamic> section = json['section'];
    docs = section.isNotEmpty
        ? List<AllowedDocType>.from(json['section'][0]['sectionProperty']
                ['allowedDocTypes']
            .map((x) => AllowedDocType.fromJson(x)))
        : [];
  }
}
