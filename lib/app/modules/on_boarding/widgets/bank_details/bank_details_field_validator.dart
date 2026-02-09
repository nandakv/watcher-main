import 'package:flutter/cupertino.dart';

import '../../../../common_widgets/forms/base_field_validator.dart';
import '../../../../models/supported_banks_model.dart';
import 'bank_details_logic.dart';

mixin BankDetailsFieldValidator {
  String? accountNumberValidator(String? value) {
    if (value!.trim().isEmpty) {
      return "Account number required";
    } else if (checkAccountNumberLength(value)) {
      return "Complete your account number";
    }
    return null;
  }

  ///To verify the last digits of the bank account or IFSC CODE
  bool checkAccountNumberLength(String num) {
    return num.length < 8 || num.length > 18;
  }

  String? confirmAccountNumberValidator(
      String? value,
      BankDetailsState bankDetailsState,
      TextEditingController accountNumberController) {
    if (bankDetailsState == BankDetailsState.form) {
      return aaAccountNumberValidation(value, accountNumberController);
    }
    if (value!.trim().isEmpty) {
      return "Confirm your account";
    } else if (accountNumberController.text != value) {
      return "Account no. does not match";
    } else {
      return null;
    }
  }

  String? aaAccountNumberValidation(
      String? value, TextEditingController accountNumberController) {
    if (value!.trim().isEmpty) {
      return "Confirm your account";
    }
    if (accountNumberController.text.toLowerCase().contains("x")) {
      if (value.length < 8 || value.length > 18) {
        return "Complete your confirm account number";
      } else if ((accountNumberController.text.characters.takeLast(4)) !=
          value.characters.takeLast(4)) {
        return "Account no. does not match";
      }
      return null;
    }
    if (accountNumberController.text != value) {
      return "Account no. does not match";
    }
    return null;
  }

  String? validateIfscCode(String? value,
      {BanksModel? userSelectedBank, bool isIFSCMatching = false}) {
    if (value!.trim().isEmpty) return "IFSC code is required";
    if (userSelectedBank != null &&
        userSelectedBank.ifscCode.isNotEmpty &&
        !isIFSCMatching) {
      return "IFSC incorrect. Retry";
    }
    if (value.length < 11) return null;
    if (!RegExp(r'^[a-zA-Z0-9]{11}$').hasMatch(value.trim())) {
      return "Check the IFSC";
    }
    return null;
  }

  ///validates masked account number to confirm account number
  ///by matching only the digits..
  bool _validateMaskedString({
    required String maskedString,
    required String givenString,
  }) {
    // Replace all 'x' in maskedString with '.' to create a regex pattern
    String pattern = maskedString.replaceAll('x', '.');

    // Create a RegExp from the pattern and match it against the givenString
    RegExp regExp = RegExp('^$pattern\$');

    // Return whether the givenString matches the pattern
    return regExp.hasMatch(givenString);
  }
}
