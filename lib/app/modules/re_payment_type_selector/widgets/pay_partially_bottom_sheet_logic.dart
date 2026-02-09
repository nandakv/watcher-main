import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:meta/meta.dart';
import 'package:privo/app/utils/app_functions.dart';

class PayPartiallyBottomSheetLogic extends GetxController {
  TextEditingController amountTextController = TextEditingController();

  final String PARTIAL_TEXTFIELD = "partial-textfield";

  String totalPendingAmount = "";

  String _errorText = "";

  String get errorText => _errorText;

  set errorText(String value) {
    _errorText = value;
    update([PARTIAL_TEXTFIELD]);
  }

  onPartialAmountChanged(String value) {
    if (value.isNotEmpty) {
      String result =
      AppFunctions().parseIntoCommaFormat(value.replaceAll(',', ''));

      ///to place the cursor in correct position after deleting text
      int cursorPosition = amountTextController.selection.base.offset;
      int addedCommas = result.length - value.length;

      amountTextController.value = TextEditingValue(
        text: result,
        selection: TextSelection.fromPosition(
          TextPosition(offset: cursorPosition + addedCommas),
        ),
      );
      // amountPayable = amountTextController.text;
      update();
    } else {
      update();
    }
  }

  bool comparePartialAmount() {
    if (amountTextController.text.isNotEmpty) {
      Get.log("AMount ${amountTextController.text}");
      return double.parse(amountTextController.text.replaceAll(',', '')) >
          double.parse(totalPendingAmount);
    }
    return true;
  }

  bool _onPartialPayment() {
    return validatePartialAmountForButton() &&
        double.parse(amountTextController.text.replaceAll(',', '')) >= 1.0 &&
        !amountTextController.text.contains('-');
  }

  bool validatePartialAmountForButton() {
    return amountTextController.text.isNotEmpty && !comparePartialAmount();
  }

  validatePartialAmount() {
    if (amountTextController.text.isEmpty) {
      return "Please enter amount";
    }
    if (comparePartialAmount()) {
      return "Amount cannot be more than total amount";
    }
    if (double.parse(amountTextController.text.replaceAll(',', '')) < 1.0) {
      return "Please enter a valid amount";
    }
  }

  onPayNowPressed() {
    Get.back(result: amountTextController.text);
  }
}