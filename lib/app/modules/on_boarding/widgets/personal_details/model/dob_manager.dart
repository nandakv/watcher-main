import 'package:flutter/services.dart';

import 'dob_events.dart';
import 'dob_input_manager.dart';

class DobManager implements DOBEvents {
  late DOBInputManager dayManager;
  late DOBInputManager monthManager;
  late DOBInputManager yearManager;

  DobManager() {
    _initDayManager();
    _initMonthManager();
    _initYearManager();
  }

  void _initYearManager() {
    yearManager = DOBInputManager(
      type: DOBInputType.year,
      isEnabled: false,
      onChange: onYearChange,
      onRawKey: onYearRawKey,
    );
  }

  void _initMonthManager() {
    monthManager = DOBInputManager(
      type: DOBInputType.month,
      isEnabled: false,
      onRawKey: onMonthRawKey,
      onChange: onMonthChange,
    );
  }

  _initDayManager() {
    dayManager = DOBInputManager(
      type: DOBInputType.day,
      onChange: onDayChange,
      onRawKey: onDayRawKey,
    );
  }

  startListener() {
    dayManager.listenToFocus();
    monthManager.listenToFocus();
  }

  stopListener() {
    dayManager.removeFocusListener();
    monthManager.removeFocusListener();
  }

  String get dobString =>
      "${dayManager.textController.text}/${monthManager.textController.text}/${yearManager.textController.text}";

  bool get isEmpty =>
      dayManager.isEmpty && monthManager.isEmpty && yearManager.isEmpty;

  void requestFocus() {
    if (dayManager.isEmpty) {
      dayManager.requestFocus();
    } else if (monthManager.isEmpty) {
      monthManager.requestFocus();
    } else {
      yearManager.requestFocus();
    }
  }

  void clearFields() {
    dayManager.clear();
    monthManager.clear();
    yearManager.clear();
    monthManager.isEnabled = false;
    yearManager.isEnabled = false;
  }

  bool _checkIsNum(String val) {
    return val.compareTo("0") >= 0 && val.compareTo("9") <= 0;
  }

  @override
  onMonthChange() {
    if (monthManager.textLength == 2) {
      yearManager.requestFocus();
    }
    if (monthManager.isEmpty && yearManager.isEmpty) {
      dayManager.requestFocus();
      yearManager.isEnabled = false;
    } else {
      yearManager.isEnabled = true;
    }
  }

  @override
  onMonthRawKey(LogicalKeyboardKey rawKey) {
    if (rawKey == LogicalKeyboardKey.backspace && monthManager.isEmpty) {
      //onEmptyBackspace
      dayManager.setText(dayManager.textController.text.substring(0, 1));
      dayManager.requestFocus();
    }
    if (monthManager.textLength == 2) {
      // onFilledRawKey
      if (_checkIsNum(rawKey.keyLabel) && yearManager.textLength < 4) {
        yearManager.prefixText(rawKey.keyLabel);
        yearManager.requestFocus();
      }
    }
  }

  @override
  onDayChange() {
    if (dayManager.isEmpty && monthManager.isEmpty) {
      // onDayEmpty
      monthManager.isEnabled = false;
    } else {
      monthManager.isEnabled = true; // onDayNotEmpty
    }

    if (dayManager.textLength == 2) {
      //  onDayFilled
      monthManager.requestFocus();
    }
  }

  @override
  onDayRawKey(LogicalKeyboardKey rawKey) {
    if (dayManager.textLength == 2) {
      if (_checkIsNum(rawKey.keyLabel) && monthManager.textLength < 2) {
        monthManager.prefixText(rawKey.keyLabel);
        monthManager.requestFocus();
        if (yearManager.isEmpty && !yearManager.isEnabled) {
          yearManager.isEnabled = true;
        }
      }
    }
  }

  @override
  onYearChange() {
    if (yearManager.isEmpty) {
      monthManager.requestFocus();
    }
  }

  @override
  onYearRawKey(LogicalKeyboardKey rawKey) {
    if (rawKey == LogicalKeyboardKey.backspace && yearManager.isEmpty) {
      monthManager.requestFocus();
      monthManager.setText(monthManager.textController.text.substring(0, 1));
    }
  }
}
