class PaymentSuccessModel {
  final String refIdValue;
  final String amount;
  final String subtitleText;
  final String bottomInfoText;
  final Function onCloseClicked;
  final Function onGoToHomeClicked;
  final String refIdKey;
  final String appRatingPromptEvent;
  final bool isWithdrawalBlocked;
  final String infoMessage;

  PaymentSuccessModel({
    required this.refIdValue,
    required this.amount,
    required this.onCloseClicked,
    required this.onGoToHomeClicked,
    required this.subtitleText,
    required this.appRatingPromptEvent,
    required this.isWithdrawalBlocked,
    this.infoMessage = "",
    this.bottomInfoText = "",
    this.refIdKey = "Reference ID (withdrawal)",
  });
}
