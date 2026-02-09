import 'package:privo/app/theme/app_colors.dart';
import 'package:flutter/material.dart';

class PrivoButton extends StatelessWidget {
  const PrivoButton(
      {Key? key,
      this.title = "Continue",
      this.enabled = true,
      this.isLoading = false,
      required this.onPressed,
      this.bottomPadding = 10,
      this.fillWidth = true,
      this.titleTextStyle,
      this.onDisablePressed})
      : super(key: key);

  final String title;
  final Function onPressed;
  final bool enabled;
  final bool isLoading;
  final Function? onDisablePressed;
  final double bottomPadding;
  final bool fillWidth;
  final TextStyle? titleTextStyle;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: bottomPadding),
      child: isLoading
          ? _loadingWidget()
          : InkWell(
              onTap: onTap,
              child: Container(
                width: fillWidth ? double.infinity : null,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(54),
                  color: enabled ? navyBlueColor : lightGrayColor,
                ),
                child: _buttonTextWidget(),
              ),
            ),
    );
  }

  void onTap() {
    if (enabled) {
      onPressed();
    } else {
      _onDisabled();
    }
  }

  Widget _buttonTextWidget() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 10),
      child: Text(
        title,
        textAlign: TextAlign.center,
        style: titleTextStyle ?? _buttonTextStyle(title),
      ),
    );
  }

  Widget _loadingWidget() {
    return const Center(
      child: CircularProgressIndicator(
        color: darkBlueColor,
      ),
    );
  }

  void _onDisabled() {
    if (onDisablePressed != null) {
      onDisablePressed!();
    }
  }

  Color _computeTextColor(String title) {
    if (enabled) {
      return Colors.white;
    } else {
      return secondaryDarkColor;
    }
  }

  TextStyle _buttonTextStyle(String title) {
    return TextStyle(
      fontSize: 14,
      color: _computeTextColor(title).withOpacity(enabled ? 1.0 : 0.5),
      fontWeight: FontWeight.w600,
    );
  }
}
