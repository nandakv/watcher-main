import 'package:flutter/material.dart';
import 'package:privo/app/theme/app_colors.dart';

import 'selection_chip_model.dart';

class SelectionChipWidget extends StatelessWidget {
  SelectionChipWidget(
      {super.key,
      required this.selectionChips,
        required this.selectedIndex,
      this.scrollAxis = Axis.horizontal});

  List<SelectionChipModel> selectionChips = [];
  Axis scrollAxis;
  int selectedIndex;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.start,
      direction: scrollAxis,
      spacing: 8,
      children: List.generate(selectionChips.length,
          (index) => _selectionChip(selectionChips[index])),
    );
  }

  InkWell _selectionChip(SelectionChipModel model) {
    return InkWell(
      onTap: () {
        model.onTap();
      },
      child: Container(
        decoration: BoxDecoration(
          color: selectedIndex == model.index  ? darkBlueColor : Colors.white,
          borderRadius: BorderRadius.circular(32),
          border: Border.all(color: darkBlueColor, width: 1),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        child: Text(
          model.title,
          style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 12,
              color: selectedIndex == model.index ? Colors.white : darkBlueColor),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
