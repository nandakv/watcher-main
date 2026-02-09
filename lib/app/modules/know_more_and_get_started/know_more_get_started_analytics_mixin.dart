import 'package:privo/app/modules/know_more_and_get_started/know_more_get_started_logic.dart';
import 'package:privo/app/modules/on_boarding/mixins/app_form_mixin.dart';

import '../../mixin/app_analytics_mixin.dart';

mixin KnowMoreGetStartedAnalyticsMixin on AppAnalyticsMixin {
  late final String homeProductKnowMoreClicked =
      "Home_Product_Know_More_Clicked";
  late final String homeProductGetStartedClicked =
      "Home_Product_Get_Started_Clicked";
  late final String knowMoreVocMoved = "Know_More_VOC_Moved";
  late final String knowMoreFaqClicked = "Know_More_FAQ_Clicked";
  late final String knowMoreGetStartedClicked = "Know_More_Get_Started_Clicked";
  late final String knowMoreDocumentIClicked = "Know_More_Document_i_Clicked";
  late final String getStartedLoaded = "Get_Started_Loaded";
  late final String getStartedRequirementSubmitted =
      "Get_Started_Requirement_Submitted";
  late final String getStartedDocumentIClicked =
      "Get_Started_Document_i_Clicked";

  void logEventsOnInit(
      LoanProductCode lpc, KnowMoreGetStartedState knowMoreGetStartedState) {
    late String eventName;
    switch (knowMoreGetStartedState) {
      case KnowMoreGetStartedState.knowMore:
        eventName = homeProductKnowMoreClicked;
        break;
      case KnowMoreGetStartedState.getStarted:
        eventName = homeProductGetStartedClicked;
        logGetStartedLoaded(lpc);
        break;
    }
    trackWebEngageEventWithAttribute(
      eventName: eventName,
      attributeName: {
        "product_name": lpc.name,
      },
    );
  }

  void logKnowMoreVocMoved(LoanProductCode lpc) {
    trackWebEngageEventWithAttribute(
      eventName: knowMoreVocMoved,
      attributeName: {
        "product_name": lpc.name,
      },
    );
  }

  void logKnowMoreFaqClicked(LoanProductCode lpc) {
    trackWebEngageEventWithAttribute(
      eventName: knowMoreFaqClicked,
      attributeName: {
        "product_name": lpc.name,
      },
    );
  }

  void logKnowMoreGetStartedClicked(LoanProductCode lpc) {
    trackWebEngageEventWithAttribute(
      eventName: knowMoreGetStartedClicked,
      attributeName: {
        "product_name": lpc.name,
      },
    );
  }

  void logDocumentIClicked(LoanProductCode lpc, KnowMoreGetStartedState state) {
    late final String eventName;
    switch (state) {
      case KnowMoreGetStartedState.knowMore:
        eventName = knowMoreDocumentIClicked;
        break;
      case KnowMoreGetStartedState.getStarted:
        eventName = getStartedDocumentIClicked;
        break;
    }
    trackWebEngageEventWithAttribute(
      eventName: eventName,
      attributeName: {
        "product_name": lpc.name,
      },
    );
  }

  void logGetStartedLoaded(LoanProductCode lpc) {
    trackWebEngageEventWithAttribute(
      eventName: getStartedLoaded,
      attributeName: {
        "product_name": lpc.name,
      },
    );
  }

  void logGetStartedRequirementSubmitted(
      LoanProductCode lpc, String amount, String purpose, String tenure) {
    trackWebEngageEventWithAttribute(
      eventName: getStartedRequirementSubmitted,
      attributeName: {
        "product_name": lpc.name,
        "amount": amount,
        "purpose": purpose,
        "tenure": tenure
      },
    );
  }
}
