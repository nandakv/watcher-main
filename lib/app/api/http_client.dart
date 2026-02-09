import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:datadog_flutter_plugin/datadog_flutter_plugin.dart';
import 'package:datadog_tracking_http_client/datadog_tracking_http_client.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';

import '../../flavors.dart';
import '../amplify/auth/amplify_auth.dart';
import 'response_model.dart';

final httpClient = http.Client();
final datadogClient =
    DatadogClient(datadogSdk: DatadogSdk.instance, innerClient: httpClient);

enum AuthType { token, scrooge, karza, smsgupshup, digio, none }

class HttpClient {
  static Future<Map<String, String>> _header(AuthType? headers) async {
    switch (headers) {
      case AuthType.token:
        return {
          "Authorization": "Bearer ${await AmplifyAuth().getJWT()}",
          "Content-Type": "application/json",
          "Source-App": _computeSourceApp(),
        };
      case AuthType.scrooge:
        return {
          'Service-Provider': 'RAZOR_PAY',
          'Authorization': 'Basic QGRNMU46UEAkJFcwckQ=',
          'Content-Type': 'application/json',
        };
      case AuthType.karza:
        return {
          "Accept": "*/*",
          "content-type": "application/json",
          "x-karza-key": F.envVariables.karzaKeys.karzaKey
        };
      case AuthType.smsgupshup:
        return {
          "Accept": "*/*",
          "content-type": "application/json",
        };
      case AuthType.digio:
        String credentials =
            "${F.envVariables.digiLockerCreds.clientID}:${F.envVariables.digiLockerCreds.clientSecret}";
        Codec<String, String> stringToBase64 = utf8.fuse(base64);
        String encoded = stringToBase64.encode(credentials);
        return {
          "authorization": "Basic $encoded",
          "content-type": "application/json",
        };
      case AuthType.none:
        return {};
      default:
        return {
          "Authorization": "Bearer ${await AmplifyAuth().getJWT()}",
          "Content-Type": "application/json",
          "Source-App": _computeSourceApp(),
        };
    }
  }

  static String _computeSourceApp() {
    if (Platform.isAndroid) return "android";
    return "ios";
  }

  static Future<ApiResponse> get({
    required String url,
    AuthType? authType,
  }) async {
    try {
      Get.log("Get Request");
      Get.log("URL - $url");
      Get.log("header - ${await _header(authType)}");

      http.Response res = await datadogClient.get(
        Uri.parse(url),
        headers: await _header(authType),
      );

      Get.log("Status Code - ${res.statusCode} of ${url.split('/').last}");
      Get.log("response - ${res.body}");
      switch (res.statusCode) {
        case 302:
        case 307:
          return _computeApiResponseLocationHeader(res, {});
        default:
          return _computeSuccessResponse(res, {});
      }
    } catch (exception) {
      return _computeException(exception, url: url);
    }
  }

  static Future<ApiResponse> delete({
    required String url,
    AuthType? authType,
  }) async {
    try {
      Get.log("Delete Request");
      Get.log("URL - $url");
      Get.log("header - ${await _header(authType)}");

      http.Response res = await datadogClient.delete(
        Uri.parse(url),
        headers: await _header(authType),
      );

      // TODO: have scope for below code to reuse
      Get.log("Status Code - ${res.statusCode} of ${url.split('/').last}");
      Get.log("response - ${res.body}");
      switch (res.statusCode) {
        case 302:
        case 307:
          return _computeApiResponseLocationHeader(res, {});
        default:
          return _computeSuccessResponse(res, {});
      }
    } catch (exception) {
      return _computeException(exception, url: url);
    }
  }

  static Future<ApiResponse> post({
    required String url,
    Map<dynamic, dynamic>? body,
    AuthType? authType,
  }) async {
    try {
      Get.log("Post Request");
      Get.log("URL - $url");
      Get.log("Body - ${jsonEncode(body)}");
      http.Response res = await datadogClient.post(
        Uri.parse(url),
        body: jsonEncode(body),
        headers: await _header(authType),
      );
      Get.log("Status Code - ${res.statusCode} of ${url.split('/').last}");
      Get.log("response - ${res.body}");
      switch (res.statusCode) {
        case 302:
        case 307:
          return _computeApiResponseLocationHeader(res, body ?? {});
        default:
          return _computeSuccessResponse(res, body ?? {});
      }
    } catch (e) {
      Get.log('http request error - $e', isError: true);
      return _computeException(e, url: url, body: body);
    }
  }

  static Future<ApiResponse> put({
    required String url,
    Map<dynamic, dynamic>? body,
    AuthType? authType,
  }) async {
    Get.log("PUT Request");
    Get.log("URL - $url");
    Get.log("Body - ${jsonEncode(body)}");
    Get.log("header - ${await _header(authType)}");

    try {
      http.Response res = await datadogClient.put(
        Uri.parse(url),
        body: jsonEncode(body),
        headers: await _header(authType),
      );

      Get.log("Status Code - ${res.statusCode} of ${url.split('/').last}");
      Get.log("response - ${res.body}");

      switch (res.statusCode) {
        case 302:
        case 307:
          return _computeApiResponseLocationHeader(res, body ?? {});
        default:
          return _computeSuccessResponse(res, body ?? {});
      }
    } catch (exception) {
      return _computeException(exception, url: url, body: body);
    }
  }

  static Future<ApiResponse> _computeApiResponseLocationHeader(
      http.Response res, Map requestBody) async {
    try {
      final http.Response response =
          await http.get(Uri.parse(res.headers['location']!));
      return _computeSuccessResponse(response, requestBody);
    } catch (e) {
      Get.log('http request error - $e', isError: true);
      return ApiResponse(
        state: ResponseState.failure,
        apiResponse: "Error - $e",
        url: Uri.parse(res.headers['location']!).path,
        statusCode: res.statusCode,
        requestBody: jsonEncode(requestBody),
      );
    }
  }

  static ApiResponse _computeSuccessResponse(
      http.Response res, Map requestBody) {
    switch (res.statusCode) {
      case 200:
      case 201:
        return _computeApiResponse(res, ResponseState.success, requestBody);
      case 400:
        return _computeApiResponse(
            res, ResponseState.badRequestError, requestBody);
      case 401:
      case 403:
        return _computeApiResponse(
            res, ResponseState.notAuthorized, requestBody);
      default:
        return _computeApiResponse(res, ResponseState.failure, requestBody);
    }
  }

  static ApiResponse _computeApiResponse(
    http.Response res,
    ResponseState responseState,
    Map requestBody,
  ) {
    return ApiResponse(
      state: responseState,
      apiResponse: utf8.decode(
        res.bodyBytes,
      ),
      requestBody: jsonEncode(requestBody),
      statusCode: res.statusCode,
      url: res.request!.url.path,
    );
  }

  static ApiResponse _computeException(
    Object exception, {
    String? url,
    Map<dynamic, dynamic>? body,
  }) {
    switch (exception.runtimeType) {
      case SocketException:
        Get.log("SocketException");
        return ApiResponse(
            url: url,
            requestBody: jsonEncode(body ?? ""),
            state: ResponseState.noInternet,
            exception: "SocketException - $exception",
            apiResponse: "SocketException - $exception");
      case http.ClientException:
        Get.log('http.ClientException - $exception', isError: true);
        return ApiResponse(
            url: url,
            requestBody: jsonEncode(body ?? ""),
            state: ResponseState.failure,
            exception: "ClientException - $exception",
            apiResponse: "ClientException - $exception");
      case TimeoutException:
        Get.log('timeout - $exception', isError: true);
        return ApiResponse(
            url: url,
            requestBody: jsonEncode(body ?? ""),
            state: ResponseState.timedOut,
            exception: "TimeOutException - $exception",
            apiResponse: "TimeOutException - $exception");
      default:
        Get.log('http request error - $exception', isError: true);
        return ApiResponse(
            url: url,
            requestBody: jsonEncode(body ?? ""),
            state: ResponseState.failure,
            exception: "Execption - $exception",
            apiResponse: "Execption - $exception");
    }
  }
}
