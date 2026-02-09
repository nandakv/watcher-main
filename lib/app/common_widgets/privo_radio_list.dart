import 'package:flutter/material.dart';
import 'package:privo/app/common_widgets/horizontal_radio_button/horizontal_radio_button_model.dart';
import 'package:privo/app/theme/app_colors.dart';

class PrivoRadioList<T> extends StatelessWidget {
  final Axis axisDirection;
  final List<HorizontalRadioButtonModel> radioList;
  final dynamic selectedValue;
  final ValueChanged<T?> onChanged;
  final bool isEnabled;


  const PrivoRadioList(
      {Key? key,
      required this.axisDirection,
        required this.isEnabled,
      required this.radioList,
      required this.selectedValue,
      required this.onChanged})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return (axisDirection == Axis.vertical)
        ? _verticalRadioList()
        : _horizontalRadioList();
  }

  Widget _horizontalRadioList() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: radioList
          .map((e) => _radioCard(
                title: e.title,
                value: e.value,
                flex: 1,
                groupValue: selectedValue,
              ))
          .toList(),
    );
  }

  Widget _verticalRadioList() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: radioList
          .map((e) => _radioCard(
                title: e.title,
                value: e.value,
                flex: 0,
                groupValue: selectedValue,
              ))
          .toList(),
    );
  }

  Widget _radioCard(
      {required String title,
      required dynamic value,
      required dynamic groupValue,
      required int flex}) {
    return ListTileTheme(
      horizontalTitleGap: 0,
      contentPadding: const EdgeInsets.all(0),
      dense: true,
      minVerticalPadding: 0,
      iconColor: activeButtonColor,
      child: Expanded(
        flex: flex,
        child: RadioListTile<T>(
          value: value,
          controlAffinity: ListTileControlAffinity.platform,
          groupValue: groupValue,
          title: FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(
              title,
              style: const TextStyle(
                color: Color(0xFF1D478E),
                fontSize: 14,
                letterSpacing: 0.22,
              ),
            ),
          ),
          onChanged: (value) {
            if(isEnabled) {
              onChanged(value);
            }
          },
        ),
      ),
    );
  }
}
