import 'dart:async';

import 'package:get/get.dart';

class OtpResendWidgetLogic extends GetxController {
  // Initial Count Timer value
  late int sCount;

  ///object for Timer Class
  late Timer _timer;

  /// a Method to start the Count Down for 1 minute to display the timer in resend button
  void stateTimerStart() {
    _timer = _createTimer;
  }

  Timer get _createTimer {
    return Timer.periodic(const Duration(seconds: 1), (timer) {
      if (sCount > 0) {
        sCount--;
        update(['resend']);
      } else {
        _timer.cancel();
      }
    });
  }

  void onResendPressed(int timerValue) {
    sCount = timerValue;
    stateTimerStart();
  }

  @override
  void onClose() {
    _timer.cancel();
    super.onClose();
  }
}
