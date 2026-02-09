import 'package:flutter/material.dart';
import 'package:privo/app/theme/app_colors.dart';

class HomePageButton extends StatelessWidget {
  final Function()? onPressed;
  final String title;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final bool isDisabled;
  final double borderWidth;
  final bool isOutlined;
  final EdgeInsets padding;
  final Color? titleColor;
  final double fontSize;

  const HomePageButton({
    Key? key,
    this.onPressed,
    required this.title,
    this.isDisabled = false,
    this.backgroundColor,
    this.fontSize = 10,
    this.foregroundColor,
    this.padding = const EdgeInsets.symmetric(horizontal: 31, vertical: 9),
    this.isOutlined = false,
    this.borderWidth = 0.8,
    this.titleColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: isDisabled ? null : onPressed,
      style: _buttonStyle(),
      child: _title(),
    );
  }

  Widget _title() {
    return FittedBox(
      child: Text(
        title,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: fontSize,
          color: titleColor ??
              (isDisabled ? Colors.grey : foregroundColor ?? navyBlueColor),
        ),
      ),
    );
  }

  ButtonStyle _buttonStyle() {
    return ButtonStyle(
      elevation: MaterialStateProperty.all<double>(0),
      minimumSize: MaterialStateProperty.all<Size>(Size.zero),
      padding: MaterialStateProperty.all<EdgeInsets>(padding),
      backgroundColor: MaterialStateProperty.all(isOutlined
          ? Colors.transparent
          : backgroundColor ?? lightGrayColor.withOpacity(0.2)),
      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      shape: MaterialStateProperty.all(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
          side: BorderSide(
            color: isDisabled ? Colors.grey : foregroundColor ?? navyBlueColor,
            width: borderWidth,
          ),
        ),
      ),
    );
  }
}
