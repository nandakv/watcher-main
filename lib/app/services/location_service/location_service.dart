import 'dart:async';
import 'dart:convert';

import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:privo/app/amplify/auth/amplify_auth.dart';
import 'package:privo/app/api/response_model.dart';
import 'package:privo/app/data/provider/auth_provider.dart';
import 'package:privo/app/data/repository/app_parameter_repository.dart';
import 'package:privo/app/firebase/analytics.dart';
import 'package:privo/app/mixin/location_service_mixin.dart';
import 'package:privo/app/models/app_parameter_model.dart';
import 'package:privo/app/models/home_screen_model.dart';
import 'package:privo/app/modules/on_boarding/mixins/app_form_mixin.dart';
import 'package:privo/app/services/location_service/google_location_api_service.dart';
import 'package:privo/app/services/lpc_service.dart';
import 'package:privo/app/utils/app_functions.dart';
import 'package:privo/app/utils/error_logger_mixin.dart';
import 'package:privo/app/utils/native_channels.dart';

enum LocationStatusType {
  noPermission,
  locationDisabled,
  locationNotFound,
  retry,
  technicalError,
  permissionAndLocationEnabled
}

enum LocationFailedStatus {
  permissionDenied,
  gpsDisabled,
  gpsEnabledPermissionDenied,
  gpsDeniedPermissionEnabled,
}

class LocationService with ErrorLoggerMixin, LocationServiceMixin {
  final Function() onLocationFetchSuccessful;
  Function(LocationStatusType) onLocationStatus;

  int _retryCount = 0;
  int MAX_RETRY_COUNT = 3;

  int locationRetryCount;

  int defaultLocationTimer;

  LoanProductCode loanProductCode;

  LocationService({
    required this.onLocationFetchSuccessful,
    required this.onLocationStatus,
    this.locationRetryCount = 2,
    this.loanProductCode = LoanProductCode.clp,
    this.defaultLocationTimer = 10,
  });

  fetchLocation() => _startLocationFetch();

  Timer? _locationTimer;
  StreamSubscription? _locationSubscription;

  Future<void> _onLocationNotRetreviedPostTimer() async {
    _retryCount++;
    var result = await _onLocationResultNull();
    if (result != null && result) {
      onLocationStatus(LocationStatusType.locationNotFound);
      disposeLocationService();
    }
    _logLocationFetchFailure();
  }

  Future<void> _readLocation() async {
    //First we need to start stream listerner
    if(_retryCount >= MAX_RETRY_COUNT){
      _locationTimer?.cancel();
      if(loanProductCode == LoanProductCode.clp){
        await GoogleLocationApiService(considerIp: true,onLocationStatusCallback: onLocationFetchSuccessful).fetchLocation();
      }
      else{
        onLocationFetchSuccessful();
      }

    }
    else {
      _startListeningToLocationStatus();
      var locationFetchResultNative = await NativeFunctions().startLocationFetch(
          fetchLastKnownLocation:
          _retryCount > locationRetryCount ? true : false);
      _closeDialog();
      if (locationFetchResultNative != null) {
        _onLocationResultNotNull(locationFetchResultNative);
      } else {
        _onLocationResultNull();
      }
    }
  }

  void _closeDialog() {
    if (Get.isDialogOpen != null && Get.isDialogOpen!) {
      Get.back();
    }
  }

  void _onLocationResultNotNull(startLocationFetchResult) {
    Get.log("Location fetch result ${startLocationFetchResult.toString()}");
    if (startLocationFetchResult["isError"] != null &&
        startLocationFetchResult["isError"] == true) {
      if (startLocationFetchResult["errorMessage"] == "LOCATION_DISABLED") {
        _logLocationFetchFailure();
        onLocationStatus(LocationStatusType.locationDisabled);
        _locationTimer?.cancel();
      } else {
        _locationSubscription?.cancel();
        _retryCount++;
        _startLocationFetch();
      }
    }
  }

  Future<dynamic> _onLocationResultNull() async {
    AppAnalytics.trackWebEngageEventWithAttribute(
      eventName: "Location Retry Dialog shown to the user",
    );
    if (onLocationStatus == null) {
      return true;
    }

    return await onLocationStatus.call(
      LocationStatusType.retry,
    );
  }

  _startListeningToLocationStatus() {
    _locationSubscription = NativeFunctions().getLocationStream().listen(
      (event) async {
        Get.log("Event is ${event.toString()}");

        if (event["latitude"] != null) {
          await AppAuthProvider.setUserLocationData(jsonEncode(event));
          Get.closeAllSnackbars();
          disposeLocationService();
          onLocationFetchSuccessful();
        }
      },
    );
  }

  Future<void> _startLocationFetch() async {
    bool _isLocationEnabled = await isLocationEnabled();
    bool _checkIfPermissionGranted = await checkAndRequestLocationPermission();
    LocationFailedStatus? locationFailedStatus = _computeLocationFailedStatus(
        _isLocationEnabled, _checkIfPermissionGranted);
    switch (locationFailedStatus) {
      case LocationFailedStatus.permissionDenied:
      case LocationFailedStatus.gpsEnabledPermissionDenied:
        _logLocationPermissionDenied();
        onLocationStatus(LocationStatusType.noPermission);
        break;
      case LocationFailedStatus.gpsDisabled:
      case LocationFailedStatus.gpsDeniedPermissionEnabled:
        _logLocationFetchFailure();
        onLocationStatus(LocationStatusType.locationDisabled);
        break;

      ///this is a success case
      default:
        onLocationStatus(LocationStatusType.permissionAndLocationEnabled);
        await _startReadingLocation();
    }
  }

  LocationFailedStatus? _computeLocationFailedStatus(
      bool isLocationEnabled, bool checkIfPermissionGranted) {
    if (!isLocationEnabled) {
      return LocationFailedStatus.gpsDisabled;
    }
    if (!checkIfPermissionGranted) {
      return LocationFailedStatus.permissionDenied;
    }
    if (isLocationEnabled && !checkIfPermissionGranted) {
      return LocationFailedStatus.gpsEnabledPermissionDenied;
    }
    if (!isLocationEnabled && checkIfPermissionGranted) {
      return LocationFailedStatus.gpsDeniedPermissionEnabled;
    }
  }

  _logLocationPermissionDenied() async {
    logError(
      statusCode: "",
      responseBody: "",
      url: "",
      exception: "Location permission not granted",
      requestBody:
          "For subid ${await AmplifyAuth.userID} location permission was not granted",
    );
  }

  _logLocationFetchFailure() async {
    logError(
      statusCode: "",
      responseBody: "",
      url: "",
      exception: "Location data was not fetched",
      requestBody:
          "For subid ${await AmplifyAuth.userID} location was not fetched",
    );
  }

  Future<void> _startReadingLocation() async {
    AppAnalytics.trackWebEngageEventWithAttribute(
      eventName: "Location Timer Started",
    );

    _locationTimer = Timer(
      Duration(seconds: defaultLocationTimer),
      () async {
        AppAnalytics.trackWebEngageEventWithAttribute(
          eventName: "Location Timer Completed",
        );
        bool gotLocationData =
            (await AppAuthProvider.getUserLocationData).isNotEmpty;
        AppAnalytics.trackWebEngageEventWithAttribute(
          eventName: "Location Data Status",
          attributeName: {
            "result": gotLocationData,
          },
        );
        Get.log("gotLocationData - $gotLocationData");
        if (gotLocationData) {
          disposeLocationService();
          onLocationFetchSuccessful();
        } else {
          await _onLocationNotRetreviedPostTimer();
        }
      },
    );

    await _readLocation();
  }

  disposeLocationService() {
    if (_locationSubscription != null) {
      _locationSubscription?.cancel();
    }
    if (_locationTimer != null) {
      _locationTimer?.cancel();
    }
  }
}
