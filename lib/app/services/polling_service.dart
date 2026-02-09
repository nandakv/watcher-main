import 'dart:async';

class PollingService {
  static StreamSubscription? _pollingSubscription;

  int _retryCount = 0;

  initAndStartPolling({
    required int pollingInterval,
    int? maxPollingLimit,
    required Function() pollingFunction,
    Function()? onRetryFinished,
    bool pollOnStart = false,
  }) {
    ///to stop any existing polling

    stopPolling();
    if (pollOnStart) {
      pollingFunction();
    }
    _pollingSubscription =
        Stream.periodic(Duration(seconds: pollingInterval)).listen(
      (event) {
        if (maxPollingLimit != null) {
          if (_retryCount > maxPollingLimit) {
            stopPolling();
            onRetryFinished?.call();
            return;
          }
          _retryCount++;
        }
        pollingFunction();
      },
    );
  }

  void stopPolling() {
    _pollingSubscription?.cancel();
  }
}
