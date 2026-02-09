import 'package:privo/app/mixin/app_analytics_mixin.dart';

class ReportIssueAnalyticsMixin {
  final _analyticsMixin = AppAnalyticsMixin();

  late final String raiseIssueCardLoaded = "Raise_Issue_Card_Loaded";
  late final String raiseIssueCardClicked = "Raise_Issue_Card_Clicked";
  late final String raiseIssueFAQSupportCardClicked =
      "Raise_Issue_FAQ_Support_Card_Clicked";
  late final String describeIssueCardLoaded = "Describe_Issue_Card_Loaded";
  late final String describeIssueSubmitted = "Describe_Issue_Submitted";
  late final String describeIssueApiFail = "Describe_Issue_API_Fail";

  void logRaiseIssueCardLoaded(String screenName) {
    _analyticsMixin.trackWebEngageEventWithAttribute(
        eventName: raiseIssueCardLoaded,
        attributeName: {
          "screen_name": screenName,
        });
  }

  void logRaiseIssueCardClicked(String buttonName) {
    _analyticsMixin.trackWebEngageEventWithAttribute(
        eventName: raiseIssueCardClicked,
        attributeName: {
          buttonName: true,
        });
  }

  void logRaiseIssueFAQSupportCardClicked() {
    _analyticsMixin.trackWebEngageEventWithAttribute(
      eventName: raiseIssueFAQSupportCardClicked,
    );
  }

  void logDescribeIssueCardLoaded(String entryPoint) {
    _analyticsMixin.trackWebEngageEventWithAttribute(
        eventName: describeIssueCardLoaded,
        attributeName: {
          entryPoint: true,
        });
  }

  void logDescribeIssueSubmitted(String description) {
    _analyticsMixin.trackWebEngageEventWithAttribute(
        eventName: describeIssueSubmitted,
        attributeName: {
          "description": description,
        });
  }

  void logDescribeIssueApiFail() {
    _analyticsMixin.trackWebEngageEventWithAttribute(
      eventName: describeIssueApiFail,
    );
  }
}
