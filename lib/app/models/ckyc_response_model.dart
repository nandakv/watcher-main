import 'dart:convert';

import 'package:privo/app/api/response_model.dart';
import 'package:privo/app/models/app_form_rejection_model.dart';

CkycResponseModel ckycResponseModelFromJson(ApiResponse apiResponse) =>
    CkycResponseModel.decodeJson(apiResponse);

class CkycResponseModel {
  CkycResponseModel({
    required this.status,
    required this.ckycData,
    required this.apiResponse,
  });

  late final int status;
  late final CkycData ckycData;
  late ApiResponse apiResponse;

  CkycResponseModel.decodeJson(ApiResponse apiResponse) {
    switch (apiResponse.state) {
      case ResponseState.success:
        try {
          _parseJson(apiResponse);
          this.apiResponse = apiResponse
    ..state = ResponseState.success;
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
    Map<String, dynamic> jsonMap = json.decode(apiResponse.apiResponse);
    status = jsonMap['responseBody']['status'];
    ckycData = CkycData.fromJson(jsonMap['responseBody']['CkycData']);
  }
}

class CkycData {
  CkycData({
    required this.firstName,
    required this.middleName,
    required this.lastName,
    required this.fullName,
    required this.dob,
    required this.panValue,
    required this.fatherFirstName,
    required this.fatherMiddleName,
    required this.fatherLastName,
    required this.fatherFullName,
    required this.permanentAddLine1,
    required this.permanentAddLine2,
    required this.permanentAddLine3,
    required this.permanentCity,
    required this.permanentDistrict,
    required this.permanentState,
    required this.permanentCountry,
    required this.permanentPincode,
    required this.imageDetails,
  });

  late final String firstName;
  late final String middleName;
  late final String lastName;
  late final String fullName;
  late final String dob;
  late final String panValue;
  late final String fatherFirstName;
  late final String fatherMiddleName;
  late final String fatherLastName;
  late final String fatherFullName;
  late final String permanentAddLine1;
  late final String permanentAddLine2;
  late final String permanentAddLine3;
  late final String permanentCity;
  late final String permanentDistrict;
  late final String permanentState;
  late final String permanentCountry;
  late final String permanentPincode;
  late final List<ImageDetails> imageDetails;
  late final String s3ReportUrl;

  CkycData.fromJson(Map<String, dynamic> json) {
    firstName = json['firstName'] ?? "";
    middleName = json['middleName'] ?? "";
    lastName = json['lastName'] ?? "";
    fullName = json['fullName'] ?? "";
    dob = json['dob'] ?? "";
    panValue = json['panValue'] ?? "";
    fatherFirstName = json["fatherFirstName"] ?? "";
    fatherMiddleName = json["fatherMiddleName"] ?? "";
    fatherLastName = json["fatherLastName"] ?? "";
    fatherFullName = json["fatherFullName"] ?? "";
    permanentAddLine1 = json['permanentAddLine1'] ?? "";
    permanentAddLine2 = json['permanentAddLine2'] ?? "";
    permanentAddLine3 = json["permanentAddLine3"] ?? "";
    permanentCity = json['permanentCity'] ?? "";
    permanentDistrict = json['permanentDistrict'] ?? "";
    permanentState = json['permanentState'] ?? "";
    permanentCountry = json['permanentCountry'] ?? "";
    permanentPincode = json['permanentPincode'] ?? "";
    imageDetails = List.from(json['imageDetails'])
        .map((e) => ImageDetails.fromJson(e))
        .toList();
    s3ReportUrl = json['s3ReportUrl'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['firstName'] = firstName;
    _data['middleName'] = middleName;
    _data['lastName'] = lastName;
    _data['fullName'] = fullName;
    _data['dob'] = dob;
    _data['panValue'] = panValue;
    _data['fatherFirstName'] = fatherFirstName;
    _data['fatherMiddleName'] = fatherMiddleName;
    _data['fatherLastName'] = fatherLastName;
    _data['fatherFullName'] = fatherFullName;
    _data['permanentAddLine1'] = permanentAddLine1;
    _data['permanentAddLine2'] = permanentAddLine2;
    _data['permanentAddLine3'] = permanentAddLine3;
    _data['permanentCity'] = permanentCity;
    _data['permanentDistrict'] = permanentDistrict;
    _data['permanentState'] = permanentState;
    _data['permanentCountry'] = permanentCountry;
    _data['permanentPincode'] = permanentPincode;
    _data['imageDetails'] = imageDetails.map((e) => e.toJson()).toList();
    _data['s3ReportUrl'] = s3ReportUrl;
    return _data;
  }
}

class ImageDetails {
  ImageDetails({
    required this.ckycimageType,
    required this.ckycimageData,
    required this.ckycimageExtension,
  });

  late final String ckycimageType;
  late final String ckycimageData;
  late final String ckycimageExtension;

  ImageDetails.fromJson(Map<String, dynamic> json) {
    ckycimageType = json['ckycimageType'] ?? "";
    ckycimageData = json['ckycimageData'] ?? "";
    ckycimageExtension = json['ckycimageExtension'] ?? "";
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['ckycimageType'] = ckycimageType;
    _data['ckycimageData'] = ckycimageData;
    _data['ckycimageExtension'] = ckycimageExtension;
    return _data;
  }
}
