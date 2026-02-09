import 'package:privo/app/theme/app_colors.dart';
import 'package:flutter/material.dart';

///This widget is commonly used in most of the screens. It creates a big blue CTA
///button and accepts the title and button color to show if its active or not
class BlueButton extends StatelessWidget {
  const BlueButton(
      {Key? key,
      this.title = "Continue",
      required this.onPressed,
      required this.buttonColor,
      this.borderRadius = 10,
      this.isLoading,
      this.textPadding = 15,
      this.borderEnabled})
      : super(key: key);

  final String? title;
  final Function()? onPressed;
  final Color buttonColor;
  final double borderRadius;
  final bool? borderEnabled;
  final double textPadding;
  final bool? isLoading;

  @override
  Widget build(BuildContext context) {
    return isLoading ?? false
        ? const Center(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 10),
        child: SizedBox(
          height: 30,
          width: 30,
          child: CircularProgressIndicator(
            strokeWidth: 2,
          ),
        ),
      ),
    )
        : Material(
      color: Colors.transparent,
      child: InkWell(
        onTap:
        buttonColor == activeButtonColor || (borderEnabled ?? false)
            ? onPressed
            : null,
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 5),
          width: double.infinity,
          decoration: BoxDecoration(
              color: buttonColor,
              border: Border.all(
                  color:
                  (borderEnabled != null && borderEnabled == true)
                      ? activeButtonColor
                      : Colors.transparent,
                  width: 1),
              boxShadow: const [
                BoxShadow(
                    color: Color.fromRGBO(0, 0, 0, 0.16),
                    blurRadius: 6,
                    offset: Offset(0, 3))
              ],
              borderRadius: BorderRadius.circular(borderRadius)),
          child: Padding(
            padding:  EdgeInsets.symmetric(vertical: textPadding),
            child: Text(
              title!,
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color:
                  (borderEnabled != null && borderEnabled == true)
                      ? activeButtonColor
                      : buttonColor == activeButtonColor
                      ? Colors.white
                      : Colors.black12),
            ),
          ),
        ),
      ),
    );
  }
}
