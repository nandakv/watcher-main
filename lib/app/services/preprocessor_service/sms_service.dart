import 'dart:convert';
import 'dart:io';

import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:amplify_storage_s3/amplify_storage_s3.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart' as pathProvider;
import 'package:privo/app/amplify/auth/amplify_auth.dart';
import 'package:privo/app/api/response_model.dart';
import 'package:privo/app/data/repository/on_boarding_repository/personal_detail_repository.dart';
import 'package:privo/app/data/repository/sms_repository.dart';
import 'package:privo/app/firebase/analytics.dart';
import 'package:privo/app/models/check_app_form_model.dart';
import 'package:privo/app/models/sms_model.dart';
import 'package:privo/app/modules/on_boarding/mixins/app_form_mixin.dart';
import 'package:privo/app/utils/error_logger_mixin.dart';
import 'package:privo/app/utils/strings.dart';

import '../../data/provider/auth_provider.dart';
import '../../data/repository/app_parameter_repository.dart';
import '../../models/app_parameter_model.dart';
import '../../utils/native_channels.dart';

class SmsService with ErrorLoggerMixin {
  final _smsRepository = SMSRepository();

  ///these below retries will count only in case of failure
  ///retry count for push to s3 api
  final int _intPushToS3MaxRetryCount = 3;
  int _pushToS3RetryCount = 0;

  ///get file size to log in case of error
  double _fileSizeInMB = 0;

  ///retry count for sending empty data
  final int _sendEmptyDataMaxReTries = 3;
  int _sendEmptyDataRetry = 0;

  ///retry count for file not found
  final int _fileNotFoundMaxTries = 5;
  int _fileNotFoundRetry = 0;

  Future<void> readStoreSms() async {
    List<dynamic> sms = await NativeFunctions().fetchSms().then((value) => value
        .where((element) => element["address"].toString().length < 13)
        .toList());
    // value.where((element) => element.address!.length < 13).toList();
    Get.log("sms length - ${sms.length}");
    AppAuthProvider.setRawSmsData(jsonEncode(sms));
  }

  Future<void> postSmsToBackend() async {
    String data = await AppAuthProvider.getRawSmsData;
    await _sendDataToBackend(data);
  }

  Future<void> _sendDataToBackend(String data) async {
    if (data.isEmpty || data == "[]") data = "{}";
    ApiResponse apiResponse =
        await PersonalDetailRepository().postSmsData({"raw_sms": data});
    switch (apiResponse.state) {
      case ResponseState.success:
        await AppAuthProvider.clearRawSmsData();
        break;
      default:
        AppAnalytics.logRawSmsApiFailure({"error": apiResponse.apiResponse});
        logError(
          exception: apiResponse.exception,
          url: apiResponse.url,
          statusCode: apiResponse.statusCode.toString(),
          requestBody: apiResponse.requestBody,
          responseBody: apiResponse.apiResponse,
        );
        break;
    }
  }

  Future<void> readStoreSmsV2(
      {String? fromDateTime, required bool isAPITrigger}) async {
    NativeFunctions()
        .startSmsFetch(fromDateTime: fromDateTime, isAPITrigger: isAPITrigger);
  }

  Future<File?> get _smsFile async {
    try {
      Directory directory = await pathProvider.getApplicationSupportDirectory();
      late File smsFile;
      smsFile = File("${directory.path}/$rawSMSFileName.json");
      if (!(await smsFile.exists())) {
        smsFile = File("${directory.path}/$rawSMSFileName.txt");
      }
      int fileLength = await smsFile.length();
      if (fileLength != 0) _fileSizeInMB = fileLength / (1024 * 1024);
      return smsFile;
    } catch (e) {
      logError(
        requestBody:
            "Exception While reading the file (or) computing the file size",
        exception: e.toString(),
      );
      return null;
    }
  }

  Future<bool> _smsFileExistsInStorage() async {
    return await (await _smsFile)?.exists() ?? false;
  }

  Future<void> postSmsToBackendV2() async {
    bool _isAppformEmpty = (await AppAuthProvider.appFormID).isEmpty;
    if ((await _smsFileExistsInStorage()) && !_isAppformEmpty) {
      String encodedSMSData = (await (await _smsFile)!.readAsString())
          .replaceAll(RegExp(r'\s+'), '');
      String decodedSMSData = utf8.decode(base64.decode(encodedSMSData));
      _sendDataToBackendV2(decodedSMSData);
    }
  }

  Future<void> _sendDataToBackendV2(String data) async {
    if (data.isNotEmpty && data != "[]") {
      ApiResponse apiResponse =
          await PersonalDetailRepository().postSmsData({"raw_sms": data});
      switch (apiResponse.state) {
        case ResponseState.success:
          await _deleteSMSFileFromInternalStorage();
          break;
        default:
          AppAnalytics.logRawSmsApiFailure({"error": apiResponse.apiResponse});
          logError(
            exception: apiResponse.exception,
            url: apiResponse.url,
            statusCode: apiResponse.statusCode.toString(),
            requestBody: apiResponse.requestBody,
            responseBody: apiResponse.apiResponse,
          );
          break;
      }
    }
  }

  Future<void> _deleteSMSFileFromInternalStorage() async {
    try {
      await (await _smsFile)?.delete();
    } catch (e) {
      AppAnalytics.logRawSmsFileDeleteFailure({"error": "$e"});
      logError(
        responseBody: "",
        requestBody: "Deleting Raw SMS File from internal Storage",
        statusCode: "",
        exception: "$e",
        url: "",
      );
    }
  }

  sendEmptyDataForSMSFailure({required bool isAPITriggered}) async {
    late ApiResponse apiResponse;
    if (isAPITriggered) {
      SMSModel smsModel = await _smsRepository.postSMSData({
        'raw_sms': "[]",
      });
      apiResponse = smsModel.apiResponse;
    } else {
      apiResponse = await _uploadSMSToS3Bucket("{}");
    }
    switch (apiResponse.state) {
      case ResponseState.success:

        ///sms process ends here
        break;
      default:
        logError(
          responseBody: apiResponse.apiResponse,
          requestBody: apiResponse.requestBody,
          statusCode: apiResponse.statusCode.toString(),
          exception: "retry count - $_sendEmptyDataRetry",
          url: apiResponse.url,
        );
        if (_sendEmptyDataRetry <= _sendEmptyDataMaxReTries) {
          _sendEmptyDataRetry++;
          await Future.delayed(const Duration(seconds: 3));
          sendEmptyDataForSMSFailure(isAPITriggered: isAPITriggered);
        }
    }
  }

  Future sendSMSDataToS3(
      {String? fromDateTime, required bool isAPITrigger}) async {
    if (await _smsFileExistsInStorage()) {
      String encodedSMSData = (await (await _smsFile)!.readAsString())
          .replaceAll(RegExp(r'\s+'), '');
      String decodedSMSData = utf8.decode(base64.decode(encodedSMSData));
      _logForEmptySMSData(decodedSMSData);

      late SMSModel smsModel;

      if (isAPITrigger) {
        smsModel =
            await _smsRepository.postSMSData({'raw_sms': decodedSMSData});
      } else {
        ApiResponse apiResponse = await _uploadSMSToS3Bucket(decodedSMSData);
        smsModel = SMSModel.fromJson(apiResponse);
      }

      Get.log("sms upload state - ${smsModel.apiResponse.state}");

      switch (smsModel.apiResponse.state) {
        case ResponseState.success:
          await _deleteSMSFileFromInternalStorage();
          break;
        default:
          _retrySMS(
            smsModel,
            fromDateTime: fromDateTime,
            isAPITrigger: isAPITrigger,
          );
      }
    } else {
      if (_fileNotFoundRetry <= _fileNotFoundMaxTries) {
        _fileNotFoundRetry++;
        NativeFunctions().startSmsFetch(
          fromDateTime: fromDateTime,
          isAPITrigger: isAPITrigger,
        );
      } else {
        sendEmptyDataForSMSFailure(isAPITriggered: isAPITrigger);
      }
    }
  }

  void _logForEmptySMSData(String decodedSMSData) {
    if (decodedSMSData == "[]") {
      logError(
        statusCode: "",
        responseBody: "",
        url: "",
        exception: "Device doesn't have any sms data",
        requestBody: "",
      );
    }
  }

  _retrySMS(SMSModel smsModel,
      {String? fromDateTime, required bool isAPITrigger}) async {
    if (_pushToS3RetryCount > 3) {
      logError(
        exception: smsModel.apiResponse.exception,
        url: smsModel.apiResponse.url,
        responseBody: smsModel.apiResponse.apiResponse,
        statusCode: smsModel.apiResponse.statusCode.toString(),
        requestBody:
            "fileSize - ${_fileSizeInMB.toStringAsFixed(2)} MB; retry count - $_pushToS3RetryCount",
      );
    }
    if (_pushToS3RetryCount <= _intPushToS3MaxRetryCount) {
      _pushToS3RetryCount++;
      await Future.delayed(const Duration(seconds: 3));
      sendSMSDataToS3(
        fromDateTime: fromDateTime,
        isAPITrigger: isAPITrigger,
      );
    } else {
      sendEmptyDataForSMSFailure(isAPITriggered: isAPITrigger);
    }
  }

  Future<ApiResponse> _uploadSMSToS3Bucket(String dataString) async {
    try {
      final result = await Amplify.Storage.uploadFile(
        localFile: AWSFile.fromData(JsonUtf8Encoder().convert(dataString)),
        path: StoragePath.fromString(
            'public/raw_sms/${await AmplifyAuth.userID}.json'),
        onProgress: (progress) {
          Get.log('Transferred bytes: ${progress.transferredBytes}');
        },
      ).result;

      Get.log('Uploaded data to location: ${result.uploadedItem.path}');
      return ApiResponse(
        state: ResponseState.success,
        statusCode: 200,
        url: "",
        apiResponse: """
        {"responseBody":{"raw_sms_s3_url" : "${result.uploadedItem.path}"}}
        """,
      );
    } on StorageException catch (e) {
      Get.log("Storage Exception - ${e.message}");
      Get.log("Storage Exception - ${e.recoverySuggestion}");
      return ApiResponse(
        state: ResponseState.failure,
        apiResponse: "",
        requestBody: "Direct Upload to s3 bucket",
        exception: "${e.message}.${e.recoverySuggestion}",
      );
    }
  }

  readSMSFlag({String? fromDateTime}) async {
    AppParameterModel appParameterModel =
        await AppParameterRepository().getAppParameters();
    switch (appParameterModel.apiResponse.state) {
      case ResponseState.success:
        if (appParameterModel.newMethod) {
          SmsService().readStoreSmsV2(
            isAPITrigger: false,
            fromDateTime: fromDateTime,
          );
        } else {
          SmsService().readStoreSmsV2(
            isAPITrigger: true,
            fromDateTime: fromDateTime,
          );
        }
        break;
      default:
        SmsService().readStoreSmsV2(
          isAPITrigger: true,
          fromDateTime: fromDateTime,
        );
        logError(
          statusCode: appParameterModel.apiResponse.statusCode.toString(),
          responseBody: appParameterModel.apiResponse.requestBody,
          requestBody: appParameterModel.apiResponse.requestBody,
          exception: appParameterModel.apiResponse.exception,
          url: appParameterModel.apiResponse.url,
        );
    }
  }
}
