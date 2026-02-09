import 'package:get/get.dart';
import 'package:privo/app/api/api_error_mixin.dart';
import 'package:privo/app/api/response_model.dart';
import 'package:privo/app/data/repository/on_boarding_repository/on_boarding_repository.dart';
import 'package:privo/app/data/repository/on_boarding_repository/sequence_engine_repository.dart';
import 'package:privo/app/firebase/analytics.dart';
import 'package:privo/app/models/check_app_form_model.dart';
import 'package:privo/app/modules/on_boarding/mixins/on_boarding_mixin.dart';
import 'package:privo/app/modules/on_boarding/widgets/kyc_polling/kyc_polling_navigation.dart';
import 'package:privo/app/utils/apps_flyer_constants.dart';

import '../../../../models/app_form_rejection_model.dart';
import '../../../../utils/web_engage_constant.dart';
import '../../user_state_maps.dart';

class KycPollingLogic extends GetxController
    with OnBoardingMixin, ApiErrorMixin {
  OnBoardingKycPollingNavigation? kycPollingNavigation;

  KycPollingLogic({this.kycPollingNavigation});

  static const String KYC_POLLING_SCREEN = "kyc_polling";

  static const String QC_APPROVED_STATUS = "15";

  bool _enablePolling = true;

  bool _isKycSuccess = false;

  bool get isKycSuccess => _isKycSuccess;

  set isKycSuccess(bool value) {
    _isKycSuccess = value;
    update();
  }

  void startPolling() async {
    if (_enablePolling) {
      _toggleBackPress(isBackDisabled: true);

      CheckAppFormModel checkAppFormModel =
          await OnBoardingRepository().getAppFormStatus();

      switch (checkAppFormModel.apiResponse.state) {
        case ResponseState.success:
          _onGetAppFormStatus(checkAppFormModel);
          break;
        default:
          handleAPIError(
            checkAppFormModel.apiResponse,
            screenName: KYC_POLLING_SCREEN,
            retry: startPolling,
          );
      }
    }
  }

  void _toggleBackPress({required bool isBackDisabled}) {
    if (kycPollingNavigation != null) {
      kycPollingNavigation!.toggleBack(isBackDisabled: isBackDisabled);
    } else {
      onNavigationDetailsNull(KYC_POLLING_SCREEN);
    }
  }

  void _onGetAppFormStatus(CheckAppFormModel checkAppFormModel) async {
    if (checkAppFormModel.appFormRejectionModel.isRejected) {
      _toggleBackPress(isBackDisabled: false);
      _onAppFormRejectionNavigation(checkAppFormModel.appFormRejectionModel);
    } else {
      _checkQCStatus(checkAppFormModel.responseBody);
    }
  }

  void _onAppFormRejectionNavigation(
      AppFormRejectionModel appFormRejectionModel) {
    if (kycPollingNavigation != null) {
      AppAnalytics.logAppsFlyerEvent(eventName: AppsFlyerConstants.kycRejected);
      AppAnalytics.trackWebEngageEventWithAttribute(
          eventName: WebEngageConstants.kycVerificationFailureScreenLoaded);
      kycPollingNavigation!.onAppFormRejected(model: appFormRejectionModel);
    } else {
      onNavigationDetailsNull(KYC_POLLING_SCREEN);
    }
  }

  void _checkQCStatus(Map<String, dynamic> responseBody) async {
    if (responseBody["status"] == QC_APPROVED_STATUS) {
      _enableBackPress();
      _onKycSuccess();
    } else {
      await Future.delayed(const Duration(seconds: 5));
      startPolling();
    }
  }

  void _enableBackPress() {
    if (kycPollingNavigation != null) {
      kycPollingNavigation!.toggleBack(isBackDisabled: false);
    } else {
      onNavigationDetailsNull(KYC_POLLING_SCREEN);
    }
  }

  void _onKycSuccess() async {
    isKycSuccess = true;
    AppAnalytics.trackWebEngageEventWithAttribute(
        eventName: WebEngageConstants.kycVerificationSuccessScreenLoaded);
    await Future.delayed(const Duration(seconds: 3));
    if (kycPollingNavigation != null) {
      kycPollingNavigation!.onKycPollingSuccess();
    } else {
      onNavigationDetailsNull(KYC_POLLING_SCREEN);
    }
  }

  @override
  void onClose() {
    _enablePolling = false;
    Get.log("enable polling = $_enablePolling");
    super.onClose();
  }
}
