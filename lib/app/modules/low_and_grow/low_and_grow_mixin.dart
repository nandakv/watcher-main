import 'package:get/get.dart';

import '../../api/api_error_mixin.dart';
import '../../api/response_model.dart';
import '../../firebase/analytics.dart';

class LowAndGrowMixin {
  onNavigationNull(String logicName) async {
    await ApiErrorMixin().handleAPIError(
      ApiResponse(
        state: ResponseState.failure,
        apiResponse: "",
        exception: "GetX Navigation object was null in $logicName",
      ),
      screenName: "low_and_grow",
      retry: () => Get.back(),
    );
    await AppAnalytics.navigationObjectNull(logicName);
  }
}
