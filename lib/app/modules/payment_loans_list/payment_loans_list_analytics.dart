import 'package:privo/app/utils/web_engage_constant.dart';

import '../../mixin/app_analytics_mixin.dart';

mixin PaymentLoansListAnalytics {
  final _analyticsMixin = AppAnalyticsMixin();

  late final String CTAPayClicked = "CTA_Pay_Clicked";
  late final String listOfEmisLoaded = "List_Of_EMIs_Loaded";
  late final String _ctaPayAmountClicked = "CTA_Pay_Amount_Clicked";

  logLoanListScreenLoaded({
    required String noOfLoans,
  }) {
    _analyticsMixin.trackWebEngageEventWithAttribute(
        eventName: WebEngageConstants.loansListScreenLoaded,
        attributeName: {
          "overdue_home": true,
          "no_of_overdue_loans": noOfLoans,
        });
  }

  logLoanListScreenClosed({
    required String noOfLoans,
  }) {
    _analyticsMixin.trackWebEngageEventWithAttribute(
        eventName: WebEngageConstants.loansListScreenClosed,
        attributeName: {
          "overdue_home": true,
          "no_of_overdue_loans": noOfLoans,
        });
  }

  logKnowMoreClicked({
    required String overDueAmount,
    required String noOfLoans,
    required String loanId,
  }) {
    _analyticsMixin.trackWebEngageEventWithAttribute(
        eventName: WebEngageConstants.knowMore,
        attributeName: {
          "overdue_home": true,
          "overdue_amount": overDueAmount,
          "no_of_overdue_loans": noOfLoans,
          "loan_id": loanId,
        });
  }

  logOverduePayClickedEvent({
    required String loanId,
    required String amount,
    required String dpd,
  }) {
    _analyticsMixin.trackWebEngageEventWithAttribute(
      eventName: _ctaPayAmountClicked,
      attributeName: {
        'listscreen_overdue': true,
        'overdue_amount': amount,
        'days_past_due': dpd,
        'LAN': loanId,
      },
    );
  }

  void logCTAPayClicked(String fromPage) {
    _analyticsMixin.trackWebEngageEventWithAttribute(
      eventName: CTAPayClicked,
      attributeName: {fromPage: true},
    );
  }

  void logListOfEmisLoaded(String noOfEMIs) {
    _analyticsMixin.trackWebEngageEventWithAttribute(
      eventName: listOfEmisLoaded,
      attributeName: {'no_of_EMIs': noOfEMIs},
    );
  }
}
