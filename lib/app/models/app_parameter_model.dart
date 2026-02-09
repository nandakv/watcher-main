import 'dart:convert';

import 'package:intl/intl.dart';
import 'package:privo/app/api/response_model.dart';

import '../data/provider/auth_provider.dart';

class AppParameterModel {
  late bool newMethod;
  late String minimumVersion;
  late ApiResponse apiResponse;
  late bool isFineLocation;
  late bool isLowEnvDigioMockEnabled;
  late bool isEnableWithdrawLocation;
  late int locationRetryTimer;
  late int locationRetryCount;
  late String employmentType;
  late String deviceIpAddress;
  late bool disableUpiBankTransfer;
  late VKYCAvailabilityModel vkycAvailability;
  late bool googleLocationEnabled;
  late bool screenProtectionEnabled;
  late bool isReportIssueEnabled;
  late bool isEmulatorCheckEnabled;
  late bool isDebugCheckEnabled;
  late bool isMagiskCheckEnabled;
  late bool isFridaCheckEnabled;
  late int? deviceDetailsRefreshWindowTime;

  int _defaultLocationTime = 10;
  int _defaultLocationRetryCount = 2;

  AppParameterModel.fromJson(ApiResponse apiResponse) {
    switch (apiResponse.state) {
      case ResponseState.success:
        try {
          Map<String, dynamic> jsonMap = json.decode(apiResponse.apiResponse);
          _parseJson(jsonMap);
          this.apiResponse = apiResponse;
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

  void _parseJson(Map<String, dynamic> jsonMap) {
    newMethod = jsonMap['parameter_raw_sms'] == null
        ? false
        : jsonMap['parameter_raw_sms'].toLowerCase() == 'TRUE'.toLowerCase();
    minimumVersion = jsonMap['parameter_app_version'] ?? "";
    employmentType =
        jsonMap['ui_preselected']['work_details']['employment_type'] ?? "";
    isFineLocation = jsonMap['parameter_fine_location'] == null
        ? false
        : jsonMap['parameter_fine_location'].toLowerCase() ==
            'TRUE'.toLowerCase();
    isLowEnvDigioMockEnabled = jsonMap['parameter_digio_mock_low_env'] == null
        ? false
        : jsonMap['parameter_digio_mock_low_env'].toLowerCase() ==
            'TRUE'.toLowerCase();
    isEnableWithdrawLocation =
        jsonMap['parameter_enable_withdraw_location'] == null
            ? false
            : jsonMap['parameter_enable_withdraw_location'].toLowerCase() ==
                'TRUE'.toLowerCase();
    locationRetryTimer =
        jsonMap['location_retry_timer'] ?? _defaultLocationTime;

    locationRetryCount =
        jsonMap['location_retry_count'] ?? _defaultLocationRetryCount;

    disableUpiBankTransfer = jsonMap['disable_upi_bank_transfer'] == null
        ? false
        : jsonMap['disable_upi_bank_transfer'].toLowerCase() ==
            'TRUE'.toLowerCase();

    deviceIpAddress = jsonMap['device_ip_address'] ?? "";

    vkycAvailability =
        VKYCAvailabilityModel.fromJson(jsonMap['vkyc_availablity']);

    googleLocationEnabled = jsonMap['googleLocationEnabled'] == null
        ? false
        : jsonMap['googleLocationEnabled'].toLowerCase() ==
            'TRUE'.toLowerCase();

    screenProtectionEnabled = jsonMap['screen_protection_enabled'] == null
        ? false
        : jsonMap['screen_protection_enabled'].toLowerCase() ==
            'TRUE'.toLowerCase();

    isReportIssueEnabled = jsonMap['report_issue_enabled'] == null
        ? false
        : jsonMap['report_issue_enabled'].toLowerCase() == 'TRUE'.toLowerCase();

    isEmulatorCheckEnabled = jsonMap['emulator_check_enabled'] == null
        ? false
        : jsonMap['emulator_check_enabled'].toLowerCase() ==
            'TRUE'.toLowerCase();

    isDebugCheckEnabled = jsonMap['debug_check_enabled'] == null
        ? false
        : jsonMap['debug_check_enabled'].toLowerCase() == 'TRUE'.toLowerCase();

    isMagiskCheckEnabled = jsonMap['magisk_check_enabled'] == null
        ? false
        : jsonMap['magisk_check_enabled'].toLowerCase() == 'TRUE'.toLowerCase();

    isFridaCheckEnabled = jsonMap['frida_check_enabled'] == null
        ? false
        : jsonMap['frida_check_enabled'].toLowerCase() == 'TRUE'.toLowerCase();

    deviceDetailsRefreshWindowTime =
        jsonMap['device_details_refresh_window_time'] == null
            ? null
            : int.tryParse(
                    jsonMap['device_details_refresh_window_time'].toString());

    AppAuthProvider().setDeviceDetailsRefreshWindow(deviceDetailsRefreshWindowTime);
    AppAuthProvider.setIdAddress(deviceIpAddress);
  }
}

class VKYCAvailabilityModel {
  late bool enabled;
  late String fromTime;
  late String toTime;

  VKYCAvailabilityModel.fromJson(Map<String, dynamic> jsonMap) {
    final inputFormat = DateFormat.Hm();
    final outputFormat = DateFormat.jm();
    final rawFromTime = inputFormat.parse(jsonMap['from_time']);
    final rawToTime = inputFormat.parse(jsonMap['to_time']);
    enabled = jsonMap['enabled'];
    fromTime = outputFormat.format(rawFromTime);
    toTime = outputFormat.format(rawToTime);
  }
}
