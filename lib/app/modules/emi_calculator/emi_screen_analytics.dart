import 'package:privo/app/mixin/app_analytics_mixin.dart';
import 'package:privo/app/utils/web_engage_constant.dart';

mixin EmiScreenAnalytics {

  //Emi Calculator
  static const String emiCalculatorLoaded = "EMI_Calculator_Loaded";
  static const String emiCalculatorClicked = "EMI_Calculator_Clicked";
  static const String productCardsScreenLoaded = "Product_Cards_Screen_Loaded";
  static const String productCardsScreenClicked = "Product_Cards_Screen_Clicked";
  static const String emiCalculatorScreenLoaded = "EMI_Calculator_Screen_Loaded";
  static const String questionProductClicked = "Question_Product_Clicked";
  static const String emiCalculatorScreenClosed = "EMI_Calculator_Screen_Closed";

  final _analyticsMixin = AppAnalyticsMixin();

  logEmiCalculatorClicked() {
    _analyticsMixin.trackWebEngageEventWithAttribute(
        eventName: emiCalculatorClicked);
  }

  logEmiCalculatorLoaded() {
    _analyticsMixin.trackWebEngageEventWithAttribute(
        eventName: emiCalculatorLoaded);
  }

  logProductCardsScreenLoaded() {
    _analyticsMixin.trackWebEngageEventWithAttribute(
        eventName: productCardsScreenLoaded);
  }

  logProductCardsScreenClicked(String productName) {
    _analyticsMixin.trackWebEngageEventWithAttribute(
        eventName: productCardsScreenClicked,
        attributeName: {'product': productName});
  }

  logEmiCalculatorScreenLoaded(String productName) {
    _analyticsMixin.trackWebEngageEventWithAttribute(
        eventName: emiCalculatorLoaded,
        attributeName: {'product': productName});
  }

  logQuestionProductClicked(String productName) {
    _analyticsMixin.trackWebEngageEventWithAttribute(
        eventName: questionProductClicked,
        attributeName: {'product': productName});
  }

  void logEmiCalculatorClosed(
      String amount, String roi, String emi, String principal) {
    _analyticsMixin.trackWebEngageEventWithAttribute(
      eventName: emiCalculatorScreenClosed,
      attributeName: {
        'amount': amount,
        'roi': roi,
        'emi': emi,
        'principal': principal
      },
    );
  }
}
