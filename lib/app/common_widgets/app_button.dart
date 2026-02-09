import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:privo/app/theme/app_colors.dart';

class AppButton extends StatelessWidget {
  const AppButton({
    Key? key,
    this.enabled = true,
    this.loading = false,
    this.title = "Continue",
    required this.onPressed,
    this.padding,
  }) : super(key: key);

  final bool loading;
  final bool enabled;
  final String title;
  final Function() onPressed;
  final EdgeInsets? padding;

  @override
  Widget build(BuildContext context) {
    return loading
        ? const _LoadingIndicator()
        : _BlueButton(
            enabled: enabled,
            onPressed: onPressed,
            title: title,
            padding: padding,
          );
  }
}

class _LoadingIndicator extends StatelessWidget {
  const _LoadingIndicator({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: SizedBox(
        height: 30,
        child: Center(
          child: SizedBox(
            height: 30,
            width: 30,
            child: CircularProgressIndicator(
              strokeWidth: 2,
            ),
          ),
        ),
      ),
    );
  }
}

class _BlueButton extends StatelessWidget {
  const _BlueButton({
    Key? key,
    required this.enabled,
    required this.onPressed,
    required this.title,
    this.padding,
  }) : super(key: key);

  final bool enabled;
  final Function() onPressed;
  final String title;
  final EdgeInsets? padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: padding,
      child: ElevatedButton(
        style: _buttonStyle(),
        onPressed: enabled ? onPressed : null,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 15),
          child: Text(
            title,
            style: GoogleFonts.montserrat(
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  ButtonStyle _buttonStyle() {
    return ButtonStyle(
      backgroundColor: MaterialStateProperty.resolveWith(_buttonColor),
      foregroundColor: MaterialStateProperty.all(Colors.white),
      elevation: MaterialStateProperty.all(enabled ? 8 : 0),
      shape: MaterialStateProperty.all(_buttonRadius()),
    );
  }

  RoundedRectangleBorder _buttonRadius() =>
      RoundedRectangleBorder(borderRadius: BorderRadius.circular(10));

  Color? _buttonColor(Set<MaterialState> states) {
    if (states.contains(MaterialState.disabled)) {
      return inactiveButtonColor;
    } else {
      return activeButtonColor;
    }
  }

  Color? _textColor(Set<MaterialState> states) {
    if (states.contains(MaterialState.disabled)) {
      return Colors.black12;
    } else {
      return Colors.white;
    }
  }
}
