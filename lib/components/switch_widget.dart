import 'package:flutter/material.dart';
import 'package:privo/app/theme/app_colors.dart';

enum SwitchType {
  enabled(color: darkBlueColor),
  disabled(color: grey500);

  const SwitchType({required this.color});
  final Color color;
}

class SwitchWidget extends StatelessWidget {
  final bool value;
  final SwitchType switchType;
  final void Function(bool)? onChanged;
  const SwitchWidget({
    super.key,
    required this.value,
    this.onChanged,
    this.switchType = SwitchType.enabled,
  });

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      ignoring: switchType == SwitchType.disabled,
      child: Switch(
        value: value,
        onChanged: onChanged,
        inactiveThumbColor: switchType.color,
        inactiveTrackColor: Colors.transparent,
        activeTrackColor: switchType.color,
        activeColor: Colors.white,
        trackOutlineColor: MaterialStateProperty.all(switchType.color),
      ),
    );
  }
}
