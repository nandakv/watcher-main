import 'package:privo/app/mixin/app_analytics_mixin.dart';

mixin OfferAnalyticsMixin on AppAnalyticsMixin{
  late final String  jarvisLoanDetailsLoaded = "Jarvis_Loan_Details_Loaded_BL";
  late final String  vasTickedBl = "VAS_Ticked_BL";



  void onJarvisLoanDetailsLoaded(Map<String, dynamic> eventBody){
    trackWebEngageEventWithAttribute(eventName: jarvisLoanDetailsLoaded,attributeName: eventBody);
  }

  void onVasTickedBl(Map<String, dynamic> eventBody){
    trackWebEngageEventWithAttribute(eventName: vasTickedBl,attributeName: eventBody);
  }
}