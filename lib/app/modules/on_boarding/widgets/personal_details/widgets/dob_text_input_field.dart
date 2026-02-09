import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:privo/app/common_widgets/privo_text_form_field/privo_text_form_field.dart';
import 'package:privo/app/theme/app_colors.dart';

import '../../../../../utils/no_leading_space_formatter.dart';
import '../model/dob_input_manager.dart';

class DOBTextInputField extends StatelessWidget {
  final DOBInputManager dobInputManager;
  final void Function(String)? onTextChange;
  final void Function(LogicalKeyboardKey)? onKey;

  const DOBTextInputField({
    Key? key,
    required this.dobInputManager,
    required this.onTextChange,
    required this.onKey,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RawKeyboardListener(
      focusNode: FocusNode(),
      onKey: (RawKeyEvent rawKey) {
        if (rawKey.runtimeType == RawKeyDownEvent) {
          onKey?.call(rawKey.data.logicalKey);
        }
      },
      child: TextFormField(
        // id: 'DOB_TEXT_FIELD',
        maxLength: dobInputManager.maxLength,
        enabled: dobInputManager.isEnabled,
        textAlign: TextAlign.center,
        controller: dobInputManager.textController,
        maxLines: 1,
        decoration: _textInputDecoration,
        style: _textStyle,
        inputFormatters: [
          NoLeadingSpaceFormatter(),
          FilteringTextInputFormatter.allow(RegExp("[0-9]"))
        ],
        focusNode: dobInputManager.focusNode,
        keyboardType: TextInputType.number,
        onChanged: onTextChange,
      ),
    );
  }

  InputDecoration get _textInputDecoration {
    return InputDecoration(
      hintText: dobInputManager.hintText,
      isDense: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 0, vertical: 8),
      hintStyle: _hintTextStyle,
      counterText: "",
      border: InputBorder.none,
    );
  }

  TextStyle get _hintTextStyle {
    return const TextStyle(
        fontSize: 14,
        letterSpacing: 0.18,
        fontFamily: 'Figtree',
        color: secondaryDarkColor);
  }

  TextStyle get _textStyle {
    return const TextStyle(
      fontSize: 14,
      letterSpacing: 0.18,
      fontFamily: 'Figtree',
      color: primaryDarkColor,
    );
  }
}
