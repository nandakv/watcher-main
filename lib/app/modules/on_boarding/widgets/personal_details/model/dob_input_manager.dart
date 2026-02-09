import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

enum DOBInputType { day, month, year }

class DOBInputManager {
  final TextEditingController _textController = TextEditingController();
  final DOBInputType type;

  bool isEnabled;
  DOBInputManager({
    required this.type,
    required this.onChange,
    required this.onRawKey,
    this.isEnabled = true,
  });

  listenToFocus() {
    _focusNode.addListener(_focusListener);
  }

  _focusListener() {
    if (!_focusNode.hasFocus) {
      if (textLength == 1) {
        prefixText("0");
      }
    }
  }

  removeFocusListener() {
    _focusNode.removeListener(_focusListener);
  }

  final FocusNode _focusNode = FocusNode();

  FocusNode get focusNode => _focusNode;

  TextEditingController get textController => _textController;

  int get textLength => _textController.text.length;

  bool get isEmpty {
    return textController.text.isEmpty;
  }

  bool get isNotEmpty {
    return textController.text.isNotEmpty;
  }

  void setText(String text) {
    _textController.text = text;
  }

  void requestFocus() {
    Get.log("requestFocus: ${_focusNode.hasFocus} $type");
    _focusNode.requestFocus();
  }

  void prefixText(String text) {
    _textController.text = text + _textController.text;
  }

  void clear() {
    _textController.clear();
  }

  final Function(LogicalKeyboardKey rawKey) onRawKey;

  final Function() onChange;

  String get hintText {
    switch (type) {
      case DOBInputType.day:
        return "DD";
      case DOBInputType.month:
        return "MM";
      default:
        return "YYYY";
    }
  }

  int get maxLength {
    switch (type) {
      case DOBInputType.day:
      case DOBInputType.month:
        return 2;
      default:
        return 4;
    }
  }
}
