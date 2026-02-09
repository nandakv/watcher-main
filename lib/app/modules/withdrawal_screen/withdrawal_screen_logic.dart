import 'dart:async';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:privo/app/api/api_error_mixin.dart';

import 'package:privo/app/common_widgets/app_lottie_widget.dart';
import 'package:privo/app/data/repository/on_boarding_repository/credit_line_respository.dart';
import 'package:privo/app/firebase/analytics.dart';
import 'package:privo/app/mixin/location_service_mixin.dart';
import 'package:privo/app/models/home_screen_card_model.dart';
import 'package:privo/app/modules/withdrawal_screen/widgets/withdrawal/withdrawal_logic.dart';
import 'package:privo/app/modules/withdrawal_screen/widgets/withdrawal_polling/withdrawal_polling_logic.dart';
import 'package:privo/app/modules/withdrawal_screen/withdrawal_navigation.dart';
import 'package:privo/app/modules/withdrawal_screen/withdrawal_screen_maps.dart';
import '../../../res.dart';
import '../../common_widgets/blue_button.dart';
import '../../theme/app_colors.dart';
import '../../utils/error_logger_mixin.dart';
import '../../utils/web_engage_constant.dart';
import 'widgets/withdrawal_address_details/withdrawal_address_details_logic.dart';

enum WithdrawalState { loading, success, error }

enum WithdrawalRequestState {
  none,
  initiated,
  success,
  reveresed,
  limitReached
}

class WithdrawalScreenLogic extends GetxController
    with ApiErrorMixin, ErrorLoggerMixin, LocationServiceMixin
    implements WithdrawalNavigation {
  bool isWithdrawalLoading = false;

  Map _withdrawalRequestBody = {};

  bool isFirstWithdrawal = false;

  WithdrawalScreen _currentWithdrawalScreen = WithdrawalScreen.loading;

  WithdrawalScreen get currentWithdrawalScreen => _currentWithdrawalScreen;

  set currentWithdrawalScreen(WithdrawalScreen value) {
    _currentWithdrawalScreen = value;
    update();
  }

  ///To decide tenure interval in tenure slider

  WithdrawalState withdrawalState = WithdrawalState.loading;
  WithdrawalRequestState withdrawalRequestState = WithdrawalRequestState.none;

  CreditLimitRepository creditLimitRespitory = CreditLimitRepository();

  late WithdrawalDetailsHomeScreenType withdrawalDetailsHomePageModel;

  @override
  void onReady() async {
    _initWithdrawalLogic();
    _initAddressDetails();
    _initPollingLogic();
  }

  void _initPollingLogic() {
    var withdrawalPollingLogic = Get.find<WithdrawalPollingLogic>();
    withdrawalPollingLogic.withdrawalNavigation = this;
  }

  void _initAddressDetails() {
    var addressDetailsLogic = Get.find<WithdrawalAddressDetailsLogic>();
    addressDetailsLogic.withdrawalNavigation = this;
  }

  void _initWithdrawalLogic() {
    var withdrawalDetailsLogic = Get.find<WithdrawalLogic>();
    withdrawalDetailsLogic.withdrawalNavigation = this;
    if (currentWithdrawalScreen == WithdrawalScreen.withdraw) {
      withdrawalDetailsLogic.withdrawalDetailsHomePageModel =
          withdrawalDetailsHomePageModel;
    }
  }

  var arguments = Get.arguments;

  @override
  void onInit() {
    if (arguments != null) {
      currentWithdrawalScreen =
          arguments['withdrawal_state'] ?? WithdrawalScreen.withdraw;
    }

    switch (currentWithdrawalScreen) {
      case WithdrawalScreen.withdraw:
        withdrawalDetailsHomePageModel = arguments['withdrawal_details_model'];
        AppAnalytics.trackWebEngageEventWithAttribute(
            eventName: WebEngageConstants.withdrawScreenLoaded);
        AppAnalytics.trackWebEngageUser(
            userAttributeName: "ApplicationState",
            userAttributeValue: "Withdrawal");
        break;
      case WithdrawalScreen.polling:
        navigateToPollingScreen(isFirstWithdrawal: isFirstWithdrawal);
        break;
      case WithdrawalScreen.addressDetails:
      case WithdrawalScreen.success:
      case WithdrawalScreen.loading:
        break;
    }
    super.onInit();
  }

  getBackPressStatus() {
    switch (currentWithdrawalScreen) {
      case WithdrawalScreen.withdraw:
        AppAnalytics.trackWebEngageEventWithAttribute(
            eventName: WebEngageConstants.withdrawScreenBackButtonClicked);
        break;
      case WithdrawalScreen.addressDetails:
        AppAnalytics.trackWebEngageEventWithAttribute(
            eventName:
                WebEngageConstants.currentAddressScreenBackButtonClicked);
        break;
      case WithdrawalScreen.polling:
        AppAnalytics.trackWebEngageEventWithAttribute(
            eventName: WebEngageConstants.withdrawalSuccessBackButtonClicked);
        break;
      default:
        break;
    }
    return true;
  }

  Future<void> withdrawalErrorDialog({required String message}) async {
    await Get.defaultDialog(
        title: "Sorry",
        barrierDismissible: false,
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(message),
            const AppLottieWidget(
              assetPath: Res.loading_paper_flight_lottie,
              height: 85,
              width: 150,
            ),
          ],
        ),
        contentPadding: const EdgeInsets.all(16),
        radius: 8,
        actions: [
          BlueButton(
            onPressed: () => Get.back(result: true),
            buttonColor: activeButtonColor,
            title: "OKAY",
          ),
        ]);
  }

  clearAllControllers() async {
    withdrawalState = WithdrawalState.error;
    update();
  }

  @override
  navigateToAddressScreen({required Map withdrawalRequestBody}) {
    this._withdrawalRequestBody = withdrawalRequestBody;
    currentWithdrawalScreen = WithdrawalScreen.addressDetails;
  }

  @override
  navigateToPollingScreen({required bool isFirstWithdrawal}) {
    this.isFirstWithdrawal = isFirstWithdrawal;
    currentWithdrawalScreen = WithdrawalScreen.polling;
  }

  @override
  navigateToSuccessScreen() {
    currentWithdrawalScreen = WithdrawalScreen.success;
  }

  @override
  Map withdrawalRequestBody() {
    return _withdrawalRequestBody;
  }

  @override
  bool computeIsFirstWithdrawal() {
    return isFirstWithdrawal;
  }

  @override
  navigateToWithdrawCalculationPage() {
    currentWithdrawalScreen = WithdrawalScreen.withdraw;
  }

  @override
  toggleWithdrawalLoading({required bool isWithdrawalLoading}) {
    this.isWithdrawalLoading = isWithdrawalLoading;
  }

  void onClosePressed() async {
    if (await onWillPopScope()) Get.back();
  }

  Future<bool> onWillPopScope() async {
    if (isWithdrawalLoading) {
      Fluttertoast.showToast(msg: "Please Wait");
      return false;
    } else {
      AppAnalytics.trackWebEngageEventWithAttribute(
          eventName: WebEngageConstants.withdrawScreenBackButtonClicked);
      return true;
    }
  }
}
