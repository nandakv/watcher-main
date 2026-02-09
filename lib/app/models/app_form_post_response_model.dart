import 'dart:convert';

import 'package:get/get.dart';

AppFormPostResponse? appFormPostResponseModelFromJson(String? str) {
  try {
    return AppFormPostResponse.fromJson(json.decode(str!));
  } on Exception catch (e) {
    Get.log(e.toString());
    return null;
  }
}

class AppFormPostResponse {
  AppFormPostResponse(
      {required this.responseCode,
      required this.timestamp,
      required this.appFormId,
      required this.error,
      required this.responseBody,
      required this.rejection});

  late final String responseCode;
  late final int timestamp;
  late final Rejection? rejection;
  late final String appFormId;
  late final Error? error;
  late final ResponseBody responseBody;

  AppFormPostResponse.fromJson(Map<String, dynamic> json) {
    responseCode = json['responseCode'];
    timestamp = json['timestamp'];
    appFormId = json['appFormId'];
    error = (json['error'] == null || json['error'].isEmpty)
        ? null
        : Error.fromJson(json['error']);
    rejection = json['rejection'] == null
        ? null
        : Rejection.fromJson(json['rejection']);
    responseBody = ResponseBody.fromJson(json['responseBody']);
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['responseCode'] = responseCode;
    _data['timestamp'] = timestamp;
    _data['appFormId'] = appFormId;
    _data['error'] = error!.toJson();
    _data['responseBody'] = responseBody.toJson();
    return _data;
  }
}

class Rejection {
  Rejection({
    required this.status,
    required this.reason,
  });

  late final String status;
  late final String reason;

  Rejection.fromJson(Map<String, dynamic> json) {
    status = json['status'] ?? "";
    reason = json['reason'] ?? "";
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['reason'] = reason;
    _data['status'] = status;
    return _data;
  }
}

class ResponseBody {
  ResponseBody({
    required this.loanProduct,
    required this.verification,
    required this.appFormId,
    required this.status,
    required this.applicant,
    required this.creditPolicyCheck,
    required this.preprocessor,
    required this.description,
    required this.state,
  });

  late final String loanProduct;
  late final Verification verification;
  late final String appFormId;
  late final String status;
  late final Applicant applicant;
  late final CreditPolicyCheck creditPolicyCheck;
  late final Preprocessor preprocessor;
  late final String description;
  late final String state;

  ResponseBody.fromJson(Map<String, dynamic> json) {
    loanProduct = json['loanProduct'];
    verification = Verification.fromJson(json['verification']);
    appFormId = json['appFormId'];
    status = json['status'];
    applicant = Applicant.fromJson(json['applicant']);
    creditPolicyCheck = CreditPolicyCheck.fromJson(json['creditPolicyCheck']);
    preprocessor = Preprocessor.fromJson(json['preprocessor']);
    description = json['description'];
    state = json['state'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['loanProduct'] = loanProduct;
    _data['verification'] = verification.toJson();
    _data['appFormId'] = appFormId;
    _data['status'] = status;
    _data['applicant'] = applicant.toJson();
    _data['creditPolicyCheck'] = creditPolicyCheck.toJson();
    _data['preprocessor'] = preprocessor.toJson();
    _data['description'] = description;
    _data['state'] = state;
    return _data;
  }
}

class Verification {
  String? pan;
  KarzaResponse? karzaResponse;

  Verification({this.pan, this.karzaResponse});

  Verification.fromJson(Map<String, dynamic> json) {
    pan = json['pan'];
    karzaResponse = json['karzaResponse'] != null
        ? KarzaResponse.fromJson(json['karzaResponse'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['pan'] = this.pan;
    if (this.karzaResponse != null) {
      data['karzaResponse'] = this.karzaResponse!.toJson();
    }
    return data;
  }
}

class KarzaResponse {
  String? verification;
  Result? result;

  KarzaResponse({this.verification, this.result});

  KarzaResponse.fromJson(Map<String, dynamic> json) {
    verification = json['verification'];
    result =
        json['result'] != null ? new Result.fromJson(json['result']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['verification'] = this.verification;
    if (this.result != null) {
      data['result'] = this.result!.toJson();
    }
    return data;
  }
}

class Result {
  bool? dobMatch;
  bool? nameMatch;
  String? status;
  Null? duplicate;

  Result({this.dobMatch, this.nameMatch, this.status, this.duplicate});

  Result.fromJson(Map<String, dynamic> json) {
    dobMatch = json['dobMatch'];
    nameMatch = json['nameMatch'];
    status = json['status'];
    duplicate = json['duplicate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['dobMatch'] = this.dobMatch;
    data['nameMatch'] = this.nameMatch;
    data['status'] = this.status;
    data['duplicate'] = this.duplicate;
    return data;
  }
}

class Applicant {
  Applicant({
    required this.fullName,
    required this.phoneNumber,
    required this.applicantId,
    required this.personalEmail,
  });

  late final String fullName;
  late final String phoneNumber;
  late final String applicantId;
  late final String personalEmail;

  Applicant.fromJson(Map<String, dynamic> json) {
    fullName = json['fullName'];
    phoneNumber = json['phoneNumber'];
    applicantId = json['applicantId'];
    personalEmail = json['personalEmail'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['fullName'] = fullName;
    _data['phoneNumber'] = phoneNumber;
    _data['applicantId'] = applicantId;
    _data['personalEmail'] = personalEmail;
    return _data;
  }
}

class CreditPolicyCheck {
  CreditPolicyCheck({
    required this.ageAndPincode,
  });

  late final String ageAndPincode;

  CreditPolicyCheck.fromJson(Map<String, dynamic> json) {
    ageAndPincode = json['ageAndPincode'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['ageAndPincode'] = ageAndPincode;
    return _data;
  }
}

class Preprocessor {
  Preprocessor();

  Preprocessor.fromJson(Map json);

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    return _data;
  }
}

class Error {
  Error({
    required this.errorMessage,
    required this.errorBody,
  });

  late final String errorMessage;
  late final ErrorBody errorBody;

  Error.fromJson(Map<String, dynamic> json) {
    errorMessage = json['errorMessage'] ?? "";
    errorBody = ErrorBody.fromJson(json['errorBody'] ?? {});
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['errorMessage'] = errorMessage;
    _data['errorBody'] = errorBody.toJson();
    return _data;
  }
}

class ErrorBody {
  ErrorBody({
    required this.errorBody,
  });

  late final String errorBody;

  ErrorBody.fromJson(Map<String, dynamic> json) {
    errorBody = json.toString();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['errorBody'] = errorBody;
    return _data;
  }
}
