import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../../../../utils/app_functions.dart';
import '../../model/dob_manager.dart';

class PersonalDetailsDOBFieldLogic extends GetxController {
  final DobManager dobManager = DobManager();

  final String DOB_INPUT_FIELD = 'dob_input_field';
  final String DOB_INFO_ERROR_TEXT = 'dob_info_error_text';

  /// whenever the user is interacting with dob, we need to highlight the divider, This is the parent focus node for dob
  FocusNode dobFieldFocusNode = FocusNode();

  bool _dobFocused = false;

  bool get dobFocused => _dobFocused;

  set dobFocused(bool val) {
    _dobFocused = val;
    update([DOB_INPUT_FIELD]);
  }

  void onDOBTextClick() {
    dobFocused = true;
    dobManager.requestFocus();
  }

  void clearFields() {
    dobManager.clearFields();
    _dobError = "";
    _dobFocused = false;
    _dobBorderFocused = false;
  }

  ///Initialized date picker for user to select only years above 18
  DateTime get initialDateForPicker {
    DateTime now = DateTime.now();
    DateTime adultYear = DateTime(now.year - 18, now.month, now.day);
    return adultYear;
  }

  bool _dobBorderFocused = false;

  bool get dobBorderFocused => _dobBorderFocused;

  set dobBorderFocused(bool val) {
    _dobBorderFocused = val;
    update();
  }

  String _dobError = "";

  String get dobError => _dobError;

  set dobError(String val) {
    _dobError = val;
    update([DOB_INFO_ERROR_TEXT]);
  }

  bool get isDobError => _dobError.isNotEmpty;

  Color computeDOBBorderColor() {
    if (isDobError) {
      return Colors.red;
    } else if (_dobBorderFocused) {
      return const Color(0xFF1C478D);
    }
    return Colors.grey;
  }

  _checkSingleDigitAndPrefillZero(String text) {
    if (text.length == 1) {
      return "0$text";
    }
    return text;
  }

  updateDateFromCalenderPicker(DateTime datetime) {
    dobManager.dayManager
        .setText(_checkSingleDigitAndPrefillZero(datetime.day.toString()));
    dobManager.monthManager
        .setText(_checkSingleDigitAndPrefillZero(datetime.month.toString()));
    dobManager.yearManager.setText(datetime.year.toString());
    dobManager.monthManager.isEnabled = true;
    dobManager.yearManager.isEnabled = true;
  }

  _dobFieldFocusNodeListener() {
    dobBorderFocused = dobFieldFocusNode.hasFocus;
  }

  void onAfterFirstLayout() {
    dobFieldFocusNode.addListener(_dobFieldFocusNodeListener);

    dobManager.startListener();

    /// If partnerapi, then date will be prefilled. Enable the dob if prefilled
    if (!dobManager.isEmpty) {
      dobManager.monthManager.isEnabled = true;
      dobManager.yearManager.isEnabled = true;
      dobFocused = true;
    }
  }

  @override
  void onClose() {
    dobManager.stopListener();
    dobFieldFocusNode.removeListener(_dobFieldFocusNodeListener);
    super.onClose();
  }

  void dobValidator() {
    Get.log("Dob string ${dobManager.dobString}");
    if (dobManager.dobString == "//" || dobManager.dobString.isEmpty) {
      dobError = "Date of Birth is required";
    } else {
      String value = dobManager.dobString;
      DateFormat format = DateFormat("dd/MM/yyyy");
      try {
        DateTime dayOfBirthDate = format.parseStrict(value);
        if (isFutureDate(dayOfBirthDate.toIso8601String())) {
          dobError = "Enter a valid date";
        } else if (dayOfBirthDate.year < 1924) {
          dobError = "Enter a valid date";
        } else {
          dobError = "";
        }
      } catch (e) {
        dobError = "Enter a valid date";
      }
    }
    update();
  }

  ///Checks if the user is adult else returns false for validation
  bool isAdult(String birthDateString) {
    // String datePattern = "yMd";
    String datePattern = "yyyy-MM-dd";
    //String datePattern = "dd-MM-yyyy";

    DateTime birthDate = DateFormat(datePattern).parse(birthDateString);
    DateTime today = DateTime.now();

    int yearDiff = today.year - birthDate.year;
    int monthDiff = today.month - birthDate.month;
    int dayDiff = today.day - birthDate.day;

    return yearDiff > 18 || yearDiff == 18 && monthDiff >= 0 && dayDiff >= 0;
  }

  ///check if user is not entering date greater than current date
  bool isFutureDate(String birthDateString) {
    String datePattern = "yyyy-MM-dd";
    DateTime birthDate = DateFormat(datePattern).parse(birthDateString);
    DateTime today = DateTime.now();
    return birthDate.isAfter(today);
  }

  String dobDateValidator() {
    if (dobManager.dobString == "///") {
      return "";
    } else {
      String value = dobManager.dobString;
      DateFormat format = DateFormat("dd/MM/yyyy");
      try {
        DateTime dayOfBirthDate = format.parseStrict(value);
        if (isFutureDate(dayOfBirthDate.toIso8601String())) {
          return " ";
        } else {
          return AppFunctions()
              .getDobFormat(dayOfBirthDate)
              .replaceAll("-", " ");
        }
      } catch (e) {
        return "";
      }
    }
  }
}
