import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/material.dart';
import 'package:privo/app/common_widgets/privo_radio_list.dart';

import '../../theme/app_colors.dart';
import 'horizontal_radio_button_model.dart';

class HorizontalRadioButton<T> extends StatelessWidget {
  const HorizontalRadioButton({
    Key? key,
    required this.radioList,
    required this.title,
    required this.icon,
    this.isError = false,
    this.errorMessage = "",
    this.isMandatory = false,
    required this.onChanged,
    required this.isEnabled,
    required this.selectedValue,
  }) : super(key: key);

  final String title;
  final String icon;
  final bool isEnabled;
  final List<HorizontalRadioButtonModel> radioList;
  final dynamic selectedValue;
  final bool isError;

  /// To show red star near the label
  final bool isMandatory;
  final String errorMessage;
  final ValueChanged<T?> onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SvgPicture.asset(
          icon,
          width: 30,
        ),
        const SizedBox(
          width: 10,
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                ),
                child: RichText(
                  text: TextSpan(
                    style: const TextStyle(
                      fontSize: 10,
                      color: Color(0xFF707070),
                    ),
                    text: title,
                    children: [
                      TextSpan(
                        text: isMandatory ? '  *' : "",
                        style: const TextStyle(color: Colors.red),
                      )
                    ],
                  ),
                ),
              ),
              PrivoRadioList(
                  axisDirection: Axis.horizontal,
                  radioList: radioList,
                  isEnabled: isEnabled,
                  selectedValue: selectedValue,
                  onChanged: onChanged),
              if (isError)
                Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 5,
                    horizontal: 10,
                  ),
                  child: Text(
                    errorMessage,
                    style: const TextStyle(
                      color: Colors.red,
                      fontSize: 12,
                    ),
                  ),
                ),
            ],
          ),
        )
      ],
    );
  }
}
