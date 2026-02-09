import 'dart:io';
import 'package:dart_ipify/dart_ipify.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'native_channels.dart';

class AdditionalDeviceDetailsMixin {
  Future<Map<String, String>> getDeviceDetails() async {
    String deviceModel = "";
    String deviceManufacturer = "";
    if (Platform.isAndroid) {
      var androidInfo = await DeviceInfoPlugin().androidInfo;
      deviceModel = androidInfo.model;
      deviceManufacturer = androidInfo.manufacturer;
    }

    return {"manufacturer": deviceManufacturer, "model": deviceModel};
  }

  Future<String> getOsVersion() async {
    String osVersion = "";
    if (Platform.isAndroid) {
      var androidInfo = await DeviceInfoPlugin().androidInfo;
      osVersion = androidInfo.version.release.toString();
    }

    return osVersion;
  }

  Future<String> getIPv4() async {
    return await Ipify.ipv4();
  }

  Future<Map<String, String>> getCarrierDetails() async {
    Map<String, String> carrierDetails =
        await NativeFunctions().getCarrierDetails();

    return {
      "sim1": carrierDetails["primarySim"] ?? "",
      "sim2": carrierDetails["secondarySim"] ?? ""
    };
  }
}
