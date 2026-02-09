import 'package:flutter/widgets.dart';

class PrivoTextEditingController extends TextEditingController {

  String _prefilledValue = "";

  String get prefilledValue => _prefilledValue;

  set prefilledValue(String prefilledText) {
    _prefilledValue = prefilledText;
    text = prefilledText;
  }

  /// isUpdated is to check if he user had edited the prefilled value or not
  /// ignoreCase field ignores the case while checking,
  /// Eg. "User" & "user" will give isUpdated as false if ignoreCase is true
  bool isUpdated({bool ignoreCase = false}) {
    if (ignoreCase) {
      return _prefilledValue.toLowerCase() != text.toLowerCase();
    }
    return _prefilledValue != text;
  }
}
