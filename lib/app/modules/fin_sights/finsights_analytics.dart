import 'package:privo/app/mixin/app_analytics_mixin.dart';
import 'package:privo/app/services/lpc_service.dart';

mixin FinsightsAnalytics on AppAnalyticsMixin {
  late final String finsightsHomeScreenLoaded = "Finsights_Home_Screen_Loaded";
  late final String finsightsIconClicked = "Finsights_Icon_Clicked";
  late final String finsightsInfoPageLoaded = "Finsights_Info_Page_Loaded";
  late final String finsightsGetStartedClicked =
      "Finsights_Get_Started_Clicked";
  late final String finsightsBankSelectionLoaded =
      "Finsights_Bank_Selection_Loaded";
  late final String finsightsBankSelected = "Finsights_Bank_Selected";
  late final String finsightsBankNotFoundClicked =
      "Finsights_Bank_Not_Found_Clicked";
  late final String finsightsBankNameEntered = "Finsights_Bank_Name_Entered";
  late final String finsightsLoadingInsightsScreen =
      "Finsights_Loading_Insights_Screen";
  late final String finsightsDataLoaded = "Finsights_Data_Loaded";
  late final String finsightsDataYourFinances = "Finsights_Data_Your_Finances";
  late final String finsightsDataTopTransactions =
      "Finsights_Data_Top_Transactions";
  late final String finsightsDataClosingBalanceInfoClicked =
      "Finsights_Data_Closing_Balance_Info_Clicked";
  late final String finsightsGraphNoTransactions =
      "Finsights_Graph_No_Transactions";
  late final String finsightsGraphErrorOccurred =
      "Finsights_Graph_Error_Occured";
  late final String finsightsDataPageLoading = "Finsights_Data_Page_Loading";
  late final String finsightsDataPageLoadingError =
      "Finsights_Data_Page_Loading_Error";
  late final String finsightsAAFailedPage = "Finsights_AA_Failed_Page";
  late final String finsightsDataShowOption = "Finsights_Data_Show_Option";
  late final String finsightsDataTopTransactionsMonthToggle =
      "Finsights_Data_Top_Transactions_Month_Toggle";
  late final String playStorePromptedFinsights =
      "Play_Store_Prompted_Finsights";
  late final String ffTrackNowClicked = "FF_Track_Now_Clicked";
  late final String ffTrackLaterClicked = "FF_Track_Later_Clicked";
  late final String ffTCrossButtonClicked = "FF_Cross_Button_Clicked";
  late final String feedbackBackClickedIntro = "Feedback_Back_Clicked_Intro";
  late final String feedbackBackClickedBankSelection =
      "Feedback_Back_Clicked_Bank_Selection";
  late final String finsightsMobileNumberInputLoaded =
      "Finsights_Mobile_Number_Input_Loaded";
  late final String finsightsMobileNumberInputContinueClicked =
      "Finsights_Mobile_Number_Input_Continue_Clicked";

  void logFinsightsDataShowOption(bool showOption) {
    trackWebEngageEventWithAttribute(
        eventName: finsightsDataShowOption,
        attributeName: {"show_options": showOption});
  }

  void logFinsightsHomeScreenLoaded() {
    trackWebEngageEventWithAttribute(
      eventName: finsightsHomeScreenLoaded,
    );
  }

  ///[userType] should be "first_time/recurring_user"
  void logFinsightsIconClicked(String userType) {
    trackWebEngageEventWithAttribute(
      eventName: finsightsIconClicked,
      attributeName: {
        "user": userType,
      },
    );
  }

  ///[entryPoint] should be "home_page/info_button"
  void logFinsightsInfoPageLoaded(String entryPoint) {
    trackWebEngageEventWithAttribute(
      eventName: finsightsInfoPageLoaded,
      attributeName: {
        "entry_point": entryPoint,
      },
    );
  }

  void logFinsightsGetStartedClicked() {
    trackWebEngageEventWithAttribute(
      eventName: finsightsGetStartedClicked,
    );
  }

  void logFinsightsBankSelectionLoaded() {
    trackWebEngageEventWithAttribute(
      eventName: finsightsBankSelectionLoaded,
    );
  }

  void logFinsightsBankSelected() {
    trackWebEngageEventWithAttribute(
      eventName: finsightsBankSelected,
    );
  }

  void logFinsightsBankNotFoundClicked() {
    trackWebEngageEventWithAttribute(
      eventName: finsightsBankNotFoundClicked,
    );
  }

  void logFinsightsBankNameEntered(String bankName) {
    trackWebEngageEventWithAttribute(
      eventName: finsightsBankNameEntered,
      attributeName: {
        "bank_name": bankName,
      },
    );
  }

  void logFinsightsLoadingInsightsScreen() {
    trackWebEngageEventWithAttribute(
      eventName: finsightsLoadingInsightsScreen,
    );
  }

  void logFinsightsDataLoaded() {
    trackWebEngageEventWithAttribute(
      eventName: finsightsDataLoaded,
    );
  }

  void logFinsightsDataYourFinances(int monthCount) {
    trackWebEngageEventWithAttribute(
      eventName: finsightsDataYourFinances,
      attributeName: {
        "options": 'last_${monthCount}_months',
      },
    );
  }

  void logFinsightsDataTopTransactions({String? transactionType}) {
    trackWebEngageEventWithAttribute(
      eventName: finsightsDataTopTransactions,
      attributeName: {"options": transactionType},
    );
  }

  void logFinsightsDataClosingBalanceInfoClicked() {
    trackWebEngageEventWithAttribute(
      eventName: finsightsDataClosingBalanceInfoClicked,
    );
  }

  void logFinsightsGraphNoTransactions() {
    trackWebEngageEventWithAttribute(
      eventName: finsightsGraphNoTransactions,
    );
  }

  void logFinsightsGraphErrorOccurred() {
    trackWebEngageEventWithAttribute(
      eventName: finsightsGraphErrorOccurred,
    );
  }

  void logFinsightsDataPageLoading() {
    trackWebEngageEventWithAttribute(
      eventName: finsightsDataPageLoading,
    );
  }

  void logFinsightsDataPageLoadingError(String endpoint) {
    trackWebEngageEventWithAttribute(
      eventName: finsightsDataPageLoadingError,
      attributeName: {
        "endpoint": endpoint,
      },
    );
  }

  void logFinsightsAAFailedPage() {
    trackWebEngageEventWithAttribute(
      eventName: finsightsAAFailedPage,
    );
  }

  void logFinsightsDataTopTransactionsMonthToggle(String month) {
    trackWebEngageEventWithAttribute(
        eventName: finsightsDataTopTransactionsMonthToggle,
        attributeName: {'month': month});
  }

  void logffTrackNowClicked() {
    trackWebEngageEventWithAttribute(
      eventName: ffTrackNowClicked,
      attributeName: {'lpc': LPCService.instance.activeCard?.loanProductCode},
    );
  }

  void logffTrackLaterClicked() {
    trackWebEngageEventWithAttribute(
      eventName: ffTrackLaterClicked,
      attributeName: {'lpc': LPCService.instance.activeCard?.loanProductCode},
    );
  }

  void logffCrossButtonClicked() {
    trackWebEngageEventWithAttribute(
      eventName: ffTCrossButtonClicked,
      attributeName: {'lpc': LPCService.instance.activeCard?.loanProductCode},
    );
  }

  void logFeedbackBackClickedIntro(String reason) {
    trackWebEngageEventWithAttribute(
      eventName: feedbackBackClickedIntro,
      attributeName: {
        'reason': reason,
        'lpc': LPCService.instance.activeCard?.loanProductCode
      },
    );
  }

  void logFeedbackBackClickedBankSelection(String reason) {
    trackWebEngageEventWithAttribute(
      eventName: feedbackBackClickedBankSelection,
      attributeName: {
        'reason': reason,
        'lpc': LPCService.instance.activeCard?.loanProductCode
      },
    );
  }

  logWebEvents(String eventName, String eventMessage) {
    trackWebEngageEventWithAttribute(
      eventName: "AA_WEB_$eventName",
      attributeName: {"eventMessage": eventMessage},
    );
  }

  void logFinsightsMobileNumberInputContinueClicked() {
    trackWebEngageEventWithAttribute(
      eventName: finsightsMobileNumberInputContinueClicked,
    );
  }

  void logFinsightsMobileNumberInputLoaded() {
    trackWebEngageEventWithAttribute(
      eventName: finsightsMobileNumberInputLoaded,
    );
  }

}
