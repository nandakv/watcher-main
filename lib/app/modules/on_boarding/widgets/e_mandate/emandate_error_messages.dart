import 'package:privo/app/modules/on_boarding/widgets/e_mandate/e_mandate_failure_model.dart';

late Map<String, EmandateFailureModel> emandateErrorMessages = {
  "already_declined": EmandateFailureModel(
      title: "Yikes!",
      subTitle:
          "Your bank server seems to be busy right now. This usually resolves within 4 hours. Thank you for your patience."),
  "payment_failed": EmandateFailureModel(
      title: "Yikes!",
      subTitle:
          "Your bank server seems to be busy right now. This usually resolves within 4 hours. Thank you for your patience."),
  "duplicate_request": EmandateFailureModel(
      title: "Yikes!",
      subTitle:
          "Your bank server seems to be busy right now. This usually resolves within 4 hours. Thank you for your patience."),
  "insufficient_funds": EmandateFailureModel(
      title: "Heads up!",
      subTitle:
          "Make sure you maintain an adequate balance of Rs 200. Please retry the auto-pay setup."),
  "user_not_registered_for_netbanking": EmandateFailureModel(
      title: "Ouch!",
      subTitle:
          "We're sorry your payment wasn't successful. Double-check that your bank's netbanking is activated."),
  "debit_instrument_blocked": EmandateFailureModel(
      title: "Oops!",
      subTitle:
          "It seems like your debit card has been blocked or bank is inactive. Unblock your card to continue or contact your bank."),
  "card_expired": EmandateFailureModel(
      title: "Oops!",
      subTitle:
          "It seems like your debit card is inactive. Please activate it now to continue with your autopay setup."),
  "debit_instrument_inactive": EmandateFailureModel(
      title: "Oops!",
      subTitle:
          "Looks like your current card is disabled to make online payments. Please enable online payments on your debit card. Contact your bank for more info."),
  "payment_pending_approval": EmandateFailureModel(
      title: "Yikes",
      subTitle:
          "Your bank server seems to be busy right now. This usually resolves within 4 hours. Thank you for your patience"),
  "gateway_technical_error": EmandateFailureModel(
      title: "Yikes",
      subTitle:
          "Your bank server seems to be down. Please come back and try again. Thank you for your patience"),
  "": EmandateFailureModel(
      title: "Yikes",
      subTitle:
          "Your bank server seems to be down. Please come back and try again. Thank you for your patience"),
  "bank_technical_error": EmandateFailureModel(
      title: "Yikes",
      subTitle:
          "Your bank server seems to be down. Please come back and try again. Thank you for your patience"),
  "card_number_invalid": EmandateFailureModel(
      title: "Uh-oh!",
      subTitle:
          "The card number you have entered is invalid. Please try again with another card. Thank you!"),
  "incorrect_cvv": EmandateFailureModel(
      title: "Uh-oh!",
      subTitle:
          "The CVV you have entered for your card is incorrect. Please try again with correct CVV. Thank you!"),
  "incorrect_otp": EmandateFailureModel(
      title: "Uh-oh!",
      subTitle:
          "The OTP you have entered is incorrect. Please try again with correct OTP. Thank you!"),
  "incorrect_card_expiry_date": EmandateFailureModel(
      title: "Uh-oh!",
      subTitle:
          "The EXPIRY DATE you have entered for your card is incorrect. Please try again with correct details. Thank you!"),
};
