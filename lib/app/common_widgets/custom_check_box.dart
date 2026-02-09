import 'package:flutter/material.dart';

class CustomCheckbox extends StatefulWidget {
  CustomCheckbox({
    Key? key,
    this.width = 24.0,
    this.height = 24.0,
    this.color,
    this.iconSize,
    this.onChanged,
    this.checkColor,
    required this.isChecked
  }) : super(key: key);

  final double width;
  final double height;
  final Color? color;
  final double? iconSize;
  final Color? checkColor;
  final Function(bool?)? onChanged;
  bool isChecked;

  @override
  State<CustomCheckbox> createState() => _CustomCheckboxState();
}

class _CustomCheckboxState extends State<CustomCheckbox> {

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        widget.isChecked = !widget.isChecked;
        widget.onChanged?.call(widget.isChecked);
      },
      child: Container(
        width: widget.width,
        height: widget.height,
        decoration: BoxDecoration(
          color: widget.isChecked ? widget.color : Colors.white,
          border: Border.all(
            color: widget.color ?? Colors.grey.shade500,
            width: 0.7,
          ),
          borderRadius: BorderRadius.circular(6.0),
        ),
        child: widget.isChecked
            ? Icon(
          Icons.check_rounded,
          size: widget.iconSize,
          color: widget.checkColor,
        )
            : null,
      ),
    );
  }
}