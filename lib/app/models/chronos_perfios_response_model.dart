import 'dart:convert';
import 'package:get/get.dart';

ChronosPerfiosResponseModel? chronosPerfiosResponseModelFromJson(String? str) {
  try {
    return ChronosPerfiosResponseModel.fromJson(json.decode(str!));
  } on Exception catch (e) {
    Get.log(e.toString());
    return null;
  }
}


class ChronosPerfiosResponseModel {
  ChronosPerfiosResponseModel({
    required this.count,
    required this.pageNumber,
    required this.pageSize,
    required this.result,
  });
  late final Count count;
  late final int pageNumber;
  late final int pageSize;
  late final List<Result> result;

  ChronosPerfiosResponseModel.fromJson(Map<String, dynamic> json){
    count = Count.fromJson(json['count']);
    pageNumber = json['pageNumber'];
    pageSize = json['pageSize'];
    result = List.from(json['result']).map((e)=>Result.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['count'] = count.toJson();
    _data['pageNumber'] = pageNumber;
    _data['pageSize'] = pageSize;
    _data['result'] = result.map((e)=>e.toJson()).toList();
    return _data;
  }
}

class Count {
  Count({
    required this.value,
    required this.relation,
  });
  late final int value;
  late final String relation;

  Count.fromJson(Map<String, dynamic> json){
    value = json['value'];
    relation = json['relation'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['value'] = value;
    _data['relation'] = relation;
    return _data;
  }
}

class Result {
  Result({
    required this.id,
    required this.type,
    required this.priority,
    required this.entityType,
    required this.entityId,
    required this.batchId,
    required this.partnerLoanId,
    required this.partnerId,
    required this.customerId,
    required this.workflowId,
    required this.status,
    required this.description,
    required this.timeStamp,
    required this.meta,

    required this.userId,
    required this.reason,
    required this.stage,
    required this.auditLog,
  });
  late final String id;
  late final String type;
  late final String priority;
  late final String entityType;
  late final String entityId;
  late final String batchId;
  late final String partnerLoanId;
  late final String partnerId;
  late final String customerId;
  late final String workflowId;
  late final String status;
  late final String description;
  late final String timeStamp;
  late final Meta meta;
  // late final Data data;
  late final String userId;
  late final String reason;
  late final String stage;
  late final String auditLog;

  Result.fromJson(Map<String, dynamic> json){
    id = json['id'];
    type = json['type'];
    priority = json['priority'];
    entityType = json['entityType'];
    entityId = json['entityId'];
    batchId = json['batchId'];
    partnerLoanId = json['partnerLoanId'];
    partnerId = json['partnerId'];
    customerId = json['customerId'];
    workflowId = json['workflowId'];
    status = json['status'];
    description = json['description'];
    timeStamp = json['timeStamp'];
    meta = Meta.fromJson(json['meta']);
    // data = Data.fromJson(json['data']);
    userId = json['userId'];
    reason = json['reason'];
    stage = json['stage'];
    auditLog = json['auditLog'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['type'] = type;
    _data['priority'] = priority;
    _data['entityType'] = entityType;
    _data['entityId'] = entityId;
    _data['batchId'] = batchId;
    _data['partnerLoanId'] = partnerLoanId;
    _data['partnerId'] = partnerId;
    _data['customerId'] = customerId;
    _data['workflowId'] = workflowId;
    _data['status'] = status;
    _data['description'] = description;
    _data['timeStamp'] = timeStamp;
    _data['meta'] = meta.toJson();
    // _data['data'] = data.toJson();
    _data['userId'] = userId;
    _data['reason'] = reason;
    _data['stage'] = stage;
    _data['auditLog'] = auditLog;
    return _data;
  }
}

class Meta {
  Meta({
    required this.origin,
  });
  late final String origin;

  Meta.fromJson(Map<String, dynamic> json){
    origin = json['origin'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['origin'] = origin;
    return _data;
  }
}

class Data {
  Data({
    this.sample
}
  );
late final String? sample;
Data.fromJson(
Map<String, dynamic> json
){
}

Map<String, dynamic> toJson() {
  final _data = <String, dynamic>{};
  return _data;
}}