import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:privo/app/api/api_error_mixin.dart';
import 'package:privo/app/api/response_model.dart';
import 'package:privo/app/data/provider/auth_provider.dart';
import 'package:privo/app/models/check_app_form_model.dart';
import 'package:privo/app/modules/on_boarding/mixins/app_form_mixin.dart';
import 'package:privo/app/modules/on_boarding/widgets/e_sign/e_sign_analytics.dart';
import 'package:privo/app/modules/on_boarding/widgets/upl_withdrawal_loading/upl_withdrawal_navigation.dart';
import 'package:privo/app/utils/app_functions.dart';
import 'package:privo/app/utils/web_engage_constant.dart';

import '../../../../../res.dart';
import '../../../../mixin/app_analytics_mixin.dart';
import '../../../../theme/app_colors.dart';
import '../../mixins/on_boarding_mixin.dart';

class UPLWithdrawalLoadingLogic extends GetxController
    with
        OnBoardingMixin,
        AppFormMixin,
        ApiErrorMixin,
        AppAnalyticsMixin,
        ESignAnalytics {
  OnBoardingUPLWithdrawalNavigation? onBoardingUPLWithdrawalNavigation;

  bool _isWithdrawalSuccess = false;

  late String UPL_WITHDRAWAL_LOADING_SCREEN = "upl_withdrawal_loading";

  bool get isWithdrawalSuccess => _isWithdrawalSuccess;

  set isWithdrawalSuccess(bool value) {
    _isWithdrawalSuccess = value;
    update();
  }

  showSanctionLetterInfoSnackBar() {
    Get.showSnackbar(
      GetSnackBar(
        messageText: const Text(
          'Loan agreement has been sent to your registered email & SMS',
          style: TextStyle(
            color: Colors.white,
            fontSize: 10,
            fontWeight: FontWeight.w500,
          ),
        ),
        duration: const Duration(seconds: 3),
        snackPosition: SnackPosition.TOP,
        padding: const EdgeInsets.only(top: 10, bottom: 10, left: 0, right: 10),
        backgroundColor: darkBlueColor,
        icon: SvgPicture.asset(
          Res.information_svg,
          height: 12,
          color: Colors.white,
        ),
      ),
    );
  }

  onSuccessPressed() {
    if (onBoardingUPLWithdrawalNavigation != null) {
      onBoardingUPLWithdrawalNavigation!.onUPLWithdrawSuccess();
    } else {
      onNavigationDetailsNull(UPL_WITHDRAWAL_LOADING_SCREEN);
    }
  }

  void onAfterLayout() async {
    logDisbursementInProgress();
    if (onBoardingUPLWithdrawalNavigation != null) {
      onBoardingUPLWithdrawalNavigation!.toggleAppBarVisibility(false);
    } else {
      onNavigationDetailsNull(UPL_WITHDRAWAL_LOADING_SCREEN);
    }
    showInAppReview();
    await getAppForm(
      onApiError: _onAppFormApiError,
      onRejected: _onAppFormApiRejected,
      onSuccess: _onAppFormSuccess,
    );
  }

  showInAppReview() async {
    switch (await AppAuthProvider.getLpc) {
      case "UPL":
        AppFunctions().showInAppReview(WebEngageConstants.playStorePromptedUPL);
        break;
      case "SBL":
        AppFunctions().showInAppReview(WebEngageConstants.playStorePromptedSBL);
        break;
      default:
        break;
    }
  }

  _onAppFormSuccess(AppForm appForm) async {
    if (appForm.responseBody['loan'] != null &&
        appForm.responseBody['loan']['withdrawalStatus'] == "LOAN_CREATED") {
      _onWithdrawalSuccess();
    } else {
      if (!isWithdrawalSuccess &&
          !(await AppAuthProvider.isNonCLPLoanAgreementSnackBarShown)) {
        await AppAuthProvider.setNonCLPLoanAgreementSnackBarShown();
        showSanctionLetterInfoSnackBar();
      }
    }
  }

  _onWithdrawalSuccess() async {
    isWithdrawalSuccess = true;
  }

  _onAppFormApiRejected(CheckAppFormModel checkAppFormModel) {
    if (onBoardingUPLWithdrawalNavigation != null) {
      onBoardingUPLWithdrawalNavigation!
          .onAppFormRejected(model: checkAppFormModel.appFormRejectionModel);
    } else {
      onNavigationDetailsNull(UPL_WITHDRAWAL_LOADING_SCREEN);
    }
  }

  _onAppFormApiError(ApiResponse apiResponse) {
    handleAPIError(apiResponse,
        retry: onAfterLayout, screenName: UPL_WITHDRAWAL_LOADING_SCREEN);
  }

  onClosePressed() {
    Get.back();
  }
}
