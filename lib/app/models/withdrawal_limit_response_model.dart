import 'dart:convert';

import 'package:get/get.dart';
import 'package:privo/app/api/response_model.dart';

WithdrawalLimitResponseModel? withdrawalLimitResponseModelFromJson(
    ApiResponse apiResponse) {
  return WithdrawalLimitResponseModel.decodeResponse(apiResponse);
}

class WithdrawalLimitResponseModel {
  int? limitId;
  String? cif;
  String? customerName;
  String? responsibleBranch;
  String? responsibleBranchName;
  String? ccy;
  String? expiryDate;
  String? remarks;
  String? structureCode;
  String? structureName;
  bool? active;
  List<LimitDetail>? limitDetail;
  ReturnStatus? returnStatus;
  int? version;
  late final ApiResponse apiResponse;

  WithdrawalLimitResponseModel(
      {this.limitId,
      this.cif,
      this.customerName,
      this.responsibleBranch,
      this.responsibleBranchName,
      this.ccy,
      this.expiryDate,
      this.remarks,
      this.structureCode,
      this.structureName,
      this.active,
      this.limitDetail,
      this.returnStatus,
      this.version});

  WithdrawalLimitResponseModel.decodeResponse(ApiResponse apiResponse) {
    switch (apiResponse.state) {
      case ResponseState.success:
        try {
          _parseJson(apiResponse);
          this.apiResponse = apiResponse..state = ResponseState.success;
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

  _parseJson(ApiResponse apiResponse) {
    Map<String, dynamic> jsonMap = jsonDecode(apiResponse.apiResponse);
    limitId = jsonMap['limitId'];
    cif = jsonMap['cif'];
    customerName = jsonMap['customerName'];
    responsibleBranch = jsonMap['responsibleBranch'];
    responsibleBranchName = jsonMap['responsibleBranchName'];
    ccy = jsonMap['ccy'];
    expiryDate = jsonMap['expiryDate'];
    remarks = jsonMap['remarks'];
    structureCode = jsonMap['structureCode'];
    structureName = jsonMap['structureName'];
    active = jsonMap['active'];
    if (jsonMap['limitDetail'] != null) {
      limitDetail = <LimitDetail>[];
      jsonMap['limitDetail'].forEach((v) {
        limitDetail!.add(LimitDetail.fromJson(v));
      });
    }
    returnStatus = jsonMap['returnStatus'] != null
        ? ReturnStatus.fromJson(jsonMap['returnStatus'])
        : null;
    version = jsonMap['version'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['limitId'] = limitId;
    data['cif'] = cif;
    data['customerName'] = customerName;
    data['responsibleBranch'] = responsibleBranch;
    data['responsibleBranchName'] = responsibleBranchName;
    data['ccy'] = ccy;
    data['expiryDate'] = expiryDate;
    data['remarks'] = remarks;
    data['structureCode'] = structureCode;
    data['structureName'] = structureName;
    data['active'] = active;
    if (limitDetail != null) {
      data['limitDetail'] = limitDetail!.map((v) => v.toJson()).toList();
    }
    if (returnStatus != null) {
      data['returnStatus'] = returnStatus!.toJson();
    }
    data['version'] = version;
    return data;
  }
}

class LimitDetail {
  String? limitDetailId;
  String? structureDetailId;
  StructureDetail? structureDetail;
  bool? limitCheck;
  String? limitChkMethod;
  String? limitSanctioned;
  String? reservedLimit;
  String? actualexposure;
  String? reservedexposure;
  String? availableLimit;

  LimitDetail(
      {this.limitDetailId,
      this.structureDetailId,
      this.structureDetail,
      this.limitCheck,
      this.limitChkMethod,
      this.limitSanctioned,
      this.reservedLimit,
      this.actualexposure,
      this.reservedexposure,
      this.availableLimit});

  LimitDetail.fromJson(Map<String, dynamic> json) {
    limitDetailId = "${json['limitDetailId']}";
    structureDetailId = "${json['structureDetailId']}";
    structureDetail = json['structureDetail'] != null
        ? StructureDetail.fromJson(json['structureDetail'])
        : null;
    limitCheck = json['limitCheck'];
    limitChkMethod = json['limitChkMethod'];
    limitSanctioned = "${json['limitSanctioned']}";
    reservedLimit = "${json['reservedLimit']}";
    actualexposure = "${json['actualexposure']}";
    reservedexposure = "${json['reservedexposure']}";
    availableLimit = "${json['availableLimit']}";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['limitDetailId'] = limitDetailId;
    data['structureDetailId'] = structureDetailId;
    if (structureDetail != null) {
      data['structureDetail'] = structureDetail!.toJson();
    }
    data['limitCheck'] = limitCheck;
    data['limitChkMethod'] = limitChkMethod;
    data['limitSanctioned'] = limitSanctioned;
    data['reservedLimit'] = reservedLimit;
    data['actualexposure'] = actualexposure;
    data['reservedexposure'] = reservedexposure;
    data['availableLimit'] = availableLimit;
    return data;
  }
}

class StructureDetail {
  int? structureDetailId;
  String? groupCode;
  bool? revolving;
  bool? editable;
  bool? check;
  int? level;
  int? sequence;
  String? groupCodeDesc;
  String? lineCode;
  String? lineCodeDesc;

  StructureDetail(
      {this.structureDetailId,
      this.groupCode,
      this.revolving,
      this.editable,
      this.check,
      this.level,
      this.sequence,
      this.groupCodeDesc,
      this.lineCode,
      this.lineCodeDesc});

  StructureDetail.fromJson(Map<String, dynamic> json) {
    structureDetailId = json['structureDetailId'];
    groupCode = json['groupCode'];
    revolving = json['revolving'];
    editable = json['editable'];
    check = json['check'];
    level = json['level'];
    sequence = json['sequence'];
    groupCodeDesc = json['groupCodeDesc'];
    lineCode = json['lineCode'];
    lineCodeDesc = json['lineCodeDesc'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['structureDetailId'] = structureDetailId;
    data['groupCode'] = groupCode;
    data['revolving'] = revolving;
    data['editable'] = editable;
    data['check'] = check;
    data['level'] = level;
    data['sequence'] = sequence;
    data['groupCodeDesc'] = groupCodeDesc;
    data['lineCode'] = lineCode;
    data['lineCodeDesc'] = lineCodeDesc;
    return data;
  }
}

class ReturnStatus {
  String? returnCode;
  String? returnText;

  ReturnStatus({this.returnCode, this.returnText});

  ReturnStatus.fromJson(Map<String, dynamic> json) {
    returnCode = json['returnCode'];
    returnText = json['returnText'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['returnCode'] = returnCode;
    data['returnText'] = returnText;
    return data;
  }
}
