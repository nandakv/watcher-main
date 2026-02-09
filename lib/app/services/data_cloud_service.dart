import 'package:flutter/services.dart';
import 'package:get/get.dart';

class DataCloudService {
  static final DataCloudService _instance = DataCloudService._internal();
  static const MethodChannel _dataCloudChannel = MethodChannel("data_cloud");

  factory DataCloudService() => _instance;

  DataCloudService._internal();


  Future<void> login({required String phoneNumber}) async {
    try {
      var result = await _dataCloudChannel.invokeMethod("login", {
        "phone_number": phoneNumber,
      });
      Get.log("Data Cloud login result = $result");
    } catch (e) {
      Get.log("Error in login Data Cloud: $e");
    }
  }

  Future<void> logout() async {
    try {
      var result = await _dataCloudChannel.invokeMethod("logout");
      Get.log("Data Cloud logout result = $result");
    } catch (e) {
      Get.log("Error in logout Data Cloud: $e");
    }
  }

  Future<void> setUserAttributes({
    required String attributeName,
    required String attributeValue,
  }) async {
    try {
      var result = await _dataCloudChannel.invokeMethod("set_user_attribute", {
        "attributeName": attributeName,
        "attributeValue": attributeValue,
      });
      Get.log("Data Cloud set attributes result = $result");
    } catch (e) {
      Get.log("Error in user attributes Data Cloud: $e");
    }
  }

  Future<void> trackEvent({
    required String eventName,
    Map<String, dynamic>? attributes,
  }) async {
    try {
      var result = await _dataCloudChannel.invokeMethod(
        "track_event",
        {
          "event_name": eventName,
          "attributes": attributes ?? {},
        },
      );
      Get.log("Data Cloud track event result = $result");
    } catch (e) {
      Get.log("Error in tracking event: $e");
    }
  }
}
