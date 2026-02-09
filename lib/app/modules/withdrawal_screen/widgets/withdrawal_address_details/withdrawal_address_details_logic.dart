import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:privo/app/api/api_error_mixin.dart';
import 'package:privo/app/api/response_model.dart';
import 'package:privo/app/common_widgets/privo_text_editing_controller.dart';
import 'package:privo/app/data/provider/auth_provider.dart';
import 'package:privo/app/data/repository/app_parameter_repository.dart';
import 'package:privo/app/data/repository/on_boarding_repository/credit_line_respository.dart';
import 'package:privo/app/data/repository/on_boarding_repository/device_detail_repository.dart';
import 'package:privo/app/firebase/analytics.dart';
import 'package:privo/app/models/app_parameter_model.dart';
import 'package:privo/app/models/post_withdrawal_address_response_model.dart';
import 'package:privo/app/modules/withdrawal_screen/mixins/withdrawal_api_mixin.dart';
import 'package:privo/app/modules/withdrawal_screen/withdrawal_field_validator.dart';
import 'package:privo/app/modules/withdrawal_screen/withdrawal_navigation.dart';
import 'package:privo/app/services/location_service/location_service.dart';
import 'package:privo/app/services/preprocessor_service/customer_device_details_service.dart';
import 'package:privo/app/utils/city_state_json.dart';
import 'package:privo/app/utils/error_logger_mixin.dart';
import 'package:privo/app/utils/web_engage_constant.dart';

import '../../../../common_widgets/forms/base_field_validator.dart';
import '../../../../services/platform_services/platform_services.dart';

class WithdrawalAddressDetailsLogic extends GetxController
    with
        ApiErrorMixin,
        WithdrawalApiMixin,
        ErrorLoggerMixin,
        BaseFieldValidators,
        WithdrawalFieldValidator {
  WithdrawalNavigation? withdrawalNavigation;

  WithdrawalAddressDetailsLogic({this.withdrawalNavigation});

  CreditLimitRepository creditLimitRepository = CreditLimitRepository();

  List<String> listOfStates = [];
  List<String> listOfCities = [];

  late String WITHDRAWAL_ADDRESS_SCREEN = "withdrawal_address_screen";

  String ADDRESS_DETAILS_LOGIC = "ADDRESS_DETAILS";

  late final String ADDRESS_TEXT_FIELD_ID = "ADDRESS_TEXT_FIELD_ID";
  late final String PINCODE_TEXT_FIELD_ID = "PINCODE_TEXT_FIELD_ID";

  String _selectedState = '';

  String get selectedState => _selectedState;

  set selectedState(String value) {
    _selectedState = value;
    update(['state-selector']);
  }

  String _selectedCity = '';

  String get selectedCity => _selectedCity;

  set selectedCity(String value) {
    _selectedCity = value;
    update();
  }

  var isSearchingCity = true;

  String selectAState = 'State';

  bool _isAddressDetailsFormFilled = false;

  bool get isAddressDetailsFormFilled => _isAddressDetailsFormFilled;

  set setAddressDetailsFormFilled(bool state) {
    _isAddressDetailsFormFilled = state;
    update([addressButtonId]);
  }

  String addressButtonId = 'address_bt';

  final addressDetailsFormKey = GlobalKey<FormState>();

  bool isButtonLoading = false;

  ///TexteditingControllers for the address input screen
  TextEditingController cityTextController = TextEditingController();
  PrivoTextEditingController addressController = PrivoTextEditingController();
  PrivoTextEditingController pinCodeController = PrivoTextEditingController();

  FocusNode cityFocusNode = FocusNode();

  @override
  void onReady() {
    listOfStates = cityStateMap.keys.toList();
    selectedState = listOfStates[0];
  }

  bool configureAddressDetailsButtonColor() {
    if (isAddressDetailsFormFilled && !isButtonLoading) {
      return true;
    } else {
      return false;
    }
  }

  onAddressDetailsContinueTapped() {
    if (addressDetailsFormKey.currentState!.validate()) {
      setAddressDetailsFormFilled = true;
      AppAnalytics.trackWebEngageUser(
          userAttributeName: "PermanentState",
          userAttributeValue: selectedState);
      AppAnalytics.trackWebEngageEventWithAttribute(
          eventName: WebEngageConstants.currentAddressInput);
      AppAnalytics.trackWebEngageEventWithAttribute(
          eventName: WebEngageConstants.pincodeInput);
      if (Get.focusScope != null) Get.focusScope!.unfocus();
      postWithdrawalAddress();
    } else {
      setAddressDetailsFormFilled = false;
    }
  }

  postWithdrawalAddress() async {
    isButtonLoading = true;
    update([addressButtonId]);
    PostWithdrawalAddressResponseModel postWithdrawalAddressResponseModel =
        await creditLimitRepository.postWithdrawalAddressPost(body: {
      "individualDetails": {
        "address": {
          "type": "CORRESPOND",
          "line1": addressController.text,
          "city": selectedCity,
          "state": selectedState,
          "country": "IN",
          "pinCode": pinCodeController.text
        }
      }
    });

    switch (postWithdrawalAddressResponseModel.apiResponse.state) {
      case ResponseState.success:
        await _onAddressPostSuccess();
        break;
      default:
        isButtonLoading = false;
        handleAPIError(postWithdrawalAddressResponseModel.apiResponse,
            screenName: WITHDRAWAL_ADDRESS_SCREEN,
            retry: postWithdrawalAddress);
    }
    update([addressButtonId]);
  }

  Future<void> _onAddressPostSuccess() async {
    Map _requestBody = _fetchWithdrawalRequestBody();
    await postWithdrawRequestForUser(
        body: _requestBody, onSuccess: _onSuccess, onFailure: _onFailure);
  }

  _onSuccess() {
    if (withdrawalNavigation != null) {
      _sendLocation();
      _triggerSMS();
      withdrawalNavigation!.navigateToPollingScreen(isFirstWithdrawal: true);
    } else {
      onNavigationDetailsNull(ADDRESS_DETAILS_LOGIC);
    }
  }

  void _triggerSMS() async {
    Get.log("trigger sms");
    String lastSMSDateTimeFromBackend =
        await AppAuthProvider.getLastSMSDateTime;
    Get.log("lastDateTimeFromBackend - $lastSMSDateTimeFromBackend");
    if (lastSMSDateTimeFromBackend.isNotEmpty) {
      String formattedDateTime = DateFormat("yyyy-MM-dd HH:mm:ss")
          .format(DateTime.parse(lastSMSDateTimeFromBackend));
      Get.log("formattedDateTime - $formattedDateTime");
      PrivoPlatform.platformService.triggerSMS(
        formattedTime: formattedDateTime,
      );
    }
  }

  _onFailure(ApiResponse apiResponse) {
    isButtonLoading = false;
    handleAPIError(apiResponse, screenName: WITHDRAWAL_ADDRESS_SCREEN);
  }

  _fetchWithdrawalRequestBody() {
    if (withdrawalNavigation != null) {
      return withdrawalNavigation!.withdrawalRequestBody();
    } else {
      onNavigationDetailsNull(ADDRESS_DETAILS_LOGIC);
    }
  }

  void onStateSelected(String value) {
    selectedState = value;
    listOfCities = [];
    cityTextController.text = "";
    validateAddressDetails();
    if (cityStateMap[value] != null)
      listOfCities = cityStateMap[value]!.toList();
    Get.log(listOfCities.toString());
    update();
  }

  String? validatePinCode(String value) {
    return value.trim().isEmpty
        ? "Empty Field: Pincode is required.."
        : value.length != 6
            ? "Incomplete Pincode: Complete your pincode."
            : null;
  }

  void onCitySelected(String suggestion) {
    cityTextController.text = suggestion;
    selectedCity = suggestion;
    isSearchingCity = true;
    update(['state']);
    Get.log("statement $selectedCity  city");
    validateAddressDetails();
  }

  void onPinCodeChanged(String value) {
    validateAddressDetails();
  }

  void validateAddressDetails() {
    setAddressDetailsFormFilled =
        isFieldValid(validateAddressTextField(addressController.text)) &&
            pinCodeController.text.isNotEmpty &&
            pinCodeController.text.length == 6 &&
            isFieldValid(validateState(selectedState)) &&
            isFieldValid(validateCity(cityTextController.text, listOfCities));
    listOfCities.contains(cityTextController.text)
        ? AppAnalytics.trackWebEngageEventWithAttribute(
            eventName: WebEngageConstants.citySelected)
        : "";
  }

  void onAddressTextFieldChanged(String value) {
    validateAddressDetails();
  }

  Future<bool> _getAppParameterLocationFlag() async {
    AppParameterModel appParameterModel =
        await AppParameterRepository().getAppParameters();
    switch (appParameterModel.apiResponse.state) {
      case ResponseState.success:
        return appParameterModel.isEnableWithdrawLocation;
      default:
        return false;
    }
  }

  Future<void> _sendLocation() async {
    Get.log((await _getAppParameterLocationFlag()).toString());

    if (await _getAppParameterLocationFlag()) {
      try {
        LocationService locationService = LocationService(
          onLocationFetchSuccessful: () async {
            String locationData = await AppAuthProvider.getUserLocationData;
            CustomerDeviceDetailsService().postCustomerDeviceDetails(
                locationState: LocationAvailabilityState.fetchedSuccessfully,
                atDisbursal: true,
                locationData: locationData);
          },
          onLocationStatus: (LocationStatusType errType) {
            switch (errType) {
              case LocationStatusType.noPermission:
              case LocationStatusType.locationDisabled:
                CustomerDeviceDetailsService().postCustomerDeviceDetails(
                    locationState:
                        LocationAvailabilityState.noPermissionOrDisabled,
                    atDisbursal: true,
                    locationData: "");
                break;
              case LocationStatusType.locationNotFound:
              case LocationStatusType.retry:
              case LocationStatusType.technicalError:
                CustomerDeviceDetailsService().postCustomerDeviceDetails(
                    locationState: LocationAvailabilityState.technicalIssues,
                    atDisbursal: true,
                    locationData: "");
                break;
              case LocationStatusType.permissionAndLocationEnabled:
              default:
                break;
            }
          },
        );
        locationService.fetchLocation();
      } catch (e) {
        CustomerDeviceDetailsService().postCustomerDeviceDetails(
            locationState: LocationAvailabilityState.technicalIssues,
            atDisbursal: true,
            locationData: "");

        logError(
          statusCode: "",
          responseBody: "",
          url: "",
          exception: "Error while fetching location during withdrawal - $e",
          requestBody: "",
        );
      }
    }
  }
}
