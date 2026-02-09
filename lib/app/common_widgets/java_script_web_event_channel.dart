import 'package:url_launcher/url_launcher_string.dart';

class JavaScriptWebEventChannel {
  final WebEventHandler webEventHandler;

  JavaScriptWebEventChannel({required this.webEventHandler});

  void handleWebEvent(String event, String eventMessage) {
    Map<String, Function> eventActions = {
      "IFRAME_FAILED": () => webEventHandler.handleWebViewFailure(),
      "CONSENT_NOT_IN_PENDING_STATE": () => webEventHandler.handleWebViewNotPending(),
      "NO_ACCOUNTS_FOUND_JOURNEY_CLOSED": () => webEventHandler.onWebviewNoAccountFoundJourneyClosed(),
      "CONSENT_APPROVED_SUCCESS": () => webEventHandler.onWebViewConsentApproved(),
      "CONSENT_REJECTED_SUCCESS": () => webEventHandler.onWebViewConsentRejected(),
      "CONSENT_APPROVED_FAILED": () => webEventHandler.onWebViewConsentApprovedFailed(),
      "CONSENT_REJECTED_FAILED": () => webEventHandler.onWebViewConsentRejectedFailed(),
      "AAJOURNEY_CLOSED": () => webEventHandler.onWebViewJourneyClosed(),
      "TNC_CLICKED": () => launchUrlString(eventMessage.trim(),
          mode: LaunchMode.externalApplication),
    };
    (eventActions[event] ?? () => print("Unhandled event: $event"))();
  }
}


abstract class WebEventHandler {
  void handleWebViewFailure();

  void handleWebViewNotPending();

  void onWebviewNoAccountFoundJourneyClosed();

  void onWebViewConsentApproved();

  void onWebViewConsentRejected();

  void onWebViewConsentApprovedFailed();

  void onWebViewConsentRejectedFailed();

  void onWebViewJourneyClosed();
}