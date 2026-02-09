import 'package:google_fonts/google_fonts.dart';
import 'package:privo/app/modules/polling/gradient_circular_progress_indicator.dart';
import 'package:privo/app/theme/app_colors.dart';
import 'package:privo/app/theme/app_text_theme.dart';
import 'package:flutter/material.dart';

enum AppButtonTheme { light, dark }

class GradientButton extends StatelessWidget {
  const GradientButton(
      {Key? key,
      this.title = "Continue",
      this.enabled = true,
      this.isLoading = false,
      this.buttonTheme = AppButtonTheme.dark,
      required this.onPressed,
      this.bottomPadding = 10,
      this.fillWidth = true,
      this.titleTextStyle,
        this.edgeInsets,
        this.gradient,
      this.onDisablePressed})
      : super(key: key);

  final String title;
  final Function onPressed;
  final bool enabled;
  final bool isLoading;
  final Function? onDisablePressed;
  final AppButtonTheme buttonTheme;
  final double bottomPadding;
  final bool fillWidth;
  final TextStyle? titleTextStyle;
  final EdgeInsets? edgeInsets;
  final Gradient? gradient;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: bottomPadding),
      child: isLoading
          ? RotationTransitionWidget(
              loadingState: LoadingState.bottomLoader,
              buttonTheme: buttonTheme,
            )
          : InkWell(
              onTap: () {
                if (enabled) {
                  onPressed();
                } else {
                  _onDisabled();
                }
              },
              child: Opacity(
                opacity: _computeOpacity(),
                child: Container(
                  width: fillWidth ? double.infinity : null,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(80),
                    color: _computeButtonColor(),
                    gradient: gradient,
                    // color:  enabled ? navyBlueColor : lightGrayColor
                  ),
                  child: Padding(
                    padding: edgeInsets ?? const EdgeInsets.symmetric(
                      vertical: 16,
                      horizontal: 10,
                    ),
                    child: Text(
                      title,
                      textAlign: TextAlign.center,
                      style: titleTextStyle ?? _buttonTextStyle(title),
                    ),
                  ),
                ),
              ),
            ),
    );
  }

  void _onDisabled() {
    if (onDisablePressed != null) {
      onDisablePressed!();
    }
  }

  LinearGradient _computeGradientOnButtonType() {
    return LinearGradient(
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
      colors: _computeGradientColor(),
    );
  }

  Color _computeButtonColor(){
    if(enabled){
      return navyBlueColor;
    }
    else{
      return lightGrayColor;
    }
  }

  List<Color> _computeGradientColor() {
    if (enabled) {
      return _computeGradientTheme();
    } else {
      return _disabledGradient();
    }
  }

  _computeGradientTheme() {
    switch (buttonTheme) {
      case AppButtonTheme.light:
        return _lightEnabledGradient();
      case AppButtonTheme.dark:
        return _darkEnabledGradient();
    }
  }

  List<Color> _lightEnabledGradient() {
    return [
      preRegistrationEnabledGradientColor2,
      preRegistrationEnabledGradientColor3
    ];
  }

  List<Color> _disabledGradient() {
    return [
      preRegistrationDisabledGradientColor2,
      preRegistrationDisabledGradientColor2
    ];
  }

  List<Color> _darkEnabledGradient() {
    return [
      navyBlueColor,
      navyBlueColor,
    ];
  }

  Color _computeTextColor(String title) {
    if (enabled) {
      return _getEnabledButtonColor();
    } else {
      return secondaryDarkColor;
    }
  }

  Color _getEnabledButtonColor() {
    switch (buttonTheme) {
      case AppButtonTheme.light:
        return lightEnabledButtonTextColor;
      case AppButtonTheme.dark:
        return darkEnabledButtonTextColor;
    }
  }

  TextStyle _buttonTextStyle(String title) {
    return GoogleFonts.poppins(
      fontSize: 14,
      color: _computeTextColor(title),
      fontWeight: FontWeight.w500,
    );
  }

  _computeOpacity() {
    switch (buttonTheme) {
      case AppButtonTheme.light:
        return enabled ? 1.0 : 0.54;
      case AppButtonTheme.dark:
        return 1.0;
    }
  }
}
