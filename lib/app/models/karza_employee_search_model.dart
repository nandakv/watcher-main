import 'dart:convert';

import 'package:get/get.dart';
import 'package:privo/app/api/response_model.dart';

KarzaEmployeeSearchModel karzaEmployeeSearchModelFromJson(
        ApiResponse apiResponse) =>
    KarzaEmployeeSearchModel.decodeResponse(apiResponse);

class KarzaEmployeeSearchModel {
  late final String requestId;
  late final List<EmployeeResult> employeeResult;
  late final int statusCode;
  late ApiResponse apiResponse;

  KarzaEmployeeSearchModel.decodeResponse(ApiResponse apiResponse) {
    switch (apiResponse.state) {
      case ResponseState.success:
        try {
          Map<String, dynamic> jsonMap = json.decode(apiResponse.apiResponse);
          _fromJson(jsonMap);
          this.apiResponse = apiResponse..state = ResponseState.success;
        } catch (e) {
          this.apiResponse = apiResponse
            ..state = ResponseState.jsonParsingError
            ..exception = e.toString();
        }
        this.apiResponse = apiResponse..state = ResponseState.success;
        break;
      default:
        this.apiResponse = apiResponse;
    }
  }

  _fromJson(Map<String, dynamic> json) {
    requestId = json['requestId'];
    employeeResult = List.from(json['result'])
        .map((e) => EmployeeResult.fromJson(e))
        .toList();
    statusCode = json['statusCode'];
  }
}

class EmployeeResult {
  EmployeeResult({
    required this.kid,
    required this.name,
    this.entityId,
    required this.additionalEntityIds,
    required this.primaryName,
    this.secondaryName,
    required this.otherName,
    this.isEpfActive,
    this.isEpfExempted,
    required this.score,
  });

  late final String kid;
  late final String name;
  late final String? entityId;
  late final List<dynamic> additionalEntityIds;
  late final String primaryName;
  late final String? secondaryName;
  late final List<OtherName> otherName;
  late final bool? isEpfActive;
  late final bool? isEpfExempted;
  late final double score;

  EmployeeResult.fromJson(Map<String, dynamic> json) {
    kid = json['kid'];
    name = json['name'];
    entityId = null;
    additionalEntityIds =
        List.castFrom<dynamic, dynamic>(json['additionalEntityIds'] ?? []);
    primaryName = json['primaryName'];
    secondaryName = null;
    otherName = List.from(json['otherName'] ?? {})
        .map((e) => OtherName.fromJson(e))
        .toList();
    isEpfActive = null;
    isEpfExempted = null;
    score = json['score'] ?? 0.0;
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['kid'] = kid;
    _data['name'] = name;
    _data['entityId'] = entityId;
    _data['additionalEntityIds'] = additionalEntityIds;
    _data['primaryName'] = primaryName;
    _data['secondaryName'] = secondaryName;
    _data['otherName'] = otherName.map((e) => e.toJson()).toList();
    _data['isEpfActive'] = isEpfActive;
    _data['isEpfExempted'] = isEpfExempted;
    _data['score'] = score;
    return _data;
  }
}

class OtherName {
  OtherName({
    required this.source,
    required this.name,
  });

  late final String source;
  late final String name;

  OtherName.fromJson(Map<String, dynamic> json) {
    source = json['source'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['source'] = source;
    _data['name'] = name;
    return _data;
  }
}
