import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:privo/app/common_widgets/spacer_widgets.dart';
import 'package:privo/app/theme/app_colors.dart';
import 'package:flutter/material.dart';

enum ButtonType {
  primary(
    color: navyBlueColor,
    disabledColor: lightGrayColor,
    textColor: Colors.white,
    loadingIndicatorColor: Colors.white,
    disabledTextColor: grey500,
    borderColor: navyBlueColor,
    disabledBorderColor: lightGrayColor,
  ),
  secondary(
    color: Colors.white,
    disabledColor: Colors.white,
    textColor: navyBlueColor,
    loadingIndicatorColor: darkBlueColor,
    disabledTextColor: grey500,
    borderColor: navyBlueColor,
    disabledBorderColor: grey500,
  ),
  tertiary(
    color: Colors.white,
    disabledColor: Colors.white,
    textColor: navyBlueColor,
    loadingIndicatorColor: darkBlueColor,
    disabledTextColor: grey500,
    borderColor: Colors.white,
    disabledBorderColor: Colors.white,
  );

  const ButtonType({
    required this.color,
    required this.disabledColor,
    required this.textColor,
    required this.loadingIndicatorColor,
    required this.disabledTextColor,
    required this.borderColor,
    required this.disabledBorderColor,
  });

  final Color color;
  final Color disabledColor;
  final Color textColor;
  final Color loadingIndicatorColor;
  final Color disabledTextColor;
  final Color borderColor;
  final Color disabledBorderColor;
}

enum ButtonSize {
  small(
      loaderSize: 14,
      loaderStrokeWidth: 1,
      borderRadius: 50,
      padding: EdgeInsets.symmetric(
        horizontal: 15,
        vertical: 8,
      ),
      textSize: 12,
      textHeight: 16,
      constraints: BoxConstraints(minWidth: 72, maxWidth: 120)),
  medium(
      loaderSize: 20,
      loaderStrokeWidth: 2,
      borderRadius: 50,
      padding: EdgeInsets.symmetric(
        horizontal: 15,
        vertical: 15,
      ),
      textSize: 16,
      textHeight: 22,
      constraints: BoxConstraints(minWidth: 120, maxWidth: 200)),
  modifiedMedium(
      loaderSize: 10,
      loaderStrokeWidth: 2,
      borderRadius: 32,
      padding: EdgeInsets.symmetric(
        horizontal: 15,
        vertical: 5,
      ),
      textSize: 14,
      textHeight: 20,
      constraints: BoxConstraints(minWidth: 120, maxWidth: 200)),
  large(
    loaderSize: 20,
    loaderStrokeWidth: 2,
    borderRadius: 50,
    padding: EdgeInsets.symmetric(
      horizontal: 15,
      vertical: 15,
    ),
    textSize: 16,
    textHeight: 22,
    constraints: BoxConstraints(minWidth: 200, maxWidth: 296),
    fillWidth: true,
  );

  const ButtonSize({
    required this.loaderSize,
    required this.loaderStrokeWidth,
    required this.borderRadius,
    required this.padding,
    required this.textSize,
    required this.textHeight,
    required this.constraints,
    this.fillWidth = false,
  });

  final double loaderSize;
  final double loaderStrokeWidth;
  final EdgeInsets padding;
  final double borderRadius;
  final double textSize;
  final double textHeight;
  final BoxConstraints constraints;
  final bool fillWidth;
}

class Button extends StatelessWidget {
  const Button({
    Key? key,
    this.title = "Continue",
    this.enabled = true,
    this.height,
    this.isLoading = false,
    this.onPressed,
    required this.buttonSize,
    required this.buttonType,
    this.onDisablePressed,
    this.icon,
    this.fillWidth =false,
  }) : super(key: key);

  final bool fillWidth;
  final double? height;
  final String title;
  final Function()? onPressed;
  final bool enabled;
  final bool isLoading;
  final Function()? onDisablePressed;
  final ButtonSize buttonSize;
  final ButtonType buttonType;
  final Widget? icon;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: enabled ? onPressed : onDisablePressed,
      child: Container(
        width: fillWidth || buttonSize.fillWidth ? double.infinity : null,
        padding: buttonSize.padding.w,
        height: height,
        constraints: buttonSize.constraints.hw,
        decoration: BoxDecoration(
          border: Border.all(
            color: enabled
                ? buttonType.borderColor
                : buttonType.disabledBorderColor,
          ),
          borderRadius: BorderRadius.circular(buttonSize.borderRadius.r),
          color: enabled ? buttonType.color : buttonType.disabledColor,
        ),
        child: _buttonChildWidget(),
      ),
    );
  }

  Widget _buttonChildWidget() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (icon != null) ...[
          icon!,
          HorizontalSpacer(4.w),
        ],
        _buttonTextWithLoaderWidget(),
      ],
    );
  }

  Widget _buttonTextWithLoaderWidget() {
    return Stack(
      alignment: Alignment.center,
      children: [_buttonTextWidget(), if (isLoading) _loadingWidget()],
    );
  }

  Widget _loadingWidget() {
    return SizedBox(
      height: buttonSize.loaderSize.h,
      width: buttonSize.loaderSize.r,
      child: CircularProgressIndicator(
        color: buttonType.loadingIndicatorColor,
        strokeWidth: buttonSize.loaderStrokeWidth.w,
      ),
    );
  }

  Widget _buttonTextWidget() {
    return Text(
      title,
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: buttonSize.textSize.sp,
        color: isLoading
            ? Colors.transparent
            : (enabled ? buttonType.textColor : buttonType.disabledTextColor),
        fontWeight: FontWeight.w600,
        height: buttonSize.textHeight.sp / buttonSize.textSize.sp,
      ),
    );
  }
}
