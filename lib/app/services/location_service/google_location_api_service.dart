import 'dart:convert';
import 'dart:ffi';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:privo/app/api/response_model.dart';
import 'package:privo/app/data/provider/auth_provider.dart';
import 'package:privo/app/data/repository/google_location_repository.dart';
import 'package:privo/app/firebase/analytics.dart';
import 'package:privo/app/utils/error_logger_mixin.dart';
import 'package:another_telephony/telephony.dart';

class GoogleLocationApiService with ErrorLoggerMixin {
  int _retryCount = 0;
  int MAX_RETRY_COUNT = 3;

  bool considerIp;
  final Function() onLocationStatusCallback;

  GoogleLocationApiService(
      {this.considerIp = true, required this.onLocationStatusCallback});

  fetchLocation() async {
    ApiResponse apiResponse = await GoogleLocationRepository()
        .fetchLocationCoOrdinates(body: await computeMobileConnectivityType());
    switch (apiResponse.state) {
      case ResponseState.success:
        await _onFetchGoogleLocationSuccess(apiResponse);
        break;
      default:
        _onLocationNotFetched(apiResponse);
        break;
    }
  }

  _onLocationNotFetched(ApiResponse apiResponse) async {
    _retryCount++;
    if (_retryCount >= MAX_RETRY_COUNT) {
      logError(
        statusCode: apiResponse.statusCode.toString(),
        responseBody: apiResponse.apiResponse,
        requestBody: apiResponse.requestBody,
        exception: apiResponse.exception,
        url: apiResponse.url,
      );
      onLocationStatusCallback();
    } else {
      await fetchLocation();
    }
  }

  _onFetchGoogleLocationSuccess(ApiResponse apiResponse) async {
    Map<String, dynamic> jsonMap = json.decode(apiResponse.apiResponse);
    if (jsonMap["location"] != null &&
        jsonMap["location"]["lat"] != null &&
        jsonMap["location"]["lng"] != null) {
      await _onLocationDataAvailable(jsonMap, apiResponse);
    } else {
      await _onLocationNotFetched(apiResponse);
    }
  }

  Future<void> _onLocationDataAvailable(
      Map<String, dynamic> jsonMap, ApiResponse apiResponse) async {
    ApiResponse addressFromCoOrdinates = await GoogleLocationRepository()
        .fetchAddressDetailsFromCoOrdinates(
            latLong:
                "${jsonMap["location"]["lat"]},${jsonMap["location"]["lng"]}");
    switch (addressFromCoOrdinates.state) {
      case ResponseState.success:
        Map<String, dynamic> addressMap =
            json.decode(addressFromCoOrdinates.apiResponse);
        await AppAuthProvider.setUserGoogleLocation(jsonEncode(addressMap));
        onLocationStatusCallback();
        break;
      default:
        _onLocationNotFetched(apiResponse);
        break;
    }
  }

  computeMobileConnectivityType() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      return computeMobilenetworkInfo();
    } else {
      return {"considerIp": considerIp};
    }
  }

  computeMobilenetworkInfo() async {
    try {
      Telephony telephonyInfo = Telephony.instance;
      String? simOperator = await telephonyInfo.simOperator;
      if (simOperator != null) {
        String mcc = simOperator.substring(0, 3);
        String mnc = simOperator.substring(3, simOperator.length);
        Map body = {
          "homeMobileCountryCode": mcc,
          "homeMobileNetworkCode": mnc,
          "radioType": "gsm",
          "carrier": await telephonyInfo.simOperatorName,
          "considerIp": considerIp
        };
        return body;
      }
    } on Exception catch (e) {
      _retryCount++;
      if (_retryCount > MAX_RETRY_COUNT) {
        AppAnalytics.logGoogleLocationFetchFailure({"exception": "$e"});
        logError(
          url: "",
          exception: e.toString(),
          requestBody: "Exception occurred while Fetching google location",
          responseBody: "",
          statusCode: "",
        );
        return {};
      } else {
        computeMobileConnectivityType();
      }
    }
  }
}
