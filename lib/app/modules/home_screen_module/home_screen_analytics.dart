import 'package:privo/app/mixin/app_analytics_mixin.dart';
import 'package:privo/app/utils/web_engage_constant.dart';

import '../../models/home_screen_model.dart';
import 'home_page_state_maps.dart';

mixin HomeScreenAnalytics {
  final _analyticsMixin = AppAnalyticsMixin();

  late String enteredHomeScreen = "Entered Home Screen";

  Map<int, String> benefitEventMapping = {
    0: WebEngageConstants.emiFastTrackBenefit1,
    1: WebEngageConstants.emiFastTrackBenefit2,
    2: WebEngageConstants.emiFastTrackBenefit3,
  };

  late final _ctaPayHomescreenOverdue = "CTA_Pay_Homescreen_Overdue";
  late final _ctaPayHomescreenUpcomingDue = "CTA_Pay_Homescreen_UpcomingDue";
  late final _knowMore = "Know_More";

  ///top up events
  late final _offerZoneLoaded = "Offer_Zone_Loaded";
  late final _offerZoneGetNowClicked = "Offer_Zone_Get_Now_Clicked";

  logAdvanceEMIBenefit(int index) {
    _analyticsMixin.trackWebEngageEventWithAttribute(
        eventName: benefitEventMapping[index] ?? "");
  }

  logAdvanceEMIPayCTAClick({
    required String noOfEMIs,
    required String amount,
    required String loanId,
  }) {
    Map<String, dynamic> attribute = {};
    if (noOfEMIs == "1") {
      attribute.addAll({
        "single": true,
        "amount": amount,
        "loanId": loanId,
      });
    } else {
      attribute['multiple'] = true;
    }
    _analyticsMixin.trackWebEngageEventWithAttribute(
      eventName: _ctaPayHomescreenUpcomingDue,
      attributeName: attribute,
    );
  }

  logAdvanceEMIKnowMoreClick() {
    _analyticsMixin.trackWebEngageEventWithAttribute(
      eventName: _knowMore,
      attributeName: {
        "emi_fast_track_home_screen": true,
      },
    );
  }

  logAdvanceEMICTALoadedEvent({
    required String noOfEMIs,
    required String advanceEMIDueAmount,
    required String loanId,
  }) {
    Map<String, dynamic> attribute = {};
    if (noOfEMIs == "1") {
      attribute.addAll({
        "upcoming_due_home_page_single": true,
        "amount": advanceEMIDueAmount,
        "loan_id": loanId,
      });
    } else {
      attribute["upcoming_due_home_page_multiple"] = true;
    }
    _analyticsMixin.trackWebEngageEventWithAttribute(
      eventName: WebEngageConstants.ctaLoaded,
      attributeName: attribute,
    );
  }

  logOverdueCTALoadedEvent({
    required int noOfLoans,
    required String overDueAmount,
    required String loanId,
    required String daysPastDue,
  }) {
    Map<String, dynamic> attribute = {};
    if (noOfLoans == 1) {
      attribute = {
        "overdue_home_single": true,
        "overdue_amount": overDueAmount,
        "days_past_due": daysPastDue,
        "LAN": loanId,
      };
    } else {
      attribute["overdue_home_multiple"] = true;
    }
    _analyticsMixin.trackWebEngageEventWithAttribute(
      eventName: WebEngageConstants.ctaLoaded,
      attributeName: attribute,
    );
  }

  logOverduePayNowCTAClickedEvent({
    required String noOfLoans,
    required String loanId,
    required String loanAmount,
  }) {
    Map<String, dynamic> attribute = {};
    if (noOfLoans == "1") {
      attribute = {
        "single": true,
        "loanId": loanId,
        "amount": loanAmount,
      };
    } else {
      attribute["multiple"] = true;
    }
    _analyticsMixin.trackWebEngageEventWithAttribute(
      eventName: _ctaPayHomescreenOverdue,
      attributeName: attribute,
    );
  }

  logOverduePayAmountClickedEvent({
    required String overDueAmount,
    required String loanId,
  }) {
    _analyticsMixin.trackWebEngageEventWithAttribute(
        eventName: WebEngageConstants.ctaPayAmountClicked,
        attributeName: {
          "overdue_home": true,
          "overdue_amount": overDueAmount,
          "loan_id": loanId,
        });
  }

  logWithdrawalPollingLoaded() {
    _analyticsMixin.trackWebEngageEventWithAttribute(
        eventName: WebEngageConstants.disbursalPollingLoaded,
        attributeName: {
          'home_screen': true,
        });
  }

  logWithdrawalFailureLoaded() {
    _analyticsMixin.trackWebEngageEventWithAttribute(
        eventName: WebEngageConstants.disbursalFailureLoaded,
        attributeName: {
          'home_screen': true,
        });
  }

  logWithdrawalRetryClicked() {
    _analyticsMixin.trackWebEngageEventWithAttribute(
        eventName: WebEngageConstants.retryWithdrawalClicked,
        attributeName: {
          'home_screen': true,
        });
  }

  logWithdrawalMaximizedClicked(bool isFailed) {
    _analyticsMixin.trackWebEngageEventWithAttribute(
        eventName: WebEngageConstants.withdrawalMaximised,
        attributeName: {
          isFailed ? 'failed' : 'polling': true,
        });
  }

  logEventsOnCardLoaded(String screenType) {
    switch (screenType) {
      case REJECTION:
        _analyticsMixin.trackWebEngageEventWithAttribute(
            eventName: WebEngageConstants.homepageRejectedCard);
        break;
      case CREDIT_LINE_EXPIRY:
        _analyticsMixin.trackWebEngageEventWithAttribute(
            eventName: WebEngageConstants.homepageExpiredCard,
            attributeName: {
              "creditline_expiry": true,
            });
        break;
      case OFFER_EXPIRY:
        _analyticsMixin.trackWebEngageEventWithAttribute(
            eventName: WebEngageConstants.homepageExpiredCard,
            attributeName: {
              "offer_expiry": true,
            });
        break;
      default:
    }
  }

  logEnteredHomeScreen(List<LpcCard> lpcCards) {
    _analyticsMixin.trackWebEngageUser(
      userAttributeName: "lpc_list",
      userAttributeValue:
          lpcCards.map((e) => e.loanProductCode).toList().join("_"),
    );
    _analyticsMixin.trackWebEngageEventWithAttribute(
      eventName: "Home Screen Cards Loaded",
      attributeName: {
        "no_of_cards": lpcCards.length,
        "lpc_list": lpcCards.map((e) => e.loanProductCode).toList().join("_"),
      },
    );
  }

  ///top up events
  void logOfferZoneLoaded(LPCCardType type) {
    switch (type) {
      case LPCCardType.topUp:
      case LPCCardType.lowngrow:
        _analyticsMixin.trackWebEngageEventWithAttribute(
          eventName: _offerZoneLoaded,
          attributeName: {
            "type": type.name,
          },
        );
        break;
      case LPCCardType.loan:
        break;
    }
  }

  void logOfferZoneGetNowClicked() {
    _analyticsMixin.trackWebEngageEventWithAttribute(
      eventName: _offerZoneGetNowClicked,
    );
  }
}
