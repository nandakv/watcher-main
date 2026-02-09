
import 'dart:convert';

import 'package:get/get.dart';


EmployeeAppFormDataResponseModel? employeeAppFormDataResponseModelFromJson(String? str) {
  try {
    return EmployeeAppFormDataResponseModel.fromJson(json.decode(str!));
  } on Exception catch (e) {
    Get.log(e.toString());
    return null;
  }
}

class EmployeeAppFormDataResponseModel {
  EmployeeAppFormDataResponseModel({
    required this.responseCode,
    required this.timestamp,
    required this.appFormId,
    required this.error,
    required this.responseBody,
  });
  late final String responseCode;
  late final int timestamp;
  late final String appFormId;
  late final Error error;
  late final ResponseBody responseBody;

  EmployeeAppFormDataResponseModel.fromJson(Map<String, dynamic> json){
    responseCode = json['responseCode'];
    timestamp = json['timestamp'];
    appFormId = json['appFormId'];
    error = Error.fromJson(json['error']);
    responseBody = ResponseBody.fromJson(json['responseBody']);
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['responseCode'] = responseCode;
    _data['timestamp'] = timestamp;
    _data['appFormId'] = appFormId;
    _data['error'] = error.toJson();
    _data['responseBody'] = responseBody.toJson();
    return _data;
  }
}


class ResponseBody {
  ResponseBody({
    required this.loanProduct,
    required this.verification,
    required this.fraudCheck,
    required this.appFormId,
    required this.status,
    required this.applicant,
    required this.fraudCheckResponse,
    required this.creditPolicyCheck,
    required this.preprocessor,
    required this.description,
    required this.state,
  });
  late final String loanProduct;
  late final Verification verification;
  late final String fraudCheck;
  late final String appFormId;
  late final String status;
  late final Applicant applicant;
  late final String fraudCheckResponse;
  late final CreditPolicyCheck creditPolicyCheck;
  late final Preprocessor preprocessor;
  late final String description;
  late final String state;

  ResponseBody.fromJson(Map<String, dynamic> json){
    loanProduct = json['loanProduct'];
    verification = Verification.fromJson(json['verification']);
    fraudCheck = json['fraudCheck'];
    appFormId = json['appFormId'];
    status = json['status'];
    applicant = Applicant.fromJson(json['applicant']);
    fraudCheckResponse = json['fraudCheckResponse'];
    creditPolicyCheck = CreditPolicyCheck.fromJson(json['creditPolicyCheck']);
    preprocessor = Preprocessor.fromJson(json['preprocessor']);
    description = json['description'];
    state = json['state'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['loanProduct'] = loanProduct;
    _data['verification'] = verification.toJson();
    _data['fraudCheck'] = fraudCheck;
    _data['appFormId'] = appFormId;
    _data['status'] = status;
    _data['applicant'] = applicant.toJson();
    _data['fraudCheckResponse'] = fraudCheckResponse;
    _data['creditPolicyCheck'] = creditPolicyCheck.toJson();
    _data['preprocessor'] = preprocessor.toJson();
    _data['description'] = description;
    _data['state'] = state;
    return _data;
  }
}

class Verification {
  Verification({
    required this.pan,
  });
  late final String pan;

  Verification.fromJson(Map<String, dynamic> json){
    pan = json['pan'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['pan'] = pan;
    return _data;
  }
}

class Applicant {
  Applicant({
    required this.fullName,
    required this.phoneNumber,
    required this.applicantId,
    required this.type,
    required this.personalEmail,
    required this.workEmail,
    required this.income,
    required this.employerName,
  });
  late final String fullName;
  late final String phoneNumber;
  late final String applicantId;
  late final String type;
  late final String personalEmail;
  late final String workEmail;
  late final String income;
  late final String employerName;

  Applicant.fromJson(Map<String, dynamic> json){
    fullName = json['fullName'];
    phoneNumber = json['phoneNumber'];
    applicantId = json['applicantId'];
    type = json['type'];
    personalEmail = json['personalEmail'];
    workEmail = json['workEmail'];
    income = json['income'];
    employerName = json['employerName'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['fullName'] = fullName;
    _data['phoneNumber'] = phoneNumber;
    _data['applicantId'] = applicantId;
    _data['type'] = type;
    _data['personalEmail'] = personalEmail;
    _data['workEmail'] = workEmail;
    _data['income'] = income;
    _data['employerName'] = employerName;
    return _data;
  }
}

class CreditPolicyCheck {
  CreditPolicyCheck({
    required this.income,
    required this.employmentType,
    required this.ageAndPincode,
  });
  late final String income;
  late final String employmentType;
  late final String ageAndPincode;

  CreditPolicyCheck.fromJson(Map<String, dynamic> json){
    income = json['income'] ?? "";
    employmentType = json['employmentType'] ?? "";
    ageAndPincode = json['ageAndPincode'] ?? "";
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['income'] = income;
    _data['employmentType'] = employmentType;
    _data['ageAndPincode'] = ageAndPincode;
    return _data;
  }
}

class Preprocessor {
  Preprocessor({
    required this.panKarza,
  });
  late final String panKarza;

  Preprocessor.fromJson(Map<String, dynamic> json){
    panKarza = json['pan_karza'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['pan_karza'] = panKarza;
    return _data;
  }
}



class Error {
  late final String errorMessage;
  late final Map? errorBody;
  Error({
    required this.errorMessage,
    this.errorBody
  });


  Error.fromJson(Map<String,dynamic> json) {
    try{
      errorMessage = json['errorMessage'];
      try{
        errorBody = json['errorBody'];
      }
      on TypeError catch(e){
        Get.log(e.toString());
        errorBody = {};
      }
    }
    on TypeError {
      errorMessage = "";
    }
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    return _data;
  }
}