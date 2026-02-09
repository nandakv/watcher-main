import 'package:flutter/material.dart';
import 'package:privo/app/common_widgets/spacer_widgets.dart';
import 'package:privo/app/theme/app_colors.dart';

enum CheckBoxState {
  enabled(textColor: primaryDarkColor, checkBoxColor: darkBlueColor),
  disabled(textColor: grey500, checkBoxColor: grey500);

  const CheckBoxState({required this.textColor, required this.checkBoxColor});

  final Color textColor;
  final Color checkBoxColor;
}

class CheckBoxTile extends StatelessWidget {
  final CheckBoxState checkBoxState;
  final bool checkBoxValue;
  final VoidCallback? onChecked;
  final VoidCallback? onUnChecked;
  final String label;
  const CheckBoxTile({
    super.key,
    this.checkBoxState = CheckBoxState.enabled,
    required this.checkBoxValue,
    this.onChecked,
    this.onUnChecked,
    required this.label,
  }) : super();

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      ignoring: checkBoxState == CheckBoxState.disabled,
      child: InkWell(
        onTap: checkBoxValue ? onUnChecked : onChecked,
        child: Row(
          children: [
            _checkboxWidget(),
            const HorizontalSpacer(8),
            Flexible(child: _labelWidget())
          ],
        ),
      ),
    );
  }

  Widget _labelWidget() {
    return Text(
      label,
      style: TextStyle(
        color: checkBoxState.textColor,
        fontWeight: FontWeight.w500,
        fontSize: 14,
        height: 20 / 14,
      ),
    );
  }

  Widget _checkboxWidget() {
    return Padding(
      padding: const EdgeInsets.all(4),
      child: SizedBox(
        width: 16,
        height: 16,
        child: Checkbox(
          activeColor: checkBoxState.checkBoxColor,
          value: checkBoxValue,
          onChanged: (bool? value) {
            if (value != null) {
              (value ? onChecked : onUnChecked)?.call();
            }
          },
        ),
      ),
    );
  }
}
