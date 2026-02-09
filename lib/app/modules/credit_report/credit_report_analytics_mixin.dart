import 'package:privo/app/models/home_screen_model.dart';
import 'package:privo/app/modules/credit_report/model/credit_report_model.dart';

import '../../mixin/app_analytics_mixin.dart';
import 'credit_report_helper_mixin.dart';

enum CreditReportUserState {
  notEnrolled,
  enrolledWithRefreshAvailable,
  enrolledWithRefreshNotAvailable,
}

class CreditReportAnalyticsMixin {
  final _appAnalytics = AppAnalyticsMixin();

  late final String creditScoreD2CLoadedHome = "Credit_Score_D2C_Loaded_Home";
  late final String creditScoreD2CLoadedHomeAldSuccRefreshAvailable =
      "Credit_Score_D2C_Loaded_Home_Ald_Succ_Refresh_Avail";
  late final String creditScoreD2CLoadedHomeAldSuccRefreshUnAvailable =
      "Credit_Score_D2C_Loaded_Home_Ald_Succ_Refresh_Unavail";

  late final String creditScoreD2CClickedHome = "Credit_Score_D2C_Home_Clicked";
  late final String creditScoreD2CClickedHomeAldSuccRefreshAvailable =
      "Credit_Score_D2C_Clicked_Home_Ald_Succ_Refresh_Avail";
  late final String creditScoreD2CClickedHomeAldSuccRefreshUnAvailable =
      "Credit_Score_D2C_Clicked_Home_Ald_Succ_Refresh_Unavail";

  CreditReportUserState getCreditReportUserState(
      CreditScoreModel creditScoreModel) {
    if (creditScoreModel.isFreshPullDone) {
      if (creditScoreModel.refreshAvailable) {
        return CreditReportUserState.enrolledWithRefreshAvailable;
      } else {
        return CreditReportUserState.enrolledWithRefreshNotAvailable;
      }
    } else {
      return CreditReportUserState.notEnrolled;
    }
  }

  logCreditScoreD2CLoadedHome(CreditScoreModel creditScoreModel) {
    final CreditReportUserState userState =
        getCreditReportUserState(creditScoreModel);
    final Map<CreditReportUserState, String> eventMapping = {
      CreditReportUserState.notEnrolled: creditScoreD2CLoadedHome,
      CreditReportUserState.enrolledWithRefreshAvailable:
          creditScoreD2CLoadedHomeAldSuccRefreshAvailable,
      CreditReportUserState.enrolledWithRefreshNotAvailable:
          creditScoreD2CLoadedHomeAldSuccRefreshUnAvailable,
    };
    String? eventName = eventMapping[userState];
    if (eventName != null) {
      _appAnalytics.trackWebEngageEventWithAttribute(
        eventName: eventName,
      );
    }
  }

  logCreditScoreD2CClickedHome(CreditScoreModel creditScoreModel) {
    final CreditReportUserState userState =
        getCreditReportUserState(creditScoreModel);
    final Map<CreditReportUserState, String> eventMapping = {
      CreditReportUserState.notEnrolled: creditScoreD2CClickedHome,
      CreditReportUserState.enrolledWithRefreshAvailable:
          creditScoreD2CClickedHomeAldSuccRefreshAvailable,
      CreditReportUserState.enrolledWithRefreshNotAvailable:
          creditScoreD2CClickedHomeAldSuccRefreshUnAvailable,
    };
    String? eventName = eventMapping[userState];
    if (eventName != null) {
      _appAnalytics.trackWebEngageEventWithAttribute(
        eventName: eventName,
      );
    }
  }

  late final String creditScoreIntroLoaded = "Credit_Score_Intro_Loaded";
  late final String creditScoreIntroContinueClickedNoConsent =
      "Credit_Score_Intro_Continue_Clicked_NoConsent";
  late final String creditScoreIntroConsentLoaded =
      "Credit_Score_Intro_Consent_Loaded";
  late final String creditScoreIntroAcceptedClickedConsent =
      "Credit_Score_Intro_Accepted_Clicked_Consent";
  late final String creditScoreIntroBackClicked =
      "Credit_Score_Intro_Back_Clicked";
  late final String creditScorePollingLoaded = "Credit_Score_Polling_Loaded";
  late final String creditScorePollingClosed = "Credit_Score_Polling_Closed";
  late final String creditScoreFailureLoaded = "Credit_Score_Failure_Loaded";
  late final String creditScoreFailureClosed = "Credit_Score_Failure_Closed";
  late final String creditScoreFailureTryAgainClicked =
      "Credit_Score_Failure_Try_Again_Clicked";
  late final String creditScoreSuccessLoaded = "Credit_Score_Success_Loaded";
  late final String creditScoreD2CSuccessLoaded =
      "Credit_Score_D2C_Success_Loaded";
  late final String creditScoreSuccessViewDetailsClicked =
      "Credit_Score_Success_ViewDetailsClicked";
  late final String creditScoreSuccessClosed = "Credit_Score_Success_Closed";
  late final String creditScoreReportHomepageLoadedRefreshAvail =
      "Credit_Score_Homepage_Loaded_Refresh_Avail";
  late final String creditScoreReportHomepageLoadedRefreshUnAvail =
      "Credit_Score_Homepage_Loaded_Refresh_Unavail";
  late final String creditScoreReportHomeViewAllClicked =
      "Credit_Score_Report_Home_ViewAll_Clicked";
  late final String creditScoreReportHomeClosed =
      "Credit_Score_Report_Home_Closed";
  late final String creditScoreReportHomeScoreiClicked =
      "Credit_Score_Report_Home_Score_i_Clicked";
  late final String creditScoreReportHomeNextUpdateiLoaded =
      "Credit_Score_Report_Home_Next_Update_i_Loaded";
  late final String creditScoreReportHomeNextUpdateiClicked =
      "Credit_Score_Report_Home_Next_Update_i_Clicked";
  late final String creditScoreReportHomeNextUpdateLoaded =
      "Credit_Score_Report_Home_Next_Update_Loaded";
  late final String creditScoreReportHomeLoanCardClicked =
      "Credit_Score_Report_Home_LoanCard_Clicked";
  late final String creditScoreReportHomeCreditCardCardClicked =
      "Credit_Score_Report_Home_CreditCardCard_Clicked";
  late final String creditScoreReportViewAllLoaded =
      "Credit_Score_Report_ViewAll_Loaded";
  late final String creditScoreReportViewAllLoanCardClicked =
      "Credit_Score_Report_ViewAll_LoanCard_Clicked";
  late final String creditScoreReportViewAllCreditCardClicked =
      "Credit_Score_Report_ViewAll_CreditCard_Clicked";
  late final String creditScoreReportViewAllClosed =
      "Credit_Score_Report_ViewAll_Closed";
  late final String creditScoreReportViewAllCreditCardTabClicked =
      "Credit_Score_Report_ViewAll_CreditCardTab_Clicked";
  late final String creditScoreReportViewAllLoanTabClicked =
      "Credit_Score_Report_ViewAll_LoanTab_Clicked";
  late final String creditScoreReportAccountDetailsLoanLoaded =
      "Credit_Score_Report_AccountDetails_Loan_Loaded";
  late final String creditScoreReportAccountDetailsCreditCardLoaded =
      "Credit_Score_Report_AccountDetails_CreditCard_Loaded";
  late final String creditScoreConsentExpiredLoaded =
      "Credit_Score_Consent_Expired_Loaded";
  late final String creditScoreConsentExpiredAcceptClicked =
      "Credit_Score_Consent_Expired_Accept_Clicked";
  late final String creditScoreConsentExpiredClosed =
      "Credit_Score_Consent_Expired_Closed";
  late final String playStorePromptedCreditScore =
      "Play_Store_Prompted_Credit_Score";

  late final String creditScoreRefreshAvailable =
      "Credit_Score_Refresh_Available";
  late final String creditScoreRefreshClicked = "Credit_Score_Refresh_Clicked";
  late final String creditScoreRefreshFailed = "Credit_Score_Refresh_Failed";
  late final String creditScoreRefreshSuccess = "Credit_Score_Refresh_Success";
  late final String creditScore5KeyLoaded = "Credit_Score_5Key_Loaded";
  late final String creditScore5KeyClicked = "Credit_Score_5Key_Clicked";
  late final String creditScore5KeyMetricPageLoaded =
      "Credit_Score_5Key_Metric_Page_Loaded";

  late final String creditScorePollingLoadedForRefresh =
      "Credit_Score_Polling_Loaded_For_Refresh";
  late final String creditScoreD2CRefreshPromptLoaded =
      "Credit_Score_D2C_Refresh_Prompt_Loaded";
  late final String creditScoreD2CRefreshPromptCTAClicked =
      "Credit_Score_D2C_Refresh_Prompt_CTA_Clicked";
  late final String creditScoreD2CRefreshPromptClosed =
      "Credit_Score_D2C_Refresh_Prompt_Closed";
  late final String creditScoreD2CRefreshPromptSuccessLoaded =
      "Credit_Score_D2C_Refresh_Prompt_Success_Loaded";
  late final String creditScoreD2CRefreshPromptInsightsCTAClicked =
      "Credit_Score_D2C_Refresh_Prompt_Insights_CTA_Clicked";
  late final String creditScoreIntroAcceptedClickedNoConsent =
      "Credit_Score_Intro_Accepted_Clicked_NoConsent";
  late final String creditScoreIntroExpiredConsentLoaded =
      "Credit_Score_Intro_Expired_Consent_Loaded";
  late final String creditScoreIntroExpiredConsentAccepted =
      "Credit_Score_Intro_Expired_Consent_Accepted";
  late final String creditScoreIntroExpiredConsentClosed =
      "Credit_Score_Intro_Expired_Consent_Closed";

  // feedback
  late final String csIntroFeedbackLoaded = "CS_Intro_Feedback_Loaded";
  late final String csIntroFeedbackSelectionChange =
      "CS_Intro_Feedback_Selection_Change";
  late final String csIntroFeedbackClosed = "CS_Intro_Feedback_Closed";
  late final String csIntroFeedbackSubmitted = "CS_Intro_Feedback_Submitted";
  late final String creditScoreGraphClicked = "Credit_Score_Graph_Clicked";
  late final String creditScoreGraphDetailsLoaded = "Credit_Score_Graph_Details_Loaded";

  logCSIntroFeedbackLoaded() {
    _appAnalytics.trackWebEngageEventWithAttribute(
      eventName: csIntroFeedbackLoaded,
    );
  }

  logCSIntroFeedbackSelectionChange(String selectedOption) {
    _appAnalytics.trackWebEngageEventWithAttribute(
      eventName: csIntroFeedbackSelectionChange,
      attributeName: {
        "option_selected": selectedOption,
      },
    );
  }

  logCSIntroFeedbackClosed() {
    _appAnalytics.trackWebEngageEventWithAttribute(
      eventName: csIntroFeedbackClosed,
    );
  }

  logCSIntroFeedbackSubmitted(String selectedOption, String otherReason) {
    Map<String, String> attributes = {"selected_feedback": selectedOption};

    if (selectedOption == "Others") {
      attributes["other_reason"] = otherReason;
    }

    _appAnalytics.trackWebEngageEventWithAttribute(
      eventName: csIntroFeedbackSubmitted,
      attributeName: attributes,
    );
  }

  logCreditScoreRefreshAvailable(
      {bool isHome = true, required bool isRefreshAvailable}) {
    if (isRefreshAvailable) {
      _appAnalytics.trackWebEngageEventWithAttribute(
        eventName: creditScoreRefreshAvailable,
        attributeName: {
          (isHome ? "home" : "cs_home"): true,
        },
      );
    }
  }

  logCreditScoreRefreshClicked() {
    _appAnalytics.trackWebEngageEventWithAttribute(
      eventName: creditScoreRefreshClicked,
    );
  }

  logCreditScore5KeyLoaded() {
    _appAnalytics.trackWebEngageEventWithAttribute(
      eventName: creditScore5KeyLoaded,
    );
  }

  logCreditScore5KeyClicked(String keyIndex) {
    _appAnalytics.trackWebEngageEventWithAttribute(
      eventName: creditScore5KeyClicked,
      attributeName: {
        "metric_index": keyIndex,
      },
    );
  }

  logCreditScore5KeyMetricPageLoaded(
      String keyIndex, bool isAnyValueNotAvailableOrZero) {
    _appAnalytics.trackWebEngageEventWithAttribute(
      eventName: creditScore5KeyMetricPageLoaded,
      attributeName: {
        "metric_index": keyIndex,
        "is_any_na_or_zero": isAnyValueNotAvailableOrZero,
      },
    );
  }

  logEventsOnKnowMoreCta(bool withConsent) {
    if (withConsent) {
      _appAnalytics.trackWebEngageEventWithAttribute(
        eventName: creditScoreIntroAcceptedClickedConsent,
      );
    } else {
      _appAnalytics.trackWebEngageEventWithAttribute(
        eventName: creditScoreIntroContinueClickedNoConsent,
      );
      _appAnalytics.trackWebEngageEventWithAttribute(
          eventName: creditScoreIntroAcceptedClickedNoConsent);
    }
  }

  logEventsOnCreditAccountTypeChange(
      {required CreditAccountType creditAccountType,
      required int activeCount,
      required int closedCount}) {
    Map<CreditAccountType, String> eventMapping = {
      CreditAccountType.loan: creditScoreReportViewAllLoanTabClicked,
      CreditAccountType.creditCard:
          creditScoreReportViewAllCreditCardTabClicked,
    };

    if (eventMapping.containsKey(creditAccountType)) {
      String eventName = eventMapping[creditAccountType]!;
      _appAnalytics.trackWebEngageEventWithAttribute(
        eventName: eventName,
        attributeName: {
          "active": activeCount,
          "closed": closedCount,
        },
      );
    }
  }

  logCreditScoreIntroConsentLoaded() {
    _appAnalytics.trackWebEngageEventWithAttribute(
      eventName: creditScoreIntroConsentLoaded,
    );
  }

  logEventsOnScreenChange(CreditReportState currentReportState,
      Map<String, dynamic>? attributes, bool isRefresh) {
    Map<CreditReportState, String> screenEventMapping = {
      CreditReportState.knowMore: creditScoreIntroLoaded,
      CreditReportState.polling: isRefresh
          ? creditScorePollingLoadedForRefresh
          : creditScorePollingLoaded,
      CreditReportState.failure:
          isRefresh ? creditScoreRefreshFailed : creditScoreFailureLoaded,
      CreditReportState.success:
          isRefresh ? creditScoreRefreshSuccess : creditScoreSuccessLoaded,
      CreditReportState.dashboard: isRefresh
          ? creditScoreReportHomepageLoadedRefreshAvail
          : creditScoreReportHomepageLoadedRefreshUnAvail,
      CreditReportState.creditOverview: creditScoreReportViewAllLoaded,
    };

    if (screenEventMapping.containsKey(currentReportState)) {
      String eventName = screenEventMapping[currentReportState]!;
      if (currentReportState == CreditReportState.success &&
          isRefresh == false) {
        _appAnalytics.trackWebEngageEventWithAttribute(
            eventName: creditScoreD2CSuccessLoaded, attributeName: attributes);
      }
      _appAnalytics.trackWebEngageEventWithAttribute(
          eventName: eventName, attributeName: attributes);
    }
  }

  logCreditScoreBackClicked(CreditReportState currentReportState) {
    Map<CreditReportState, String> backEventMapping = {
      CreditReportState.knowMore: creditScoreIntroBackClicked,
      CreditReportState.polling: creditScorePollingClosed,
      CreditReportState.failure: creditScoreFailureClosed,
      CreditReportState.success: creditScoreSuccessClosed,
      CreditReportState.dashboard: creditScoreReportHomeClosed,
      CreditReportState.creditOverview: creditScoreReportViewAllClosed,
    };

    if (backEventMapping.containsKey(currentReportState)) {
      String eventName = backEventMapping[currentReportState]!;
      _appAnalytics.trackWebEngageEventWithAttribute(
        eventName: eventName,
      );
    }
  }

  logCreditScoreReportHomeViewAllClicked() {
    _appAnalytics.trackWebEngageEventWithAttribute(
      eventName: creditScoreReportHomeViewAllClicked,
    );
  }

  logCreditScoreReportHomeScoreiClicked() {
    _appAnalytics.trackWebEngageEventWithAttribute(
      eventName: creditScoreReportHomeScoreiClicked,
    );
  }

  logCreditScoreReportHomeNextUpdateiClicked() {
    _appAnalytics.trackWebEngageEventWithAttribute(
      eventName: creditScoreReportHomeNextUpdateiClicked,
    );
  }

  logCreditScoreReportHomeNextUpdateiLoaded(int ndays) {
    _appAnalytics.trackWebEngageEventWithAttribute(
        eventName: creditScoreReportHomeNextUpdateiLoaded,
        attributeName: {"days": ndays});
  }

  logCreditScoreReportHomeNextUpdateLoaded(String nextUpdateDate) {
    _appAnalytics.trackWebEngageEventWithAttribute(
        eventName: creditScoreReportHomeNextUpdateLoaded,
        attributeName: {
          "next_available_date": nextUpdateDate,
        });
  }

  logEventsOnLoanClicked(
      CreditAccount account, CreditReportState currentReportState) {
    String loanTypeClickedEventName = account.isCreditCard
        ? creditScoreReportHomeCreditCardCardClicked
        : creditScoreReportHomeLoanCardClicked;

    Map<String, String> typeEventMapping = {
      "credit_card: true, prev_state: ${CreditReportState.dashboard}":
          creditScoreReportAccountDetailsCreditCardLoaded,
      "credit_card: false, prev_state: ${CreditReportState.dashboard}":
          creditScoreReportAccountDetailsLoanLoaded,
      "credit_card: true, prev_state: ${CreditReportState.creditOverview}":
          creditScoreReportViewAllCreditCardClicked,
      "credit_card: false, prev_state: ${CreditReportState.creditOverview}":
          creditScoreReportViewAllLoanCardClicked,
    };

    String creditAccountLoadedEventName = typeEventMapping[
            "credit_card: ${account.isCreditCard}, prev_state: $currentReportState"] ??
        "";

    if (creditAccountLoadedEventName == "") {
      return;
    }
    _appAnalytics.trackWebEngageEventWithAttribute(
        eventName: loanTypeClickedEventName,
        attributeName: {account.isLoanClosed ? "closed" : "active": true});

    _appAnalytics.trackWebEngageEventWithAttribute(
        eventName: creditAccountLoadedEventName,
        attributeName: {
          account.isLoanClosed ? "closed" : "active": true,
          "updated_on": account.updatedOn,
          "NA": account.isAnyValueNotAvailable,
        });
  }

  logCreditScoreFailureTryAgainClicked() {
    _appAnalytics.trackWebEngageEventWithAttribute(
      eventName: creditScoreFailureTryAgainClicked,
    );
  }

  logCreditScoreSuccessViewDetailsClicked() {
    _appAnalytics.trackWebEngageEventWithAttribute(
      eventName: creditScoreSuccessViewDetailsClicked,
    );
  }

  logCreditScoreD2CRefreshPromptLoaded() {
    _appAnalytics.trackWebEngageEventWithAttribute(
      eventName: creditScoreD2CRefreshPromptLoaded,
    );
  }

  logCreditScoreD2CRefreshPromptCTAClicked() {
    _appAnalytics.trackWebEngageEventWithAttribute(
      eventName: creditScoreD2CRefreshPromptCTAClicked,
    );
  }

  logCreditScoreD2CRefreshPromptClosed() {
    _appAnalytics.trackWebEngageEventWithAttribute(
      eventName: creditScoreD2CRefreshPromptClosed,
    );
  }

  logCreditScoreD2CRefreshPromptSuccessLoaded() {
    _appAnalytics.trackWebEngageEventWithAttribute(
      eventName: creditScoreD2CRefreshPromptSuccessLoaded,
    );
  }

  logCreditScoreD2CRefreshPromptInsightsCTAClicked() {
    _appAnalytics.trackWebEngageEventWithAttribute(
      eventName: creditScoreD2CRefreshPromptInsightsCTAClicked,
    );
  }

  logCreditScoreIntroExpiredConsentLoaded() {
    _appAnalytics.trackWebEngageEventWithAttribute(
      eventName: creditScoreIntroExpiredConsentLoaded,
    );
  }

  logCreditScoreIntroExpiredConsentAccepted() {
    _appAnalytics.trackWebEngageEventWithAttribute(
      eventName: creditScoreIntroExpiredConsentAccepted,
    );
  }

  logCreditScoreIntroExpiredConsentClosed() {
    _appAnalytics.trackWebEngageEventWithAttribute(
      eventName: creditScoreIntroExpiredConsentClosed,
    );
  }

  logCreditScoreGraphDetailsLoaded() {
    _appAnalytics.trackWebEngageEventWithAttribute(
      eventName: creditScoreGraphDetailsLoaded,
    );
  }

  logCreditScoreGraphClicked(String result) {
    _appAnalytics.trackWebEngageEventWithAttribute(
      eventName: creditScoreGraphClicked,
      attributeName: {
        "result": result,
      },
    );
  }
}
