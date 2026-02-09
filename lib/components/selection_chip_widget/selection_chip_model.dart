import 'package:flutter/material.dart';

class SelectionChipModel {
  String title;

  void Function() onTap;
  int index;

  SelectionChipModel(
      {
      required this.title,
        required this.index,
      required this.onTap});
}
