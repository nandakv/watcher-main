import 'package:privo/flavors.dart';

class SequenceEngineModel {
  late String appState;
  late String appStage;
  late OnSubmit? onSubmit;
  late String onError;
  late String onReject;
  late OnPolling? onPolling;
  late String httpSubmitUrl;
  late String httpRequestMethod;
  late String screenType;

  SequenceEngineModel(
      {required this.appState,
      required this.appStage,
      required this.onSubmit,
      required this.onError,
      required this.screenType,
      required this.onReject});

  SequenceEngineModel.fromJson(Map<String, dynamic> json) {
    appState = json['app_state'];
    appStage = json['app_stage'];
    onSubmit =
        json['on_submit'] != null ? OnSubmit.fromJson(json['on_submit']) : null;
    onError = json['on_error'];
    onReject = json['on_reject'];
    onPolling = json['on_polling'] != null
        ? OnPolling.fromJson(json['on_polling'])
        : null;
    screenType = json['screen_type'] ?? "";
    httpSubmitUrl = _getRequestUrl();
    httpRequestMethod = _computeMethodFromSequenceEngine();
  }

  String _getRequestUrl() {
    if (onSubmit != null) {
      return onSubmit!.requestUrl;
    } else if (onPolling != null) {
      return onPolling!.requestUrl;
    }
    return '';
  }

  String _computeMethodFromSequenceEngine() {
    if (onSubmit != null) {
      return onSubmit!.requestType;
    } else if (onPolling != null) {
      return onPolling!.requestType;
    }
    return '';
  }
}

class OnSubmit {
  late String requestUrl;
  late String requestType;

  OnSubmit({required this.requestUrl, required this.requestType});

  OnSubmit.fromJson(Map<String, dynamic> json) {
    requestUrl = F.envVariables.privoBaseURL + json['request_url'];
    requestType = json['request_type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['request_url'] = requestUrl;
    data['request_type'] = requestType;
    return data;
  }
}

class OnPolling {
  late String requestUrl;
  late String requestType;
  late int callFrequency;
  late int? maxCalls;
  late Map<String, dynamic> requestPayload;

  OnPolling(
      {required this.requestUrl,
      required this.requestType,
      required this.callFrequency,
      required this.maxCalls,
      required this.requestPayload});

  OnPolling.fromJson(Map<String, dynamic> json) {
    requestUrl = F.envVariables.privoBaseURL + json['request_url'];
    requestType = json['request_type'];
    callFrequency = json['call_frequency'];
    requestPayload = json['request_payload'];
    maxCalls = json['max_calls'];
  }
}
