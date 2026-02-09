import 'package:privo/app/mixin/app_analytics_mixin.dart';
import 'package:privo/app/models/e_mandate_polling_model.dart';
import 'package:privo/app/models/supported_banks_model.dart';
import 'package:privo/app/modules/on_boarding/widgets/e_mandate/e_mandate_logic.dart';

class EMandateAnalyticsMixin {
  final _appAnalytics = AppAnalyticsMixin();

  late String setupAutopayCTAHomescreen = "Setup_Autopay_CTA_Homescreen";
  late String setupAutopayLinkAccountCTA = "Setup_Autopay_Link_Account_CTA";
  late String setupAutopayScreenClosed = "Setup_Autopay_Screen_Closed";
  late String setupAutopayMainScreenLoaded = "Setup_Autopay_Main_Screen_Loaded";
  late String setupAutopayMainScreenClosed = "Setup_Autopay_Main_Screen_Closed";
  late String autopayOptionToggle = "Autopay_Option_Toggle";
  late String autopayOptionCTAClicked = "Autopay_Option_CTA_Clicked";
  late String upiAddressEntered = "UPI_Address_Entered";
  late String autopayMinimised = "Autopay_Minimised";
  late String autopayMaximised = "Autopay_Maximised";
  late String mandateSuccessful = "Mandate_Successful";
  late String mandateFailed = "Mandate_Failed";

  logSetupAutopayCTAHomescreen() {
    _appAnalytics.trackWebEngageEventWithAttribute(
      eventName: setupAutopayCTAHomescreen,
    );
  }

  void logSetupAutopayLinkAccountCTA() {
    _appAnalytics.trackWebEngageEventWithAttribute(
      eventName: setupAutopayLinkAccountCTA,
    );
  }

  void logSetupAutopayScreenClosed() {
    _appAnalytics.trackWebEngageEventWithAttribute(
      eventName: setupAutopayScreenClosed,
    );
  }

  void logSetupAutopayMainScreenLoaded(
      JusPayMandateCombination jusPayMandateCombination) {
    _appAnalytics.trackWebEngageEventWithAttribute(
      eventName: setupAutopayMainScreenLoaded,
      attributeName: _computeJusPayCombination(jusPayMandateCombination),
    );
  }

  Map<String, dynamic> _computeJusPayCombination(
      JusPayMandateCombination jusPayMandateCombination) {
    Map<JusPayMandateCombination, Map<String, dynamic>> combinations = {
      JusPayMandateCombination.upi: {'UPI': true},
      JusPayMandateCombination.eNach: {'ENach': true},
      JusPayMandateCombination.all: {
        'UPI': true,
        'ENach': true,
      },
    };
    return combinations[jusPayMandateCombination] ?? {};
  }

  void logSetupAutopayMainScreenClosed() {
    _appAnalytics.trackWebEngageEventWithAttribute(
      eventName: setupAutopayMainScreenClosed,
    );
  }

  void logAutopayOptionToggle(JusPayMandateType selectedMandateType) {
    _appAnalytics.trackWebEngageEventWithAttribute(
      eventName: autopayOptionToggle,
      attributeName: _getSelectedJusPayMandateType(selectedMandateType),
    );
  }

  void logAutopayOptionCTAClicked(JusPayMandateType selectedMandateType) {
    _appAnalytics.trackWebEngageEventWithAttribute(
      eventName: autopayOptionCTAClicked,
      attributeName: _getSelectedJusPayMandateType(selectedMandateType),
    );
  }

  Map<String, dynamic> _getSelectedJusPayMandateType(
      JusPayMandateType selectedMandateType) {
    Map<JusPayMandateType, Map<String, dynamic>> combinations = {
      JusPayMandateType.upi: {'Mode': 'UPI'},
      JusPayMandateType.eNach: {'Mode': 'ENach'},
    };
    return combinations[selectedMandateType] ?? {};
  }

  void logUpiAddressEntered() {
    _appAnalytics.trackWebEngageEventWithAttribute(
      eventName: upiAddressEntered,
    );
  }

  void logAutopayMinimised(String selectedMandateType) {
    _appAnalytics.trackWebEngageEventWithAttribute(
      eventName: autopayMinimised,
      attributeName: {
        "Polling": true,
        "Mode": selectedMandateType,
      },
    );
  }

  void logAutopayMaximised(
    EMandatePollingStatus eMandatePollingStatus,
    String selectedEMandateType,
  ) {
    _appAnalytics.trackWebEngageEventWithAttribute(
      eventName: autopayMaximised,
      attributeName: {
        "Mode": selectedEMandateType,
        _computeEMandateStatus(eMandatePollingStatus): true,
      },
    );
  }

  _computeEMandateStatus(EMandatePollingStatus eMandatePollingStatus) {
    switch (eMandatePollingStatus) {
      case EMandatePollingStatus.success:
        return "Success";
      case EMandatePollingStatus.failure:
        return "Failed";
      case EMandatePollingStatus.pending:
        return "Polling";
    }
  }

  void logMandateSuccessful(String selectedMandateType) {
    _appAnalytics.trackWebEngageEventWithAttribute(
      eventName: mandateSuccessful,
      attributeName: {
        "Mode": selectedMandateType,
      },
    );
  }

  void logMandateFailed(String selectedMandateType, bool isTPVFailure) {
    if (selectedMandateType == "UPI") {
      selectedMandateType = isTPVFailure ? "UPI_TPV_Fail" : "UPI_others_fail";
    }
    _appAnalytics.trackWebEngageEventWithAttribute(
      eventName: mandateFailed,
      attributeName: {
        "Mode": selectedMandateType,
      },
    );
  }
}
