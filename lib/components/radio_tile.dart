import 'package:flutter/material.dart';
import 'package:privo/app/common_widgets/spacer_widgets.dart';
import 'package:privo/app/theme/app_colors.dart';

enum RadioTileState {
  enabled(textColor: primaryDarkColor, radioButtonColor: darkBlueColor),
  disabled(textColor: grey500, radioButtonColor: grey500);

  const RadioTileState(
      {required this.textColor, required this.radioButtonColor});

  final Color textColor;
  final Color radioButtonColor;
}

class RadioTile<T> extends StatelessWidget {
  final String label;
  final T groupValue;
  final T value;
  final Function(T?) onChange;
  final RadioTileState radioTileState;

  const RadioTile({
    super.key,
    required this.label,
    required this.groupValue,
    required this.value,
    this.radioTileState = RadioTileState.enabled,
    required this.onChange,
  });

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
        ignoring: radioTileState == RadioTileState.disabled,
        child: InkWell(
          // trigger on change when the radio button is selected. Basically it should not unselect on second tap
          onTap: () {
            if (groupValue != value) {
              onChange(value);
            }
          },
          child: Row(
            children: [
              _radioButton(),
              const HorizontalSpacer(8),
              _labelWidget(),
            ],
          ),
        ));
  }

  Widget _radioButton() {
    return Padding(
      padding: const EdgeInsets.all(3.0),
      child: SizedBox(
        width: 18,
        height: 18,
        child: IgnorePointer(
          ignoring: true,
          child: Radio<T>(
            value: value,
            groupValue: groupValue,
            onChanged: onChange,
            activeColor: radioTileState.radioButtonColor,
            fillColor: MaterialStateProperty.all(
              radioTileState.radioButtonColor,
            ),
          ),
        ),
      ),
    );
  }

  Widget _labelWidget() {
    return Text(
      label,
      style: TextStyle(
        color: radioTileState.textColor,
        fontWeight: FontWeight.w500,
        fontSize: 14,
        height: 20 / 14,
      ),
    );
  }
}
