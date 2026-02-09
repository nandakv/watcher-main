import 'package:privo/app/models/security_check/security_type_result_model.dart';

enum SecurityIssueType {
  emulator(
    message: "Running on an Emulator",
    description:
        "The app is running on an emulated environment, which may pose security risks.",
    resolution: "Use a physical device for better security.",
    methodName: "emulator_check",
    eventName: "Emulator_check",
  ),
  rooted(
    message: "Device is Rooted",
    description:
        "The device has root access, which can bypass security mechanisms and expose sensitive data.",
    resolution:
        "Unroot the device or use a non-rooted device for better security.",
    methodName: "root_checker",
    eventName: "Root_check",
  ),
  magisk(
    message: "Device is Rooted",
    description:
        "The device has root access, which can bypass security mechanisms and expose sensitive data.",
    resolution:
        "Unroot the device or use a non-rooted device for better security.",
    methodName: "magisk_check",
    eventName: "Magisk_check",
  ),
  frida(
    message: "Device is Rooted",
    description:
        "The device has root access, which can bypass security mechanisms and expose sensitive data.",
    resolution:
        "Unroot the device or use a non-rooted device for better security.",
    methodName: "frida_check",
    eventName: "Frida_check",
  ),
  debugging(
    message: "USB Debugging Enabled",
    description:
        "USB Debugging is enabled, which allows ADB access and can expose the app to security threats.",
    resolution:
        "Go to Settings > Developer Options > USB Debugging > Disable it.",
    methodName: "debug_check",
    eventName: "Debug_check",
  ),
  none(
    message: "",
    description: "",
    resolution: "",
    methodName: "",
    eventName: "",
  );

  static SecurityIssueType fromString(String methodName) {
    Map<String, SecurityIssueType> map = {
      SecurityIssueType.emulator.methodName: SecurityIssueType.emulator,
      SecurityIssueType.rooted.methodName: SecurityIssueType.rooted,
      SecurityIssueType.magisk.methodName: SecurityIssueType.magisk,
      SecurityIssueType.frida.methodName: SecurityIssueType.frida,
      SecurityIssueType.debugging.methodName: SecurityIssueType.debugging,
    };

    return map[methodName] ?? SecurityIssueType.none;
  }

  const SecurityIssueType({
    required this.message,
    required this.description,
    required this.resolution,
    required this.methodName,
    required this.eventName,
  });

  final String message;
  final String description;
  final String resolution;
  final String methodName;
  final String eventName;
}

class SecurityCheckModel {
  Map<SecurityIssueType, SecurityTypeResultModel> securityResult = {};
  SecurityIssueType? displayIssueType;

  SecurityCheckModel({required this.securityResult, this.displayIssueType});

  SecurityCheckModel.fromJson(Map json) {
    Map<SecurityIssueType, SecurityTypeResultModel> result = {};
    json.forEach((key, value) {
      SecurityIssueType type = SecurityIssueType.fromString(key);
      if (type != SecurityIssueType.none) {
        result[type] = SecurityTypeResultModel.fromJson(value);
      }
    });
    displayIssueType =
        SecurityIssueType.fromString(json['security_display_type']);
    securityResult = result;
  }
}
