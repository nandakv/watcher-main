import 'dart:io';

import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:privo/app/services/platform_services/platform_services.dart';

import 'app_functions.dart';

class NoLeadingSpaceFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.text.startsWith(' ')) {
      final String trimedText = newValue.text.trimLeft();

      return TextEditingValue(
        text: trimedText,
        selection: oldValue.selection,
      );
    }

    return newValue;
  }
}

class NoLeadingDotFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.text.startsWith('.')) {
      final String removedValue = newValue.text.replaceAll('.', '');

      return TextEditingValue(
        text: removedValue,
        selection: TextSelection(
          baseOffset: removedValue.length,
          extentOffset: removedValue.length,
        ),
      );
    }

    return newValue;
  }
}

class PhoneNumberInputFormatter extends TextInputFormatter {
  // Updated regex to allow partially complete phone numbers.
  final RegExp _regex = RegExp(r'^[6-9][0-9]{0,9}$');

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    // If the new value matches the regex, we allow the update.
    if (newValue.text.isEmpty || _regex.hasMatch(newValue.text)) {
      return newValue;
    }
    // Otherwise, we keep the old value.
    return oldValue;
  }
}

class DecimalInputFormatter extends TextInputFormatter {
  // This regex allows any number of digits before the decimal point,
  // and up to two digits after the decimal point.
  final RegExp _regex = RegExp(r'^\d*\.?\d{0,2}$');

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    // If the new value matches the regex, we allow the update.
    if (_regex.hasMatch(newValue.text)) {
      return newValue;
    }
    // Otherwise, we keep the old value.
    return oldValue;
  }
}

class DoubleDotFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final List<String> splitValue = newValue.text.split('.');
    if (splitValue.length > 2) {
      String joinedString = splitValue[0] + "." + splitValue[1];
      Get.log("Has double dots ${joinedString}");
      return TextEditingValue(
        text: joinedString,
        selection: TextSelection(
          baseOffset: joinedString.length,
          extentOffset: joinedString.length,
        ),
      );
    }
    return newValue;
  }
}

class NoSpecialCharacterFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    String enteredValue = "";
    if (newValue.selection.base.offset > 0) {
      Get.log(
          "Entered Value - ${newValue.text[newValue.selection.base.offset - 1]}");
      enteredValue = newValue.text[newValue.selection.base.offset - 1];
    }

    final validCharacters = RegExp(r'^[a-zA-Z0-9 ]*$');
    if (!validCharacters.hasMatch(newValue.text)) {
      final String trimedText = newValue.text.replaceAll(enteredValue, '');

      return TextEditingValue(
        text: trimedText,
        selection: oldValue.selection,
      );
    }

    return newValue;
  }
}

class NumberToRupeesFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    ///1st check
    ///Check for leading space and block typing
    if (newValue.text.startsWith(' ')) {
      return _checkForLeadingSpace(newValue);
    }
    if (newValue.text.startsWith("0")) {
      return oldValue;
    }

    ///2nd check
    ///check for symbols and special characters and block
    ///get the enteredCharacter
    String enteredChar = _computeEnteredChar(oldValue, newValue);

    ///3rd check
    ///if entered char is "," do nothing
    if (enteredChar == ",") {
      if (oldValue.text.length > newValue.text.length) {
        return TextEditingValue(
          text: AppFunctions().parseIntoCommaFormat(
            newValue.text
                .replaceRange(
                  newValue.selection.baseOffset - 1,
                  newValue.selection.baseOffset,
                  "",
                )
                .replaceAll(",", ""),
          ),
          selection: TextSelection.fromPosition(
            TextPosition(
              offset: newValue.selection.baseOffset - 1,
            ),
          ),
        );
      }
      return oldValue;
    }

    ///4th check
    ///if entered symbols or characters replace the character with empty
    final validCharacters = RegExp(r'^[0-9]*$');
    if (!validCharacters.hasMatch(newValue.text.replaceAll(",", ''))) {
      Get.log("its symbol");
      final String trimedText = newValue.text.replaceAll(enteredChar, '');
      return TextEditingValue(
        text: trimedText,
        selection: oldValue.selection,
      );
    }

    ///5th check
    ///compute and add commas to the numbers
    return _addCommasToTheNumbers(oldValue, newValue);
  }

  String _computeEnteredChar(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (oldValue.text.length > newValue.text.length) {
      return oldValue.text[oldValue.selection.baseOffset -
          PrivoPlatform.platformService
              .getCursorPositionForCommaFormattedTextField(1)];
    }
    return newValue.text[newValue.selection.baseOffset - 1];
  }

  TextEditingValue _addCommasToTheNumbers(
      TextEditingValue oldValue, TextEditingValue newValue) {
    Get.log("og old value - ${oldValue.text}");
    Get.log("og new value - ${newValue.text}");

    Get.log(
        "oldValue.selection.base.offset - ${oldValue.selection.base.offset}");
    Get.log(
        "newValue.selection.base.offset - ${newValue.selection.base.offset}");

    String newValueWithCommas =
        AppFunctions().parseIntoCommaFormat(newValue.text.replaceAll(',', ''));

    if (newValueWithCommas == "0") {
      return TextEditingValue(
          text: newValue.text, selection: newValue.selection);
    }

    String oldValueWithoutCommas = oldValue.text.replaceAll(",", "");

    Get.log("oldValue - ${oldValue.text}");
    Get.log("newValue - $newValueWithCommas");

    ///if deletes a char
    if (oldValue.text.length > newValueWithCommas.length) {
      return _computeAndAddCommasOnDeleteChar(
        newValue,
        oldValue,
        oldValueWithoutCommas,
        newValueWithCommas,
      );
    }

    ///if adds a char
    return _computeAndAddCommasOnAddChar(
        oldValue, oldValueWithoutCommas, newValueWithCommas, newValue);
  }

  TextEditingValue _computeAndAddCommasOnAddChar(
      TextEditingValue oldValue,
      String oldValueWithoutCommas,
      String newValueWithCommas,
      TextEditingValue newValue) {
    int cursorPosition = oldValue.selection.base.offset;

    int oldValueCommas = oldValue.text.length - oldValueWithoutCommas.length;
    int newValueCommas = newValueWithCommas.length -
        newValueWithCommas.replaceAll(',', '').length;

    return TextEditingValue(
      text: AppFunctions()
          .parseIntoCommaFormat(newValue.text.replaceAll(",", "")),
      selection: TextSelection.fromPosition(
        TextPosition(
            offset: oldValueCommas == newValueCommas
                ? cursorPosition + 1
                : cursorPosition + 2),
      ),
    );
  }

  TextEditingValue _computeAndAddCommasOnDeleteChar(
      TextEditingValue newValue,
      TextEditingValue oldValue,
      String oldValueWithoutCommas,
      String newValueWithCommas) {
    if (newValue.selection.base.offset == 0 && Get.focusScope != null) {
      Get.focusScope!.unfocus();
    }

    int oldValueCommas = oldValue.text.length - oldValueWithoutCommas.length;

    int cursorPosition = oldValue.selection.base.offset;
    int newValueCommas = newValueWithCommas.length -
        newValueWithCommas.replaceAll(",", '').length;

    Get.log("result.length - ${newValueWithCommas.length}");
    Get.log("newValue.text.length - ${newValue.text.length}");

    return TextEditingValue(
      text: AppFunctions()
          .parseIntoCommaFormat(newValue.text.replaceAll(",", "")),
      selection: TextSelection.fromPosition(
        TextPosition(
          offset: oldValueCommas == newValueCommas
              ? cursorPosition -
                  PrivoPlatform.platformService
                      .getCursorPositionForCommaFormattedTextField(1)
              : cursorPosition -
                  PrivoPlatform.platformService
                      .getCursorPositionForCommaFormattedTextField(2),
        ),
      ),
    );
  }

  bool _isCharDeleted(TextEditingValue oldValue, TextEditingValue newValue) =>
      oldValue.text.length > newValue.text.length;

  TextEditingValue _checkForLeadingSpace(TextEditingValue newValue) {
    final String trimedText = newValue.text.trimLeft();

    return TextEditingValue(
      text: trimedText,
      selection: TextSelection(
        baseOffset: trimedText.length,
        extentOffset: trimedText.length,
      ),
    );
  }
}

class UdyamHyphenFormatter extends TextInputFormatter {
  // This pattern ensures only valid input format is accepted (with hyphens)
  static final RegExp _validFormat = RegExp(r'^[A-Za-z]{2}-\d{2}-\d{7}$');

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    String text = newValue.text.toUpperCase();

    int newCursorPosition = newValue.selection.baseOffset;

    if (oldValue.text.length > newValue.text.length) {
      return newValue;
    }

    text = text.replaceAll('-', '');

    // text = text.replaceAll(RegExp(r'[^A-Z0-9]'), '');

    // Build the formatted string with hyphens in the correct positions
    StringBuffer buffer = StringBuffer();

    // Add characters with hyphenation at the correct places
    for (int i = 0; i < text.length && i < 11; i++) {
      if (i == 2 || i == 4) {
        buffer.write('-');
      }
      buffer.write(text[i]);
    }

    String finalText = buffer.toString();

    if (finalText.length == 13 && !_validFormat.hasMatch(finalText)) {
      return oldValue;
    }

    if (finalText.length < newCursorPosition) {
      newCursorPosition = finalText.length;
    }

    // Handle the case where hyphens are added or removed
    int hyphenCountBefore = _countHyphens(oldValue.text);
    int hyphenCountAfter = _countHyphens(finalText);
    int diff = hyphenCountAfter - hyphenCountBefore;

    // Adjust the cursor position based on the difference in hyphen counts
    newCursorPosition += diff;

    // Ensure the cursor doesn't go out of bounds
    newCursorPosition = newCursorPosition.clamp(0, finalText.length);

    return TextEditingValue(
      text: finalText,
      selection: TextSelection.collapsed(offset: newCursorPosition),
    );
  }

  // Helper function to count the number of hyphens in the text
  int _countHyphens(String text) {
    return text.split('-').length - 1;
  }
}

class AadhaarSpaceFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    var text = newValue.text;
    text = text.replaceAll(RegExp(r'(\s)|(\D)'), '');

    int offset = newValue.selection.start;
    var subText =
        newValue.text.substring(0, offset).replaceAll(RegExp(r'(\s)|(\D)'), '');
    int realTrimOffset = subText.length;

    // if (newValue.selection.baseOffset == 0) {
    //   return newValue;
    // }

    var buffer = new StringBuffer();
    for (int i = 0; i < text.length; i++) {
      buffer.write(text[i]);
      var nonZeroIndex = i + 1;
      if (nonZeroIndex % 4 == 0 && nonZeroIndex != text.length) {
        buffer.write(
            ' '); // Replace this with anything you want to put after each 4 numbers
      }

      // This block is only executed once
      if (nonZeroIndex % 4 == 0 &&
          subText.length == nonZeroIndex &&
          nonZeroIndex > 4) {
        int moveCursorToRigth = nonZeroIndex ~/ 4 - 1;
        realTrimOffset += moveCursorToRigth;
      }

      // This block is only executed once
      if (nonZeroIndex % 4 != 0 && subText.length == nonZeroIndex) {
        int moveCursorToRigth = nonZeroIndex ~/ 4;
        realTrimOffset += moveCursorToRigth;
      }
    }

    var string = buffer.toString();
    return newValue.copyWith(
        text: string,
        selection: new TextSelection.collapsed(offset: realTrimOffset));
  }
}
