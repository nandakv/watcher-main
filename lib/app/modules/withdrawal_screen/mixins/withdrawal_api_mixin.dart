import 'package:get/get.dart';
import 'package:privo/app/api/api_error_mixin.dart';
import 'package:privo/app/api/response_model.dart';
import 'package:privo/app/data/repository/on_boarding_repository/credit_line_respository.dart';
import 'package:privo/app/firebase/analytics.dart';
import 'package:privo/app/models/check_app_form_model.dart';
import 'package:privo/app/models/withdrawal_status_model.dart';
import 'package:privo/app/utils/apps_flyer_constants.dart';
import 'package:privo/app/utils/web_engage_constant.dart';

import '../../home_screen_module/widgets/withdrawal_blocking_widget.dart';

class WithdrawalApiMixin {
  CreditLimitRepository creditLimitRepository = CreditLimitRepository();

  postWithdrawRequestForUser(
      {required Map body,
      required Function onSuccess,
      required Function(ApiResponse) onFailure}) async {
    CheckAppFormModel checkAppFormModel =
        await creditLimitRepository.postWithdrawRequest(body: body);

    switch (checkAppFormModel.apiResponse.state) {
      case ResponseState.success:
        AppAnalytics.logAppsFlyerEvent(
            eventName: AppsFlyerConstants.withdrawalStarted);
        onSuccess();
        break;
      case ResponseState.badRequestError:
        _onBadRequestError(checkAppFormModel);
        break;
      default:
        onFailure(checkAppFormModel.apiResponse);
    }
  }

  void _onBadRequestError(CheckAppFormModel checkAppFormModel) {
    String title = "Notice!";
    String message =
        "Your account has been temporarily disabled for withdrawals after a thorough evaluation of your credit behaviour. We will notify you as soon as your limit is reactivated.";
    String errorType = "";

    if (checkAppFormModel.error != null) {
      title = checkAppFormModel.error!.errorTitle;
      message = checkAppFormModel.error!.errorMessage;
      errorType = checkAppFormModel.error!.errorBody.type;
    }

    AppAnalytics.trackWebEngageEventWithAttribute(
        eventName: WebEngageConstants.withdrawalBlocked,
        attributeName: {
          errorType: true,
        });

    Get.bottomSheet(
      WithdrawalBlockingWidget(
        title: title,
        message: message,
        onOKPressed: () {
          Get.back();
        },
      ),
      isDismissible: false,
    );
  }

  onNavigationDetailsNull(String logicName) async {
    await ApiErrorMixin().handleAPIError(
        ApiResponse(
          state: ResponseState.failure,
          apiResponse: "",
          exception: "GetX Navigation object was null in $logicName",
        ),
        screenName: "withdrawal",
        retry: () => Get.back());
    await AppAnalytics.navigationObjectNull(logicName);
  }
}
