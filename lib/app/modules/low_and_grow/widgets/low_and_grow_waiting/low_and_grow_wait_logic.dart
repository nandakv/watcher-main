import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:privo/app/modules/low_and_grow/low_and_grow_mixin.dart';

import '../../../../api/api_error_mixin.dart';
import '../../../../api/response_model.dart';
import '../../../../firebase/analytics.dart';
import '../../../../utils/web_engage_constant.dart';
import '../../low_and_grow_repository.dart';
import '../../low_and_grow_user_states.dart';
import 'low_and_grow_wait_navigation.dart';
import 'low_and_grow_wait_screen_model.dart';

class LowAndGrowWaitLogic extends GetxController
    with LowAndGrowMixin, ApiErrorMixin {
  static const String LOW_AND_GROW_POLLING_PAGE = "low_and_grow_polling_page";

  LowAndGrowWaitNavigation? lowAndGrowPollingNavigation;

  late String LOW_AND_GROW_SCREEN = "low_and_grow";

  void onAfterLayout() {
    AppAnalytics.trackWebEngageEventWithAttribute(
        eventName: 'Entered Low and Grow Polling Screen');
    offerEligibilityRequest();
  }

  offerEligibilityRequest() async {
    LowAndGrowWaitScreenModel lowAndGrowWaitScreenModel =
        await LowAndGrowRepository().onLowAndGrowUpdate();

    switch (lowAndGrowWaitScreenModel.apiResponse.state) {
      case ResponseState.success:
        lowAndGrowWaitScreenModel.responseBody['rulePassed']
            ? onPollingSuccess()
            : onPollingFail();
        break;
      default:
        handleAPIError(
          lowAndGrowWaitScreenModel.apiResponse,
          screenName: LOW_AND_GROW_SCREEN,
          retry: offerEligibilityRequest(),
        );
    }
  }

  onPollingFail() {
    if (lowAndGrowPollingNavigation != null) {
      lowAndGrowPollingNavigation!.navigateUserToState(
        ///todo: go to low and grow polling
        lowAndGrowStates: LowAndGrowUserStates.failure,
      );
      AppAnalytics.trackWebEngageEventWithAttribute(
          eventName: WebEngageConstants.lgRejectionScreenLoaded);
    } else {
      onNavigationNull(LOW_AND_GROW_POLLING_PAGE);
    }
  }

  onPollingSuccess() {
    if (lowAndGrowPollingNavigation != null) {
      lowAndGrowPollingNavigation!.navigateUserToState(
        ///todo: go to low and grow polling
        lowAndGrowStates: LowAndGrowUserStates.agreement,
      );
    } else {
      onNavigationNull(LOW_AND_GROW_POLLING_PAGE);
    }
  }

  onClosePressed() {
    Fluttertoast.showToast(msg: "Please Wait");
  }
}
