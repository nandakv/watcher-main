import '../../../modules/on_boarding/mixins/app_form_mixin.dart';

class HomePageStepperModel {
  final int appState;
  final LoanProductCode loanProductCode;
  final bool isPartnerFlow;
  final bool isBrowserToAppFlow;

  HomePageStepperModel({
    required this.appState,
    required this.loanProductCode,
    required this.isPartnerFlow,
    required this.isBrowserToAppFlow,
  });
}
