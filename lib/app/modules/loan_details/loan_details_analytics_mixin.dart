import 'package:privo/app/firebase/analytics.dart';
import 'package:privo/app/mixin/app_analytics_mixin.dart';
import 'package:privo/app/utils/web_engage_constant.dart';

mixin LoanDetailsAnalyticsMixin {
  final _analyticsMixin = AppAnalyticsMixin();

  late final String coiCtaLoaded = "COI_CTA_Loaded";
  late final String statementsCtaLoaded = "Statements_CTA_Loaded";
  late final String nocCtaLoaded = "NOC_CTA_Loaded";
  late final String emiScheduleCtaLoaded = "EMI_Schedule_CTA_Loaded";
  late final String coiClicked = "COI_Clicked";
  late final String statementsClicked = "Statements_Clicked";
  late final String nocClicked = "NOC_Clicked";
  late final String emiScheduleClicked = "EMI_Schedule_Clicked";
  late final String closedLoanLoaded = "Closed_Loan_Loaded";
  late final String activeLoanLoaded = "Active_Loan_Loaded";
  late final String bpiAmountLoaded = "BPI_Amount_Loaded";
  late final String fiveDaysNocTriggered = "Five_Days_NOC_Message_Triggered";
  late final String loanDocumentsClicked = "Loan_Documents_Clicked";
  late final String sanctionLetterClicked = "Sanction_Letter_Clicked";
  late final String agreementLetterClicked = "Agreement_Letter_Clicked";

  logCoiCtaLoaded(String loanId) {
    _analyticsMixin.trackWebEngageEventWithAttribute(
      eventName: coiCtaLoaded,
      attributeName: {
        "LAN": loanId,
      },
    );
  }

  logLoanDocumentsClicked(String loanId) {
    _analyticsMixin.trackWebEngageEventWithAttribute(
      eventName: loanDocumentsClicked,
      attributeName: {
        "LAN": loanId,
      },
    );
  }

  logSanctionLetterClicked(String loanId) {
    _analyticsMixin.trackWebEngageEventWithAttribute(
      eventName: sanctionLetterClicked,
      attributeName: {
        "LAN": loanId,
      },
    );
  }

  logAgreementLetterClicked(String loanId) {
    _analyticsMixin.trackWebEngageEventWithAttribute(
      eventName: agreementLetterClicked,
      attributeName: {
        "LAN": loanId,
      },
    );
  }

  logFiveDaysNocTriggered(String loanId) {
    _analyticsMixin.trackWebEngageEventWithAttribute(
      eventName: fiveDaysNocTriggered,
      attributeName: {
        "LAN": loanId,
      },
    );
  }

  logStatementsCtaLoaded(String loanId) {
    _analyticsMixin.trackWebEngageEventWithAttribute(
      eventName: statementsCtaLoaded,
      attributeName: {
        "LAN": loanId,
      },
    );
  }

  logNocCtaLoaded(String loanId) {
    _analyticsMixin.trackWebEngageEventWithAttribute(
      eventName: nocCtaLoaded,
      attributeName: {
        "LAN": loanId,
      },
    );
  }

  logEmiScheduleCtaLoaded(String loanId) {
    _analyticsMixin.trackWebEngageEventWithAttribute(
      eventName: emiScheduleCtaLoaded,
      attributeName: {
        "LAN": loanId,
      },
    );
  }

  logCoiClicked(String loanId) {
    _analyticsMixin.trackWebEngageEventWithAttribute(
      eventName: coiClicked,
      attributeName: {
        "LAN": loanId,
      },
    );
  }

  logStatementsClicked(String loanId) {
    _analyticsMixin.trackWebEngageEventWithAttribute(
      eventName: statementsClicked,
      attributeName: {
        "LAN": loanId,
      },
    );
  }

  logNocClicked(String loanId) {
    _analyticsMixin.trackWebEngageEventWithAttribute(
      eventName: nocClicked,
      attributeName: {
        "LAN": loanId,
      },
    );
  }

  logEmiScheduleClicked(String loanId) {
    _analyticsMixin.trackWebEngageEventWithAttribute(
      eventName: emiScheduleClicked,
      attributeName: {
        "LAN": loanId,
      },
    );
  }

  logClosedLoanLoaded(String loanID, String loanAmount, bool isInsured) {
    _analyticsMixin.trackWebEngageEventWithAttribute(
      eventName: closedLoanLoaded,
      attributeName: {
        "LAN": loanID,
        "loan_amount": loanAmount,
        "insured": isInsured,
      },
    );
  }

  logActiveLoanLoaded(String loanID, String loanAmount, bool isInsured) {
    _analyticsMixin.trackWebEngageEventWithAttribute(
      eventName: activeLoanLoaded,
      attributeName: {
        "LAN": loanID,
        "loan_amount": loanAmount,
        "insured": isInsured,
      },
    );
  }

  logBPIAmountLoaded(num? bpiAmount) {
    if (bpiAmount != null) {
      _analyticsMixin.trackWebEngageEventWithAttribute(
        eventName: bpiAmountLoaded,
        attributeName: {
          "bpi_amount": bpiAmount.toString(),
        },
      );
    }
  }

  logAdvanceEMICTALoadedEvent({
    required String advanceEMIDueAmount,
    required String loanId,
  }) {
    _analyticsMixin.trackWebEngageEventWithAttribute(
        eventName: WebEngageConstants.ctaLoaded,
        attributeName: {
          "upcoming_due_loan_details": true,
          "amount": advanceEMIDueAmount,
          "loan_id": loanId,
        });
  }

  logOverdueCTALoadedEvent({
    required String overDueAmount,
    required String loanId,
  }) {
    _analyticsMixin.trackWebEngageEventWithAttribute(
        eventName: WebEngageConstants.ctaLoaded,
        attributeName: {
          "overdue_loan_details": true,
          "overdue_amount": overDueAmount,
          "LAN": loanId,
        });
  }

  logOverduePayAmountClickedEvent({
    required String overDueAmount,
    required String loanId,
  }) {
    _analyticsMixin.trackWebEngageEventWithAttribute(
        eventName: WebEngageConstants.ctaPayAmountClicked,
        attributeName: {
          "overdue_loan_details": true,
          "overdue_amount": overDueAmount,
          "LAN": loanId,
        });
  }
}
