import 'package:flutter/material.dart';

import '../model/dob_manager.dart';
import 'dob_text_input_field.dart';

class DobWidget extends StatefulWidget {
  final DobManager dobFocusManager;
  final Function() onChange;
  const DobWidget(
      {Key? key, required this.onChange, required this.dobFocusManager})
      : super(key: key);

  @override
  State<DobWidget> createState() => _DobWidgetState();
}

class _DobWidgetState extends State<DobWidget> {
  Widget _dobDayInputWidget() {
    return DOBTextInputField(
      dobInputManager: widget.dobFocusManager.dayManager,
      onTextChange: _onDayTextChange,
      onKey: (rawKey) => widget.dobFocusManager.dayManager.onRawKey(rawKey),
    );
  }

  _onDayTextChange(v) {
    widget.onChange();
    widget.dobFocusManager.dayManager.onChange();
  }

  Widget _dobMonthInputWidget() {
    return DOBTextInputField(
      dobInputManager: widget.dobFocusManager.monthManager,
      onTextChange: _onMonthTextChange,
      onKey: (rawKey) => widget.dobFocusManager.monthManager.onRawKey(rawKey),
    );
  }

  _onMonthTextChange(v) {
    widget.onChange();
    widget.dobFocusManager.monthManager.onChange();
  }

  Widget _dobYearInputWidget() {
    return DOBTextInputField(
      dobInputManager: widget.dobFocusManager.yearManager,
      onTextChange: _onYearTextChange,
      onKey: (rawKey) => widget.dobFocusManager.yearManager.onRawKey(rawKey),
    );
  }

  _onYearTextChange(v) {
    widget.onChange();
    widget.dobFocusManager.yearManager.onChange();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 11,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                flex: 19,
                child: _dobDayInputWidget(),
              ),
              _forwardSlashWidget(),
              Expanded(
                flex: 23,
                child: _dobMonthInputWidget(),
              ),
              _forwardSlashWidget(),
              Expanded(
                flex: 32,
                child: _dobYearInputWidget(),
              ),
            ],
          ),
        ),
        const Spacer(
          flex: 7,
        )
      ],
    );
  }

  Widget _forwardSlashWidget() {
    return const Text(
      "/",
      style: TextStyle(
        fontSize: 14,
      ),
    );
  }
}
