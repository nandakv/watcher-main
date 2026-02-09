import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:privo/app/modules/faq/faq_model.dart';
import 'package:privo/app/modules/on_boarding/mixins/app_form_mixin.dart';
import 'package:privo/app/modules/report_issue/report_issue_analytics_mixin.dart';
import 'package:privo/app/routes/app_pages.dart';
import 'package:url_launcher/url_launcher_string.dart';
import '../../api/api_error_mixin.dart';
import '../../data/provider/auth_provider.dart';
import '../../firebase/analytics.dart';
import '../../utils/web_engage_constant.dart';
import '../report_issue/report_issue_widget.dart';

class HelpAndSupportLogic extends GetxController
    with ApiErrorMixin, AppFormMixin, ReportIssueAnalyticsMixin {
  GlobalKey<ScaffoldState> homePageScaffoldKey = GlobalKey<ScaffoldState>();

  late String loanId;
  late String appFormId;
  late bool showLoanCancellation;

  late final String helpAndSupportScreen = "help_and_support";
  late final String RAISE_AN_ISSUE_ID = "RAISE_AN_ISSUE_ID";

  bool _isReportIssueEnabled = false;

  bool get isReportIssueEnabled => _isReportIssueEnabled;

  set isReportIssueEnabled(bool value) {
    _isReportIssueEnabled = value;
    update([RAISE_AN_ISSUE_ID]);
  }

  List<FAQ> faqs = [
    FAQ(
        question: "Where is the Privo App? What is Credit Saison India?",
        answer:
            "The Privo app has evolved into the Credit Saison India mobile app! Credit Saison India, the parent company of Privo, has given the app a fresh new name and even more features. Plus, Credit Saison India is an RBI-registered, AAA-rated NBFC, so you can trust you’re in good hands!"),
    FAQ(
        question:
            "Do I need to worry about my loan details with this change of app name?",
        answer:
            "Not at all! Your loan details, terms, and conditions stay exactly the same. The rebranding doesn’t change a thing about your existing agreements. It’s like changing the wrapper but keeping the same delicious chocolate inside!"),
    FAQ(
        question:
            "How fast can I get my loan through the Credit Saison India app?",
        answer:
            "Lightning fast! For instant personal loans, you get an offer and disbursement in a snap once you complete all the steps. Small business loans might take a bit longer—up to 24 hours—but hey, good things come to those who wait!"),
    FAQ(
        question:
            "What types of loans can I apply for on the Credit Saison India app?",
        answer:
            "Whether you need quick cash for personal use or funds to grow your small business, we’ve got you covered. Apply for an instant personal loan or a small business loan directly through the app. It’s simple, smooth, and super convenient!"),
    FAQ(
        question: "Is the Credit Saison India app RBI compliant?",
        answer:
            "Absolutely! We are registered with RBI and follow all the guidelines laid out by the Reserve Bank of India (RBI). Your financial safety and satisfaction are our top priorities, so you can use the app with confidence and peace of mind."),
  ];

  var arguments = Get.arguments;

  bool fromHomeScreen = false;

  @override
  void onInit() {
    if (arguments != null) {
      loanId = arguments?['loanID'] ?? "";
      appFormId = arguments?['appFormID'] ?? "";
      showLoanCancellation = arguments?['showLoanCancellation'] ?? false;
    }

    _sendWebengageEventOnOpen();
    _checkReportIssueEnabled();
    super.onInit();
  }

  void _sendWebengageEventOnOpen() {
    AppAnalytics.trackWebEngageEventWithAttribute(
      eventName: WebEngageConstants.supportPageLoaded,
      attributeName: {
        _computeWebEngageAttribute(): true,
      },
    );
  }

  _checkReportIssueEnabled() async {
    isReportIssueEnabled = await AppAuthProvider.isReportIssueEnabled;
  }

  String _computeWebEngageAttribute() {
    if (isUserFromLoanDetails) {
      if (showLoanCancellation) {
        return "cancellation_cta_included";
      }
      return "cancellation_cta_excluded";
    }
    return "home_page";
  }

  void openDrawer() {
    if (homePageScaffoldKey.currentState != null) {
      homePageScaffoldKey.currentState!.openDrawer();
    }
  }

  Future<bool> onBackPressed() async {
    if (isUserFromLoanDetails) {
      Get.back();
      return false;
    }

    return true;
  }

  onContactDetailsClicked() {
    AppAnalytics.trackWebEngageEventWithAttribute(
      eventName: WebEngageConstants.callSupportClicked,
      attributeName: {
        (isUserFromLoanDetails ? "cancellation_page" : "home_page"): true,
      },
    );
    launchUrlString('tel:18001038961', mode: LaunchMode.externalApplication);
  }

  onSeeMoreFAQsClicked() {
    AppAnalytics.trackWebEngageEventWithAttribute(
      eventName: WebEngageConstants.seeMoreFAQ,
      attributeName: {
        (isUserFromLoanDetails ? "cancellation_page" : "home_page"): true,
      },
    );
    launchUrlString('https://creditsaison.in/faq/',
        mode: LaunchMode.externalApplication);
  }

  onEmailClicked() {
    AppAnalytics.trackWebEngageEventWithAttribute(
      eventName: WebEngageConstants.emailSupportClicked,
      attributeName: {
        (isUserFromLoanDetails ? "cancellation_page" : "home_page"): true,
      },
    );
    launchUrlString("mailto:support@creditsaison-in.com");
  }

  onLoanCancellationClicked() {
    AppAnalytics.trackWebEngageEventWithAttribute(
      eventName: WebEngageConstants.loanCancellationClicked,
    );

    _goToLoanCancellation();
  }

  onRaiseIssueTapped() {
    fromHomeScreen = arguments['isFromHomePage'] ?? false;
    logRaiseIssueFAQSupportCardClicked();
    Get.bottomSheet(
      ReportIssueWidget(
        screenName: helpAndSupportScreen,
        fromHomeScreen: fromHomeScreen,
      ),
      enableDrag: false,
      isScrollControlled: true,
    );
    logDescribeIssueCardLoaded("raise_issue_faq_support_card");
  }

  _goToLoanCancellation() {
    Get.toNamed(Routes.LOANS_CANCELLATION, arguments: {
      "loanId": loanId,
      "appFormID": appFormId,
    });
  }

  bool get isUserFromLoanDetails {
    return loanId.isNotEmpty;
  }
}
