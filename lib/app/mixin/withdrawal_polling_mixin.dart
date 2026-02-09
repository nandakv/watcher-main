import 'dart:async';

import 'package:get/get.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:privo/app/api/response_model.dart';
import 'package:privo/app/data/repository/on_boarding_repository/credit_line_respository.dart';
import 'package:privo/app/models/withdrawal_status_model.dart';
import 'package:privo/app/modules/withdrawal_screen/withdrawal_analytics.dart';
import 'package:privo/app/utils/app_functions.dart';

import '../firebase/analytics.dart';
import '../utils/web_engage_constant.dart';

class WithdrawalPolling with WithdrawalAnalytics {
  final _creditLimitRepository = CreditLimitRepository();

  late Function _onInitiated;
  late Function _onProcessed;
  late Function _onCancelled;
  late Function _onSuccess;
  late Function _onFailed;
  late Function(ApiResponse) _onApiError;

  ///need to have a single instance of subscription
  ///to avoid multiple polling
  static StreamSubscription? _pollingSubscription;

  initAndStart({
    required Function onInitiated,
    required Function onProcessed,
    required Function(String, DateTime?) onCancelled,
    required Function(double) onSuccess,
    required Function(String, DateTime?) onFailed,
    required Function(ApiResponse) onApiError,
  }) {
    Get.log("initializeWithdrawalPolling");
    _onInitiated = onInitiated;
    _onProcessed = onProcessed;
    _onCancelled = onCancelled;
    _onSuccess = onSuccess;
    _onFailed = onFailed;
    _onApiError = onApiError;

    ///setting up polling subscription
    stop();
    _pollingSubscription =
        Stream.periodic(const Duration(seconds: 5)).listen((event) {
      _getWithdrawalStatus();
    });
  }

  stop() {
    if (_pollingSubscription != null) {
      Get.log("withdrawal polling Subscription Cancelled");
      _pollingSubscription!.cancel();
    }
  }

  _getWithdrawalStatus() async {
    WithdrawalStatusModel withdrawalStatusModel =
        await _creditLimitRepository.getAppFormStatus();
    switch (withdrawalStatusModel.apiResponse.state) {
      case ResponseState.success:
        _computeWithdrawalStatus(withdrawalStatusModel);
        break;
      default:
        stop();
        _onApiError(withdrawalStatusModel.apiResponse);
    }
  }

  void _computeWithdrawalStatus(
      WithdrawalStatusModel withdrawalStatusModel) async {
    switch (withdrawalStatusModel.pollingStatus) {
      case WithdrawalPollingStatus.initiated:
        Get.log("withdrawal status -  initiated");
        _onInitiated();
        break;
      case WithdrawalPollingStatus.processed:
        Get.log("withdrawal status -  processed");
        _onProcessed();
        break;
      case WithdrawalPollingStatus.withdrawCancelled:
        Get.log("withdrawal status -  Cancelled");
        stop();
        _onCancelled(
          withdrawalStatusModel.errorMessage,
          withdrawalStatusModel.errorDateTime,
        );
        break;
      case WithdrawalPollingStatus.loanCreated:
        Get.log("withdrawal status -  loan created");
        stop();
        _onSuccess(
          double.parse(withdrawalStatusModel.disbursedAmount),
        );
        logWithdrawalSuccessfulScreenLoaded();
        AppFunctions().showInAppReview(WebEngageConstants.playStorePrompted);
        break;
      case WithdrawalPollingStatus.withdrawalFailed:
        Get.log("withdrawal status -  loan failed");
        stop();
        _onFailed(
          withdrawalStatusModel.errorMessage,
          withdrawalStatusModel.errorDateTime,
        );
        break;
    }
  }
}
