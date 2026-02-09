import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:privo/app/common_widgets/spacer_widgets.dart';

import '../../components/radio_tile.dart';

class RadioSelectionWidget extends StatelessWidget {
  final List<String> radioList;
  final String selectedValue;
  final ValueChanged<String?> onChanged;
  const RadioSelectionWidget(
      {super.key,
      required this.radioList,
      required this.selectedValue,
      required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: radioList
          .expand(
            (e) => [
              RadioTile<String>(
                groupValue: selectedValue,
                label: e,
                value: e,
                onChange: onChanged,
              ),
              VerticalSpacer(16.h),
            ],
          )
          .toList()
        ..removeLast(),
    );
  }
}
