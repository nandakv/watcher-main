

import 'dart:convert';
import 'package:get/get.dart';

AppPermissionsResponseModel? appPermissionsResponseModelFromJson(String? str) {
  try {
    return AppPermissionsResponseModel.fromJson(json.decode(str!));
  } on Exception catch (e) {
    Get.log(e.toString());
    return null;
  }
}

class AppPermissionsResponseModel {
  AppPermissionsResponseModel({
    required this.id,
    required this.location,
    required this.camera,
    required this.storage,
    required this.sms,
    required this.phone,
    required this.contacts,
  });
  late final int id;
  late final bool location;
  late final bool camera;
  late final bool storage;
  late final bool sms;
  late final bool phone;
  late final bool contacts;

  AppPermissionsResponseModel.fromJson(Map<String, dynamic> json){
    id = json['id'] ?? 0;
    location = json['location'] ?? false;
    camera = json['camera'] ?? false;
    storage = json['storage'] ?? false;
    sms = json['sms'] ?? false;
    phone = json['phone'] ?? false;
    contacts = json['contacts'] ?? false;
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['location'] = location;
    _data['camera'] = camera;
    _data['storage'] = storage;
    _data['sms'] = sms;
    _data['phone'] = phone;
    _data['contacts'] = contacts;
    return _data;
  }
}